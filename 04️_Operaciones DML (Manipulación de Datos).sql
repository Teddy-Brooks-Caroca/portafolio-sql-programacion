-- ** 4️ Operaciones DML (Manipulación de Datos) **

-- 1. Inserta nuevos empleados en la tabla utilizando `INSERT`.  

INSERT INTO empleados (Nombre,Edad,DepartamentoID,Salario,FechaIngreso)
VALUES
('Jaciento Urmeneta',56,2,450000,'2015-08-20'),
('Edelmira Pascal',58,3,520000,'2015-12-22'),
('Juan Pedregal',49,4,520000,'2016-04-20'),
('Violeta Casamidas',44,4,475000,'2017-04-21'),
('Giorgos Covarrubias',61,2,620000,'2017-04-21'),
('Maria Joaquina Wersmer',23,3,580000,'2025-03-27');

-- 2. Modifica el salario de un empleado con `UPDATE`.  

UPDATE Empleados SET Salario = 680000 WHERE ID = 15;

-- 3. Elimina un empleado con `DELETE`.

DELETE FROM asignaciones WHERE EmpleadoID =12;
DELETE FROM Empleados WHERE ID = 12;

-- 4. Borra todos los datos de una tabla sin eliminar su estructura (`TRUNCATE`).  

TRUNCATE TABLE EmpleadosAntiguos;

-- 5. Usa `EXISTS` para verificar si un empleado tiene asignaciones antes de eliminarlo.  

SELECT 
	* 
FROM 
	empleados 
WHERE 
	EXISTS (SELECT 1 
			FROM asignaciones 
			WHERE empleados.ID = asignaciones.EmpleadoID);

-- 6. Crea una subconsulta que devuelva el ID del departamento con el salario promedio más alto.  

SELECT 
	DepartamentoID 
FROM 
	empleados 
GROUP BY 
	DepartamentoID 
HAVING AVG(Salario) = (
						SELECT MAX(PromedioSalario)
						FROM (SELECT 
								DepartamentoID, 
								AVG(Salario) AS PromedioSalario
							 FROM 
								empleados
							GROUP BY 
								DepartamentoID) AS Subquery);

-- 7. Usa una subconsulta correlacionada para encontrar el empleado con el salario más alto en cada departamento.  

SELECT 
	e1.nombre 
FROM 
	empleados e1
WHERE 
	e1.salario = (
				SELECT MAX(e2.Salario) AS SalarioMaximo 
				FROM empleados e2 
				WHERE e2.DepartamentoID = e1.DepartamentoID); 

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
