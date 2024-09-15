WITH PeticionesExitosas AS (
    SELECT
        commerce.commerce_nit AS Nit,
        strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
        COUNT(*) AS total_peticiones_exitosas,
        apicall.commerce_id,
        commerce.commerce_email
    FROM apicall
    INNER JOIN commerce
    ON apicall.commerce_id = commerce.commerce_id
    WHERE apicall.ask_status = 'Successful'
    AND commerce.commerce_name = 'Zenith Corp.'
    AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
    GROUP BY apicall.commerce_id, Fecha_Mes
),
PeticionesNoExitosas AS (
    SELECT
        commerce.commerce_nit AS Nit,
        strftime('%m-%Y', apicall.date_api_call) AS Fecha_Mes,
        COUNT(*) AS peticiones_no_exitosas,
        apicall.commerce_id,
        commerce.commerce_email
    FROM apicall
    INNER JOIN commerce
    ON apicall.commerce_id = commerce.commerce_id
    WHERE apicall.ask_status = 'Unsuccessful'
    AND commerce.commerce_name = 'Zenith Corp.'
    AND (apicall.date_api_call BETWEEN '2024-07-01' AND '2024-08-31')
    GROUP BY apicall.commerce_id, Fecha_Mes
),
Comisiones AS (
    SELECT
        PeticionesExitosas.Fecha_Mes,
        PeticionesExitosas.commerce_id,
        commerce.commerce_name,
        PeticionesExitosas.Nit,
        PeticionesExitosas.commerce_email,
        PeticionesExitosas.total_peticiones_exitosas AS total_peticiones,
        COALESCE(PeticionesNoExitosas.peticiones_no_exitosas, 0) AS peticiones_no_exitosas,
        CASE
            WHEN PeticionesExitosas.total_peticiones_exitosas <= 22000 THEN PeticionesExitosas.total_peticiones_exitosas * 250
            ELSE PeticionesExitosas.total_peticiones_exitosas * 130
        END AS valor_comision
    FROM PeticionesExitosas
    INNER JOIN commerce
    ON PeticionesExitosas.commerce_id = commerce.commerce_id
    LEFT JOIN PeticionesNoExitosas
    ON PeticionesExitosas.commerce_id = PeticionesNoExitosas.commerce_id
    AND PeticionesExitosas.Fecha_Mes = PeticionesNoExitosas.Fecha_Mes
),
ComisionesConDescuento AS (
    SELECT
        Comisiones.Nit,
        Comisiones.Fecha_Mes,
        Comisiones.commerce_id,
        Comisiones.commerce_name,
        Comisiones.commerce_email,
        Comisiones.valor_comision,
        Comisiones.peticiones_no_exitosas,
        CASE
            WHEN Comisiones.peticiones_no_exitosas > 6000 THEN Comisiones.valor_comision * 0.95
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
    ComisionesConDescuento.commerce_email AS Correo
FROM ComisionesConDescuento;
