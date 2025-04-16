--  ** 2 Agrupaci�n de Datos **

-- 1. Cuenta cu�ntos empleados hay en cada departamento.

SELECT
	departamentos.Nombre AS 'Departamento',
	COUNT(*) AS 'Cantidad de empleados'
FROM 
	empleados 
	JOIN departamentos ON empleados.DepartamentoID = departamentos.ID
GROUP BY
	departamentos.Nombre;

-- 2. Calcula el salario promedio de cada departamento.

SELECT
	departamentos.Nombre AS 'Departamento',
	AVG(empleados.Salario) AS 'Salario promedio relacion a empleados'
FROM 
	empleados 
	JOIN departamentos ON empleados.DepartamentoID = departamentos.ID
GROUP BY
	departamentos.Nombre;

-- 3. Encuentra el departamento con el mayor n�mero de empleados. 

SELECT TOP 1
    departamentos.Nombre AS 'Departamento',
    COUNT(*) AS 'Cantidad de empleados'
FROM 
    empleados 
JOIN 
    departamentos ON empleados.DepartamentoID = departamentos.ID
GROUP BY 
    departamentos.Nombre
ORDER BY 
    COUNT(*) DESC;

-- 4. Obt�n el presupuesto total de todos los proyectos activos.  

SELECT sum(Presupuesto) AS 'Presupuesto total de los proyectos' FROM proyectos;

-- 5. Usa `GROUP BY` para mostrar el salario promedio por departamento, pero solo para aquellos con m�s de 3 empleados (`HAVING`).  

SELECT
	departamentos.Nombre AS 'Departamento',
	AVG(empleados.Salario) AS 'Salario promedio'
FROM 
	empleados 
	JOIN departamentos ON empleados.DepartamentoID = departamentos.ID
GROUP BY
	departamentos.Nombre
HAVING
	COUNT(*) > 3;

-- 6. Usa `ROLLUP` para obtener subtotales por departamento y un total general.

SELECT 
	departamentos.Nombre, 
	SUM(empleados.Salario) AS 'Total Salarios' 
FROM 
	departamentos 
	JOIN empleados ON departamentos.ID = empleados.DepartamentoID 
GROUP BY 
	departamentos.Nombre WITH ROLLUP
ORDER BY
	departamentos.Nombre;

-- 7. Usa `UNION ALL` para combinar una lista de empleados actuales con empleados antiguos almacenados en otra tabla.  

-- Crear la tabla de empleados antiguos
CREATE TABLE EmpleadosAntiguos (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(60) NOT NULL,
    Edad INT NOT NULL,
    Departamento VARCHAR(50) NOT NULL,
    Salario MONEY NOT NULL,
    FechaIngreso DATE NOT NULL,
    FechaSalida DATE NOT NULL,
    MotivoSalida VARCHAR(100) NOT NULL
);

-- Insertar 10 empleados antiguos
INSERT INTO EmpleadosAntiguos (Nombre, Edad, Departamento, Salario, FechaIngreso, FechaSalida, MotivoSalida) VALUES 
('Hugo Mart�nez', 50, 'Finanzas', 60000, '2010-04-12', '2022-06-30', 'Jubilaci�n'),
('Elena R�os', 45, 'Recursos Humanos', 47000, '2015-07-20', '2023-01-15', 'Cambio de empleo'),
('Ricardo L�pez', 38, 'Tecnolog�a', 75000, '2017-09-05', '2023-08-10', 'Renuncia voluntaria'),
('Carmen D�az', 41, 'Marketing', 49000, '2012-11-10', '2021-12-31', 'Reducci�n de personal'),
('Jos� Torres', 55, 'Ventas', 52000, '2008-06-15', '2022-04-01', 'Jubilaci�n'),
('Beatriz Morales', 36, 'Finanzas', 58000, '2016-03-22', '2023-05-05', 'Cambio de empleo'),
('Andr�s G�mez', 40, 'Tecnolog�a', 72000, '2014-02-14', '2022-09-18', 'Renuncia voluntaria'),
('Marta S�nchez', 42, 'Marketing', 50000, '2013-08-30', '2023-07-25', 'Reducci�n de personal'),
('Javier Ram�rez', 48, 'Recursos Humanos', 46000, '2009-12-10', '2021-10-20', 'Jubilaci�n'),
('Patricia Herrera', 39, 'Ventas', 51000, '2015-05-25', '2023-03-11', 'Cambio de empleo');

SELECT Nombre, FechaIngreso FROM empleados
UNION ALL
SELECT Nombre,FechaIngreso FROM EmpleadosAntiguos;

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::