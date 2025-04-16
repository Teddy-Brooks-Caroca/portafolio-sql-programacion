-- **6 Triggers y Funciones**

-- 1. Crea un `TRIGGER` que registre cambios en el salario de un empleado en la tabla `HistorialSalarios`. 

CREATE TRIGGER tr_RegistrarCambioSalario
ON Empleados
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF UPDATE(Salario)
    BEGIN
        INSERT INTO HistorialSalarios (
            EmpleadoID,
            SalarioAnterior,
            SalarioNuevo,
            FechaCambio
        )
        SELECT 
            i.ID,             
            d.Salario,          
            i.Salario,          
            GETDATE()           
        FROM 
            inserted i
        INNER JOIN 
            deleted d ON i.ID = d.ID
        WHERE 
            i.Salario <> d.Salario; 
    END
END;

SELECT * FROM Empleados;

UPDATE Empleados SET Salario = 48000 WHERE ID = 7;

SELECT * FROM HistorialSalarios;

-- 2. Crea un `TRIGGER` que impida la eliminación de empleados asignados a un proyecto.  

CREATE TRIGGER tr_empleados_proyectos 
ON Empleados
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Asignaciones WHERE EmpleadoID IN (SELECT ID FROM deleted))
    BEGIN 
        RAISERROR('No se puede eliminar: empleado(s) están asignados a proyectos', 16, 1);
        RETURN;  
    END
    ELSE 
    BEGIN 
        DELETE FROM Empleados 
        WHERE ID IN (SELECT ID FROM deleted);
    END
END;

SELECT name FROM sys.triggers WHERE name = 'tr_empleados_proyectos';

DELETE FROM Empleados WHERE ID = 24;

SELECT * FROM Empleados WHERE ID = 24; --No debería aparecer

DELETE FROM Empleados WHERE ID = 1; --Apareció mensaje

-- 3. Implementa una función que reciba un salario y devuelva la categoría salarial (`Bajo`, `Medio`, `Alto`).  

CREATE FUNCTION dbo.FN_CategoriaSalarial (@Salario MONEY)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Categoria VARCHAR(20);
    
    SET @Categoria = CASE
        WHEN @Salario <= 200000 THEN 'Bajo'
        WHEN @Salario BETWEEN 200001 AND 350000 THEN 'Medio'
        WHEN @Salario > 350000 THEN 'Alto'
    END;
    
    RETURN @Categoria;
END;


SELECT dbo.FN_CategoriaSalarial(250000);

SELECT
	Nombre,
	Salario,
	dbo.FN_CategoriaSalarial(Salario) AS Categoria
FROM
	Empleados;

-- 4. Crea una función que calcule el número de años que un empleado ha trabajado en la empresa.  

CREATE FUNCTION dbo.FN_AniosTranscurridos(@EmpleadoID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Anios INT;
	DECLARE @FechaIngreso DATE;

	SELECT @FechaIngreso = FechaIngreso 
    FROM Empleados 
    WHERE ID = @EmpleadoID;

	SET @Anios = DATEDIFF(YEAR, @FechaIngreso, GETDATE());

	IF DATEADD(YEAR, @Anios, @FechaIngreso) > GETDATE()
        SET @Anios = @Anios - 1;

	RETURN @Anios
END;

-- Para un empleado específico (ej: ID = 5)
SELECT dbo.FN_AniosTranscurridos(5) AS AñosTrabajados;

-- Para todos los empleados
SELECT 
    ID,
    Nombre,
    dbo.FN_AniosTranscurridos(ID) AS AñosEnLaEmpresa
FROM Empleados;

-- 5. Usa funciones del sistema para formatear fechas (`GETDATE()`, `DATEPART()`).

SELECT 
    Nombre,
    FechaIngreso,
    CONVERT(VARCHAR, FechaIngreso, 103) AS Fecha_Ingreso_Formateada,
    DATEDIFF(YEAR, FechaIngreso, GETDATE()) AS Años_En_Empresa,
    DATENAME(MONTH, FechaIngreso) AS Mes_Ingreso,
    DATENAME(WEEKDAY, FechaIngreso) AS Dia_Ingreso,
	DATEPART(Q,FechaIngreso) AS Trimestre_ingreso
FROM 
    Empleados;

-- 6. Implementa una conversión de tipos de datos (`CAST`, `CONVERT`).  

SELECT 
    GETDATE() AS FechaActual,
    CONVERT(VARCHAR, GETDATE(), 103) AS Formato_Europeo,
    FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS Formato_ISO;

-- 7. Crea una función de usuario que devuelva el total de empleados en un departamento.  

CREATE FUNCTION dbo.UDF_TotalEmpleadosPorDepto (@DepartamentoID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalEmpleados INT;
    
    SELECT @TotalEmpleados = COUNT(*) 
    FROM Empleados
    WHERE DepartamentoID = @DepartamentoID;
    
    RETURN ISNULL(@TotalEmpleados, 0); -- Evita NULL si el departamento no existe
END;

-- Verifica cuántos empleados tiene el departamento con ID = 2
SELECT dbo.UDF_TotalEmpleadosPorDepto(2) AS TotalEmpleados;

--  Lista todos los departamentos con su cantidad
SELECT 
    d.ID,
    d.Nombre,
    dbo.UDF_TotalEmpleadosPorDepto(d.ID) AS Cantidad_Empleados
FROM Departamentos d;

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::