import pandas as pd

def detectar_destinatarios_notificacion():
    """
    Lee un archivo Excel con una lista de correos electrónicos y retorna una cadena con los destinatarios,
    separados por punto y coma, para su uso en Outlook.

    Args:
        None

    Returns:
        str: Cadena con los correos electrónicos separados por punto y coma.
    """
    # Ruta del archivo Excel con los correos
    ruta_parametros = 'inputs/parametros/parametros_destinatarios.xlsx'

    # Leer el archivo Excel y obtener los correos
    df_parametros = pd.read_excel(ruta_parametros)

    # Se extraen los destinatarios, eliminando los nulos
    destinatarios = df_parametros["Correo"].dropna().tolist()

    # Combina múltiples correos en un solo string separados por comas si hay varios destinatarios
    destinatarios_str = '; '.join(destinatarios)  # Formato requerido por Outlook para varios destinatarios

    return destinatarios_str 

dict_parametros_clientes = detectar_destinatarios_notificacion()