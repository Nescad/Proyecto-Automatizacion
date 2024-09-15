SELECT 
    strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
    commerce.commerce_name AS Nombre,
    commerce.commerce_nit AS Nit,
    COUNT(*) * 600 AS Valor_Comision,
    (COUNT(*) * 600 * 0.19) AS Valor_Iva,
    (COUNT(*) * 600 * 1.19) AS Valor_Total,
    commerce.commerce_email AS Correo
FROM apicall
INNER JOIN commerce
ON apicall.commerce_id = commerce.commerce_id
WHERE apicall.ask_status = 'Successful'
AND commerce.commerce_name = 'QuantumLeap Inc.'
AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
GROUP BY apicall.commerce_id, commerce.commerce_name;
