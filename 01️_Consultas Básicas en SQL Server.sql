-- ### PORTAFOLIO PROGRAMACIÓN EN SQL ###
/*
Se trabajará con las siguientes tablas para simular una empresa:  

1. **Empleados** (ID, Nombre, Edad, DepartamentoID, Salario, FechaIngreso)  
2. **Departamentos** (ID, Nombre)  
3. **Proyectos** (ID, Nombre, Presupuesto)  
4. **Asignaciones** (ID, EmpleadoID, ProyectoID, FechaAsignacion)  
5. **HistorialSalarios** (ID, EmpleadoID, SalarioAnterior, SalarioNuevo, FechaCambio)  
*/


-- ** 1️ Consultas Básicas en SQL Server **

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
