-- ### PORTAFOLIO PROGRAMACIÓN EN SQL ###
/*
Se trabajará con las siguientes tablas para simular una empresa:  

1. **Empleados** (ID, Nombre, Edad, DepartamentoID, Salario, FechaIngreso)  
2. **Departamentos** (ID, Nombre)  
3. **Proyectos** (ID, Nombre, Presupuesto)  
4. **Asignaciones** (ID, EmpleadoID, ProyectoID, FechaAsignacion)  
5. **HistorialSalarios** (ID, EmpleadoID, SalarioAnterior, SalarioNuevo, FechaCambio)  
*/


-- **1️ Consultas Básicas en SQL Server**

-- 1. Crea la base de datos y las tablas mencionadas arriba.

CREATE DATABASE Mancora_enterpise;

CREATE TABLE Departamentos (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Empleados (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(60) NOT NULL,
    Edad INT NOT NULL,
    DepartamentoID INT NOT NULL,
    Salario MONEY NOT NULL,
    FechaIngreso DATE NOT NULL,
    FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(ID)
);

CREATE TABLE Proyectos (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Presupuesto MONEY NOT NULL
);

CREATE TABLE Asignaciones (
    ID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT NOT NULL,
    ProyectoID INT NOT NULL,
    FechaAsignacion DATE NOT NULL,
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(ID),
    FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ID)
);

CREATE TABLE HistorialSalarios (
    ID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT NOT NULL,
    SalarioAnterior MONEY NOT NULL,
    SalarioNuevo MONEY NOT NULL,
    FechaCambio DATE NOT NULL,
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(ID)
);


-- 2. Inserta al menos 15 empleados, 5 departamentos, 5 proyectos y 20 asignaciones de empleados a proyectos.  

-- Insertar Departamentos
INSERT INTO Departamentos (Nombre) VALUES 
('Recursos Humanos'),
('Finanzas'),
('Tecnología'),
('Marketing'),
('Ventas');

-- Insertar Empleados
INSERT INTO Empleados (Nombre, Edad, DepartamentoID, Salario, FechaIngreso) VALUES 
('Juan Pérez', 35, 1, 45000, '2020-03-15'),
('María López', 29, 2, 55000, '2019-07-22'),
('Carlos Rodríguez', 42, 3, 70000, '2018-05-10'),
('Ana Gómez', 31, 4, 48000, '2021-01-05'),
('Pedro Sánchez', 38, 5, 52000, '2017-09-18'),
('Laura Fernández', 26, 3, 62000, '2022-06-11'),
('Roberto Díaz', 45, 1, 46000, '2016-02-20'),
('Sofía Ramírez', 33, 2, 53000, '2019-11-30'),
('Luis Herrera', 37, 4, 50000, '2020-08-25'),
('Gabriela Torres', 28, 5, 51000, '2023-04-12'),
('Fernando Castro', 40, 3, 68000, '2015-12-01'),
('Andrea Morales', 27, 1, 44000, '2021-05-20'),
('Daniel Vargas', 36, 2, 56000, '2018-09-14'),
('Patricia Méndez', 32, 4, 47000, '2020-11-05'),
('Javier Soto', 39, 5, 53000, '2017-07-19');

-- Insertar Proyectos
INSERT INTO Proyectos (Nombre, Presupuesto) VALUES 
('Proyecto Alpha', 150000),
('Proyecto Beta', 200000),
('Proyecto Gamma', 175000),
('Proyecto Delta', 250000),
('Proyecto Épsilon', 300000);

-- Insertar Asignaciones de empleados a proyectos
INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion) VALUES 
(1, 1, '2023-01-10'),
(2, 2, '2023-02-15'),
(3, 3, '2023-03-20'),
(4, 4, '2023-04-25'),
(5, 5, '2023-05-30'),
(6, 1, '2023-06-05'),
(7, 2, '2023-07-10'),
(8, 3, '2023-08-15'),
(9, 4, '2023-09-20'),
(10, 5, '2023-10-25'),
(11, 1, '2023-11-30'),
(12, 2, '2024-01-05'),
(13, 3, '2024-02-10'),
(14, 4, '2024-03-15'),
(15, 5, '2024-04-20'),
(1, 2, '2024-05-25'),
(2, 3, '2024-06-30'),
(3, 4, '2024-07-05'),
(4, 5, '2024-08-10'),
(5, 1, '2024-09-15');

-- 3. Consulta todos los empleados con su departamento correspondiente.  

SELECT 
	EM.Nombre AS 'Empleado', 
	DP.Nombre AS 'Departamento' 
FROM 
	empleados EM 
	JOIN departamentos DP ON EM.DepartamentoID = DP.ID 
ORDER BY 
	Departamento;

-- 4. Muestra los empleados que ingresaron después del año 2020.

SELECT * FROM empleados WHERE YEAR(FechaIngreso)> 2020;

-- 5. Encuentra los empleados cuyo salario esté entre $20000 y $50000.

SELECT * FROM empleados WHERE Salario BETWEEN 20000 AND 50000;

-- 6. Ordena los empleados por salario en orden descendente. 

SELECT * FROM empleados ORDER BY Salario DESC;

-- 7. Muestra los empleados que aún no están asignados a ningún proyecto.  

SELECT
	asignaciones.EmpleadoID AS 'ID_empleado',
	empleados.Nombre AS 'Empleado',
	proyectos.Nombre AS 'Proyecto'
FROM 
	empleados  
	JOIN asignaciones ON empleados.ID = asignaciones.EmpleadoID  
	LEFT JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
ORDER BY
	Proyecto;

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

--  **2 Agrupación de Datos**

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

-- **3 Relaciones y JOINS**

-- 1. Muestra una lista de empleados junto con su departamento y los proyectos en los que trabajan.  

SELECT 
	empleados.Nombre AS 'Empleado',
	departamentos.Nombre AS 'Departamento',
	proyectos.Nombre AS 'Proyecto_asignado'
FROM 
	empleados 
	JOIN asignaciones ON empleados.ID = asignaciones.EmpleadoID
	JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
	JOIN departamentos ON empleados.DepartamentoID = departamentos.ID
ORDER BY
	Departamento,
	Proyecto_asignado;

-- 2. Usa `LEFT JOIN` para mostrar los empleados y, si tienen proyectos asignados, el nombre del proyecto.  

SELECT 
	empleados.Nombre as 'Empleado',
	proyectos.nombre as 'Proyecto_asignado'
FROM 
	empleados 
	LEFT JOIN asignaciones ON empleados.ID = asignaciones.EmpleadoID
	JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
ORDER BY
	Proyecto_asignado;

-- 3. Usa `RIGHT JOIN` para mostrar todos los proyectos, incluso si no tienen empleados asignados.  

SELECT 
	proyectos.nombre as 'Proyecto_asignado',
	empleados.Nombre as 'Empleado'
FROM 
	asignaciones 
	RIGHT JOIN empleados ON asignaciones.EmpleadoID = empleados.ID
	JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
ORDER BY
	Proyecto_asignado;

-- 4. Usa `FULL JOIN` para obtener una lista combinada de empleados y proyectos.

SELECT 
	proyectos.nombre as 'Proyecto_asignado',
	empleados.Nombre as 'Empleado'
FROM 
	asignaciones 
	FULL JOIN empleados ON asignaciones.EmpleadoID = empleados.ID
	FULL JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
ORDER BY
	Proyecto_asignado;

-- 5. Encuentra los empleados que no están en ningún proyecto usando `OUTER APPLY`. 

SELECT 
    empleados.ID,
    empleados.Nombre
FROM 
    Empleados 
    OUTER APPLY (
        SELECT TOP 1 asignaciones.ProyectoID
        FROM Asignaciones 
        WHERE asignaciones.EmpleadoID = empleados.ID
    ) AS Proyecto
WHERE
    Proyecto.ProyectoID IS NULL;

-- 6. Usa `CTE` para obtener los 3 empleados con mayor salario en cada departamento. 

WITH TopEmpleados AS (
    SELECT 
        e.ID,
        e.Nombre,
        e.Salario,
        e.DepartamentoID,
        ROW_NUMBER() OVER (PARTITION BY e.DepartamentoID ORDER BY e.Salario DESC) AS TopSalario
    FROM 
        Empleados e
)
SELECT 
    t.ID,
    t.Nombre,
    t.Salario,
    d.Nombre AS Departamento
FROM 
    TopEmpleados t
    JOIN Departamentos d ON t.DepartamentoID = d.ID
WHERE 
    t.TopSalario <= 3
ORDER BY 
    t.DepartamentoID, 
    t.TopSalario;

-- 7. Muestra los empleados cuyo salario es superior al promedio de su departamento (subconsulta).  

SELECT * FROM empleados WHERE salario >
(SELECT AVG(Salario) FROM empleados WHERE departamentoID = empleados.departamentoID);

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- **4️ Operaciones DML (Manipulación de Datos)**

-- 1. Inserta nuevos empleados en la tabla utilizando `INSERT`.  
-- 2. Modifica el salario de un empleado con `UPDATE`.  
-- 3. Elimina un empleado con `DELETE`.  
-- 4. Borra todos los datos de una tabla sin eliminar su estructura (`TRUNCATE`).  
-- 5. Usa `EXISTS` para verificar si un empleado tiene asignaciones antes de eliminarlo.  
-- 6. Crea una subconsulta que devuelva el ID del departamento con el salario promedio más alto.  
-- 7. Usa una subconsulta correlacionada para encontrar el empleado con el salario más alto en cada departamento.  

---

### **5️⃣ Procedimientos Almacenados y Variables**
1. Crea un procedimiento almacenado que inserte un nuevo empleado.  
2. Crea un procedimiento que devuelva los detalles de un empleado por ID.  
3. Usa variables para calcular y almacenar temporalmente el total de salarios de un departamento.  
4. Implementa un bloque `BEGIN...END` para realizar múltiples inserciones.  
5. Crea un procedimiento que aumente el salario de los empleados según su antigüedad.  
6. Implementa un cursor para recorrer empleados y calcular bonificaciones anuales.  
7. Crea un procedimiento que realice una transacción y, si falla, haga `ROLLBACK`.  

---

### **6️⃣ Triggers y Funciones**
1. Crea un `TRIGGER` que registre cambios en el salario de un empleado en la tabla `HistorialSalarios`.  
2. Crea un `TRIGGER` que impida la eliminación de empleados asignados a un proyecto.  
3. Implementa una función que reciba un salario y devuelva la categoría salarial (`Bajo`, `Medio`, `Alto`).  
4. Crea una función que calcule el número de años que un empleado ha trabajado en la empresa.  
5. Usa funciones del sistema para formatear fechas (`GETDATE()`, `DATEPART()`).  
6. Implementa una conversión de tipos de datos (`CAST`, `CONVERT`).  
7. Crea una función de usuario que devuelva el total de empleados en un departamento.  

---

### **7️⃣ Transacciones y Manejo de Errores**
1. Implementa una transacción que registre una nueva contratación y su primera asignación.  
2. Usa `SAVEPOINT` para dividir una transacción en partes y permitir reversión parcial.  
3. Implementa `TRY...CATCH` para capturar errores en una operación de inserción.  
4. Captura errores de violación de clave foránea en una transacción.  
5. Crea una tabla de errores y almacena registros cuando ocurra un error.  
6. Usa `PIVOT` para transformar filas en columnas en una consulta de empleados por departamento.  
7. Usa `UNPIVOT` para transformar columnas en filas en un reporte de salarios.  


