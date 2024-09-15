WITH PeticionesExitosas AS (
    SELECT
        strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
        apicall.commerce_id,
        COUNT(*) AS total_peticiones_exitosas,
        commerce.commerce_nit AS Nit,
        commerce.commerce_email AS Correo
    FROM apicall
    INNER JOIN commerce
    ON apicall.commerce_id = commerce.commerce_id
    WHERE apicall.ask_status = 'Successful'
    AND commerce.commerce_name = 'FusionWave Enterprises'
    AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
    GROUP BY apicall.commerce_id, Fecha_Mes, Nit, Correo
),
PeticionesNoExitosas AS (
    SELECT
        strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
        apicall.commerce_id,
        COUNT(*) AS peticiones_no_exitosas,
        commerce.commerce_nit AS Nit,
        commerce.commerce_email AS Correo
    FROM apicall
    INNER JOIN commerce
    ON apicall.commerce_id = commerce.commerce_id
    WHERE apicall.ask_status = 'Unsuccessful'
    AND commerce.commerce_name = 'FusionWave Enterprises'
    AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
    GROUP BY apicall.commerce_id, Fecha_Mes, Nit, Correo
),
Comisiones AS (
    SELECT
        PeticionesExitosas.Fecha_Mes,
        PeticionesExitosas.commerce_id,
        PeticionesExitosas.Nit,
        commerce.commerce_name,
        PeticionesExitosas.Correo,
        PeticionesExitosas.total_peticiones_exitosas AS total_peticiones,
        COALESCE(PeticionesNoExitosas.peticiones_no_exitosas, 0) AS peticiones_no_exitosas,
        PeticionesExitosas.total_peticiones_exitosas * 300 AS valor_comision
    FROM PeticionesExitosas
    INNER JOIN commerce
    ON PeticionesExitosas.commerce_id = commerce.commerce_id
    LEFT JOIN PeticionesNoExitosas
    ON PeticionesExitosas.commerce_id = PeticionesNoExitosas.commerce_id
    AND PeticionesExitosas.Fecha_Mes = PeticionesNoExitosas.Fecha_Mes  -- Asegura la correspondencia por Fecha_Mes también
),
ComisionesConDescuento AS (
    SELECT
        Comisiones.Fecha_Mes,
        Comisiones.commerce_id,
        Comisiones.commerce_name,
        Comisiones.Nit,
        Comisiones.valor_comision,
        Comisiones.peticiones_no_exitosas,
        Comisiones.Correo,
        CASE
            WHEN Comisiones.peticiones_no_exitosas BETWEEN 2500 AND 4500 THEN Comisiones.valor_comision * 0.95
            WHEN Comisiones.peticiones_no_exitosas > 4501 THEN Comisiones.valor_comision * 0.92
            ELSE Comisiones.valor_comision
        END AS valor_comision_despues_descuento
    FROM Comisiones
)
SELECT
    ComisionesConDescuento.Fecha_Mes,
    ComisionesConDescuento.commerce_name AS Nombre,
    ComisionesConDescuento.Nit,
    ComisionesConDescuento.valor_comision_despues_descuento AS Valor_Comision,
    (ComisionesConDescuento.valor_comision_despues_descuento * 0.19) AS Valor_Iva,
    (ComisionesConDescuento.valor_comision_despues_descuento * 1.19) AS Valor_Total,
    ComisionesConDescuento.Correo
FROM ComisionesConDescuento;
