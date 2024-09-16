import sqlite3
import pandas as pd
import glob
import os

def obtener_datos():
    """
    Conecta a una base de datos SQLite, ejecuta consultas SQL desde archivos en una carpeta, 
    concatena los resultados en un DataFrame y guarda el resultado en un archivo Excel.

    Args:
    None

    Returns:
        str: Ruta del archivo Excel generado.
        None: Si ocurre algún error.
    """
    conn = None
    try:
        # Conexión a la base de datos
        conn = sqlite3.connect('inputs/database/database.sqlite')
        
        carpeta = 'inputs/consultas'

        # Obtener todos los archivos SQL en el directorio especificado
        sql_files = glob.glob(f'{carpeta}/*.sql') 
        
        # Lista para almacenar los DataFrames resultantes de cada consulta SQL
        results = []
        
        for sql_file in sql_files:
            try:
                with open(sql_file, 'r') as file:
                    query = file.read()
                    # Ejecutar la consulta y almacenar el resultado en un DataFrame
                    df = pd.read_sql_query(query, conn)
                    results.append(df)
            except Exception as e:
                print(f"Error al ejecutar el archivo {sql_file}: {e}")
        
        # Unificar todos los DataFrames en uno solo
        if results:
            data = pd.concat(results, ignore_index=True)  # Cambié ignore_index a True para una mejor concatenación
        else:
            data = pd.DataFrame()  # Crear un DataFrame vacío si no hay resultados

        # Ruta de la carpeta de resultados
        results_folder = "results/"
        
        # Ruta completa del archivo Excel en la carpeta de backup
        results_file_path = os.path.join(results_folder, 'resultados_unificados.xlsx')
        
        # Guardar el DataFrame en un archivo Excel
        data.to_excel(results_file_path, index=False, engine='openpyxl') 
        
        return results_file_path # Retornar la ruta del archivo generado
        
    except Exception as e:
        print(f"Error al conectar a la base de datos o procesar archivos: {e}")
        return None  # Retornar None en caso de error
    
    finally:
        if conn:
            conn.close()

# Llamar a la función y almacenar la ruta del archivo generado
archivo_resultado = obtener_datos()
