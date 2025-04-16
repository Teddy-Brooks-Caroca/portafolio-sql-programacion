--  ** 2 Agrupación de Datos **

-- 1. Cuenta cuántos empleados hay en cada departamento.

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

-- 3. Encuentra el departamento con el mayor número de empleados. 

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

-- 4. Obtén el presupuesto total de todos los proyectos activos.  

SELECT sum(Presupuesto) AS 'Presupuesto total de los proyectos' FROM proyectos;

-- 5. Usa `GROUP BY` para mostrar el salario promedio por departamento, pero solo para aquellos con más de 3 empleados (`HAVING`).  

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
('Hugo Martínez', 50, 'Finanzas', 60000, '2010-04-12', '2022-06-30', 'Jubilación'),
('Elena Ríos', 45, 'Recursos Humanos', 47000, '2015-07-20', '2023-01-15', 'Cambio de empleo'),
('Ricardo López', 38, 'Tecnología', 75000, '2017-09-05', '2023-08-10', 'Renuncia voluntaria'),
('Carmen Díaz', 41, 'Marketing', 49000, '2012-11-10', '2021-12-31', 'Reducción de personal'),
('José Torres', 55, 'Ventas', 52000, '2008-06-15', '2022-04-01', 'Jubilación'),
('Beatriz Morales', 36, 'Finanzas', 58000, '2016-03-22', '2023-05-05', 'Cambio de empleo'),
('Andrés Gómez', 40, 'Tecnología', 72000, '2014-02-14', '2022-09-18', 'Renuncia voluntaria'),
('Marta Sánchez', 42, 'Marketing', 50000, '2013-08-30', '2023-07-25', 'Reducción de personal'),
('Javier Ramírez', 48, 'Recursos Humanos', 46000, '2009-12-10', '2021-10-20', 'Jubilación'),
('Patricia Herrera', 39, 'Ventas', 51000, '2015-05-25', '2023-03-11', 'Cambio de empleo');

SELECT Nombre, FechaIngreso FROM empleados
UNION ALL
SELECT Nombre,FechaIngreso FROM EmpleadosAntiguos;

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::