WITH Peticiones AS (
    SELECT
        commerce.commerce_id,
        strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
        commerce.commerce_name AS Nombre,
        commerce.commerce_nit AS Nit,
        COUNT(*) AS total_peticiones,
        commerce.commerce_email AS Correo
    FROM apicall
    INNER JOIN commerce
    ON apicall.commerce_id = commerce.commerce_id
    WHERE apicall.ask_status = 'Successful'
    AND commerce.commerce_name = 'NexaTech Industries'
    AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
)
SELECT
    Peticiones.Fecha_Mes,
    Peticiones.Nombre,
    Peticiones.Nit,
    CASE
        WHEN total_peticiones <= 10000 THEN total_peticiones * 250
        WHEN total_peticiones <= 20000 THEN (10000 * 250) + ((total_peticiones - 10000) * 200)
        ELSE (10000 * 250) + (10000 * 200) + ((total_peticiones - 20000) * 170)
    END AS Valor_Comision,
    (CASE
        WHEN total_peticiones <= 10000 THEN total_peticiones * 250
        WHEN total_peticiones <= 20000 THEN (10000 * 250) + ((total_peticiones - 10000) * 200)
        ELSE (10000 * 250) + (10000 * 200) + ((total_peticiones - 20000) * 170)
    END * 0.19) AS Valor_Iva,
    (CASE
        WHEN total_peticiones <= 10000 THEN total_peticiones * 250
        WHEN total_peticiones <= 20000 THEN (10000 * 250) + ((total_peticiones - 10000) * 200)
        ELSE (10000 * 250) + (10000 * 200) + ((total_peticiones - 20000) * 170)
    END * 1.19) AS Valor_Total,
    Peticiones.Correo
FROM Peticiones
INNER JOIN commerce
ON Peticiones.commerce_id = commerce.commerce_id;
