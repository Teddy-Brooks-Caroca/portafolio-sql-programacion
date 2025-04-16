-- ** 3 Relaciones y JOINS **

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
	LEFT JOIN proyectos ON asignaciones.ProyectoID = proyectos.ID
ORDER BY
	Proyecto_asignado;

-- 3. Usa `RIGHT JOIN` para mostrar todos los proyectos, incluso si no tienen empleados asignados.  

SELECT 
	proyectos.Nombre AS 'Proyecto_asignado',
	empleados.Nombre AS 'Empleado'
FROM 
	proyectos
	RIGHT JOIN asignaciones ON proyectos.ID = asignaciones.ProyectoID
	LEFT JOIN empleados ON asignaciones.EmpleadoID = empleados.ID
ORDER BY Proyecto_asignado;


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
