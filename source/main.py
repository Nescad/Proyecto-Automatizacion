from datetime import datetime
from jinja2 import Environment, FileSystemLoader
from conexion_bd import obtener_datos
from correo import enviar_correo
from deteccion_destinatarios import detectar_destinatarios_notificacion
import os

def procesar_datos():
    # Obtener datos de la base de datos y generar el archivo
    archivo_generado = obtener_datos()
    print("Archivos procesados")
    return archivo_generado

def detectar_parametros():
    # Extraer destinatarios
    destinatarios = detectar_destinatarios_notificacion()
    print(f"Se detectaron los destinatarios:{destinatarios}")
    return destinatarios

def enviar_notificacion(archivo_resultados, destinatarios):
    # Ruta relativa de la carpeta
    ruta_relativa = 'results'

    # Obtener la ruta absoluta
    ruta_absoluta = os.path.realpath(ruta_relativa)

    # Verificar si el archivo fue generado correctamente
    if archivo_resultados:
        # Configurar el entorno de Jinja2 
        template_dir = os.path.dirname('inputs/cuerpo_correo/')  # Ruta absoluta al directorio de plantillas
        env = Environment(loader=FileSystemLoader(template_dir))

        # Cargar la plantilla
        template = env.get_template('00_cuerpo_correo.html')

        # Contexto de variables
        context = {
            'fecha_actual': datetime.now().strftime("%d/%m/%Y %H:%M:%S"),  # Por ejemplo, "Septiembre 2024"
            'year': datetime.now().year,  # Año actual para el pie de página
            'url': ruta_absoluta
        }

        # Renderizar la plantilla con el contexto
        cuerpo = template.render(context)
        
        # Enviar el correo
        enviar_correo(destinatarios, 'Formulario del Presente Mes', cuerpo, archivo_resultados)
    else:
        print("No se generó el archivo. El correo no se enviará.")
    
    print("Se envió la notificación adecuadamente")

def main():
    # Procesar datos y obtener resultados
    archivo_resultados = procesar_datos()

    # Detección parámetros
    destinatarios = detectar_parametros()
    
    # Enviar notificación
    enviar_notificacion(archivo_resultados, destinatarios)

    print("El automatizador finalizó exitosamente")

if __name__ == "__main__":
    main()
