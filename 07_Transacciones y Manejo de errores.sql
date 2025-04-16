
--  **7️ Transacciones y Manejo de Errores**

-- 1. Implementa una transacción que registre una nueva contratación y su primera asignación. 

BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @NuevoEmpleadoID INT;
    

    INSERT INTO Empleados (Nombre, Edad, DepartamentoID, Salario, FechaIngreso)
    VALUES ('Hebaristo Moya', 55, 1, 589000, '2025-04-15');
    
   
    SET @NuevoEmpleadoID = SCOPE_IDENTITY();
    
  
    INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion)
    VALUES (@NuevoEmpleadoID, 5, '2025-04-15');
    
    COMMIT;
    PRINT 'Éxito: Empleado ID ' + CAST(@NuevoEmpleadoID AS VARCHAR) + ' creado y asignado.';
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK;
    PRINT 'Error: ' + ERROR_MESSAGE() + ' (Línea: ' + CAST(ERROR_LINE() AS VARCHAR) + ')';
END CATCH;

SELECT * FROM Empleados WHERE Nombre = 'Hebaristo Moya';

-- 2. Usa `SAVEPOINT` para dividir una transacción en partes y permitir reversión parcial. 

BEGIN TRANSACTION;
BEGIN TRY

    UPDATE Proyectos 
    SET Nombre = 'Proyecto Kappa2025'
    WHERE ID = 1;
    
    PRINT 'Nombre del proyecto actualizado.';
    
    SAVE TRANSACTION PuntoSeguro;
    
    UPDATE Empleados
    SET DepartamentoID = 3  
    WHERE ID IN (
        SELECT EmpleadoID 
        FROM Asignaciones 
        WHERE ProyectoID = 1
    );
    
    PRINT 'Participantes actualizados.';
    COMMIT;
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 AND XACT_STATE() = 1  
    BEGIN
        ROLLBACK TRANSACTION PuntoSeguro;
        PRINT 'Error al actualizar participantes: ' + ERROR_MESSAGE();
        PRINT '¡Pero el nombre del proyecto se mantuvo actualizado!';
        COMMIT;  
    END
    ELSE
    BEGIN
        IF @@TRANCOUNT > 0
            ROLLBACK;
        PRINT 'Error grave: ' + ERROR_MESSAGE();
    END
END CATCH;


-- 3. Implementa `TRY...CATCH` para capturar errores en una operación de inserción.

BEGIN TRY
    IF EXISTS (SELECT 1 FROM Proyectos WHERE Nombre = 'Proyecto Alpha2025')
        THROW 50002, 'Error: El nombre del proyecto ya existe', 1; 

    INSERT INTO Proyectos (Nombre, Presupuesto)
    VALUES ('Proyecto Alpha2025', 325000);
    
    PRINT 'Proyecto creado exitosamente.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK;
    
    IF ERROR_NUMBER() = 2627  
        PRINT 'Error: El proyecto ya existe. Elija otro nombre.';
    ELSE
        PRINT 'Error inesperado: ' + ERROR_MESSAGE();
END CATCH;

-- 4. Captura errores de violación de clave foránea en una transacción. 

BEGIN TRANSACTION; 
BEGIN TRY
    INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion) 
    VALUES (99, 1, GETDATE()); 
    
    COMMIT; 
    PRINT 'Asignación registrada correctamente.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK; 
    
    IF ERROR_NUMBER() = 547
        PRINT 'Error: El empleado o proyecto no existe. Verifica los IDs.';
    ELSE IF ERROR_NUMBER() = 515
        PRINT 'Error: La fecha de asignación es obligatoria.';
    ELSE
        PRINT 'Error inesperado: ' + ERROR_MESSAGE();
END CATCH;

-- 5. Crea una tabla de errores y almacena registros cuando ocurra un error. 

CREATE TABLE LogErroresEmpleados (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    FechaError DATETIME DEFAULT GETDATE(),
    Usuario VARCHAR(100) DEFAULT SUSER_NAME(),
    Procedimiento VARCHAR(100) NULL,  
    NumeroError INT,
    MensajeError VARCHAR(1000),
    LineaError INT,
    Accion VARCHAR(50) 
);

CREATE OR ALTER PROCEDURE dbo.ActualizarDepartamentoEmpleado
    @EmpleadoID INT,
    @NuevoDepartamentoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
         
            UPDATE Empleados
            SET DepartamentoID = @NuevoDepartamentoID
            WHERE ID = @EmpleadoID;
            
            PRINT 'Departamento actualizado correctamente.';
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        DECLARE @Accion VARCHAR(20) = 'UPDATE';
        DECLARE @MensajeError VARCHAR(1000) = ERROR_MESSAGE();
        
        IF ERROR_NUMBER() = 547  
            SET @MensajeError = 'Error: El departamento ' + CAST(@NuevoDepartamentoID AS VARCHAR) + ' no existe.';
        
        INSERT INTO LogErroresEmpleados (
            Procedimiento, 
            NumeroError, 
            MensajeError, 
            LineaError,
            Accion,
            Usuario
        )
        VALUES (
            'ActualizarDepartamentoEmpleado', 
            ERROR_NUMBER(), 
            @MensajeError, 
            ERROR_LINE(),
            @Accion,
            SUSER_NAME()
        );
        
        THROW 50002, @MensajeError, 1;
    END CATCH;
END;

EXEC dbo.ActualizarDepartamentoEmpleado 
    @EmpleadoID = 1,
    @NuevoDepartamentoID = 2;  

EXEC dbo.ActualizarDepartamentoEmpleado 
    @EmpleadoID = 1,
    @NuevoDepartamentoID = 99;

-- 6. Usa `PIVOT` para transformar filas en columnas en una consulta de empleados por departamento. 

SELECT 
    d.Nombre AS Departamento,
    e.ID AS EmpleadoID
FROM Empleados e
JOIN Departamentos d ON e.DepartamentoID = d.ID;  

SELECT *
FROM (
    SELECT 
        d.Nombre AS Departamento,
        e.ID AS EmpleadoID
    FROM Empleados e
    JOIN Departamentos d ON e.DepartamentoID = d.ID
) AS SourceTable
PIVOT (
    COUNT(EmpleadoID)  
    FOR Departamento IN ([Ventas], [TI], [Marketing], [Logística]) 
) AS PivotTable;

-- 7. Usa `UNPIVOT` para transformar columnas en filas en un reporte de salarios.  

SELECT 
    ID,
    Nombre,
    CAST(Salario AS MONEY) AS SalarioBase,
    CAST(Salario * 0.1 AS MONEY) AS Bono,      
    CAST(Salario * 0.05 AS MONEY) AS Comision  
INTO #TempSalarios_2025
FROM Empleados
WHERE DepartamentoID = 1;          

SELECT 
    ID,
    Nombre,
    TipoConcepto,
    Monto
FROM #TempSalarios_2025
UNPIVOT (
    Monto FOR TipoConcepto IN (SalarioBase, Bono, Comision)
) AS UnpivotTable;

DROP TABLE #TempSalarios_2025;

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::