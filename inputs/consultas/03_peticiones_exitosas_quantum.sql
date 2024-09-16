SELECT 
    '2024-07-01' AS Fecha_Inicio,
    '2024-08-31' AS Fecha_Fin,
    commerce.commerce_name AS Nombre,
    commerce.commerce_nit AS Nit,
    COUNT(*) * 600 AS Valor_Comision, -- Monto total de las comisiones sin IVA
    (COUNT(*) * 600 * 0.19) AS Valor_Iva, -- Monto total del IVA
    (COUNT(*) * 600 * 1.19) AS Valor_Total, -- Monto total con IVA incluido
    commerce.commerce_email AS Correo
FROM apicall
INNER JOIN commerce
ON apicall.commerce_id = commerce.commerce_id
WHERE apicall.ask_status = 'Successful'
AND commerce.commerce_name = 'QuantumLeap Inc.'
AND commerce.commerce_status = 'Active' -- Asegurando que solo se consideren empresas activas
AND apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31'
GROUP BY commerce.commerce_name, commerce.commerce_nit, commerce.commerce_email;

