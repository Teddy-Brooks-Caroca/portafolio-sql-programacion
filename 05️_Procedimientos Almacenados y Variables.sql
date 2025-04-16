-- ** 5️ Procedimientos Almacenados y Variables **

-- 1. Crea un procedimiento almacenado que inserte un nuevo empleado.

CREATE PROCEDURE dbo.Insertar_empleado
(
	@Nombre VARCHAR(60),
    @Edad INT,
    @DepartamentoID INT,
    @Salario MONEY,
    @FechaIngreso DATE
)
AS
BEGIN

INSERT INTO empleados(Nombre,Edad,DepartamentoID,Salario,FechaIngreso)
VALUES
(@Nombre,@Edad,@DepartamentoID,@Salario,@FechaIngreso);

END;

EXECUTE dbo.Insertar_empleado 'Juan Robledo', 25, 3, 520000, '2025-03-27';

SELECT * FROM empleados WHERE Nombre = 'Juan Robledo';

-- 2. Crea un procedimiento que devuelva los detalles de un empleado por ID.

CREATE PROCEDURE dbo.empleado_por_ID
(
@ID INT
)
AS
BEGIN
	SELECT
		*
	FROM
		empleados
	WHERE
		ID = @ID;
END;

EXECUTE dbo.empleado_por_ID 7; 

-- 3. Usa variables para calcular y almacenar temporalmente el total de salarios de un departamento.  

DECLARE @Total INT;
SELECT @Total = SUM(Salario)
FROM empleados
WHERE DepartamentoID = 4;

SELECT @Total AS TotalSalarios;

-- 4. Implementa un bloque `BEGIN...END` para realizar múltiples inserciones. 

CREATE PROCEDURE dbo.nuevo_proyecto
(
@Nombre VARCHAR(50),
@Presupuesto INT
)
AS
BEGIN
	INSERT INTO Proyectos (Nombre,Presupuesto)
	VALUES
	(@Nombre,@Presupuesto);
END;

EXECUTE dbo.nuevo_proyecto 'Proyecto Etha', 350000;

-- 5. Crea un procedimiento que aumente el salario de los empleados según su antigüedad.  

CREATE PROCEDURE dbo.aumento_salario
(
@ID INT
)
AS
BEGIN
	UPDATE Empleados
	SET Salario = CASE
					WHEN DATEDIFF(YEAR, FechaIngreso, GETDATE()) < 1 THEN Salario * 1.05
					WHEN DATEDIFF(YEAR, FechaIngreso, GETDATE()) BETWEEN 1 AND 4 THEN Salario * 1.10
					WHEN DATEDIFF(YEAR, FechaIngreso, GETDATE()) >= 5 THEN Salario * 1.15
					ELSE Salario
				 END
	WHERE ID = @ID; 
END;

EXECUTE dbo.aumento_salario
		@ID = 22

SELECT * FROM empleados;

-- 6. Implementa un cursor para recorrer empleados y calcular bonificaciones anuales.  

DECLARE @Empleado VARCHAR(60), @Salario INT, @Annio_ingreso DATE,@Bonificacion VARCHAR(20);

DECLARE bonificaciones CURSOR
LOCAL FAST_FORWARD
FOR
	SELECT
		Nombre,
		Salario,
		FechaIngreso
	FROM
		Empleados

OPEN bonificaciones

FETCH NEXT FROM bonificaciones INTO @Empleado, @Salario, @Annio_ingreso;

WHILE @@FETCH_STATUS = 0

BEGIN
	SET @Bonificacion = CASE 
							WHEN DATEDIFF(YEAR, @Annio_ingreso, GETDATE()) < 1 THEN 'Bonificación Mínima'
							WHEN DATEDIFF(YEAR, @Annio_ingreso, GETDATE()) BETWEEN 1 AND 4 THEN 'Bonificación Parcial'
							WHEN DATEDIFF(YEAR, @Annio_ingreso, GETDATE()) >= 5 THEN 'Bonificación Máxima'
							ELSE 'Sin Bonificación'
						END;

	SELECT @Empleado AS Empleado, @Bonificacion AS Bonificación;

FETCH NEXT FROM bonificaciones INTO @Empleado, @Salario, @Annio_ingreso;
END;

CLOSE bonificaciones;
DEALLOCATE bonificaciones;

-- 7. Crea un procedimiento que realice una transacción y, si falla, haga `ROLLBACK`.  

CREATE PROCEDURE dbo.actualizar_datos_empleado
    @ID INT,
    @NuevoSalario INT,
    @NuevaFecha DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Empleados
        SET Salario = @NuevoSalario
        WHERE ID = @ID;

        UPDATE Empleados
        SET FechaIngreso = @NuevaFecha
        WHERE ID = @ID;

        COMMIT;
        PRINT 'Actualización exitosa.';
    END TRY

    BEGIN CATCH
        ROLLBACK;
        PRINT 'Error encontrado. Se realizó rollback.';
    END CATCH
END;

EXEC dbo.actualizar_datos_empleado
    @ID = 1,
    @NuevoSalario = 60000,
    @NuevaFecha = '2022-01-01';

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
