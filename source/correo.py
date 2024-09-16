import win32com.client as win32
import os

def enviar_correo(destinatario, asunto, cuerpo, archivo_adjunto):
    """
    Envía un correo electrónico a través de Outlook con un archivo adjunto.

    Args:
        destinatario (str): Dirección de correo del destinatario.
        asunto (str): Asunto del correo.
        cuerpo (str): Cuerpo del correo en formato HTML.
        archivo_adjunto (str): Ruta del archivo a adjuntar.

    Returns:
        None
    """
    # Crear instancia para Outlook
    outlook = win32.Dispatch('outlook.application')
    # Crear un nuevo correo
    mail = outlook.CreateItem(0)
    # Configuración del correo
    mail.Subject = asunto
    mail.HTMLBody = cuerpo
    mail.To = destinatario

    # Obtener la ruta absoluta del archivo adjunto
    archivo_absoluto = os.path.abspath(archivo_adjunto)

    try:
        # Verificar que el archivo existe antes de adjuntarlo
        if os.path.isfile(archivo_absoluto):
            # Adjuntar el archivo generado
            mail.Attachments.Add(archivo_absoluto)
        else:
            print(f"El archivo {archivo_adjunto} no existe.")
            return
        
        # Enviar correo
        mail.Send()
        print(f"Correo enviado a {destinatario}.")
        
    except Exception as e:
        print(f"Error al enviar el correo: {e}")
