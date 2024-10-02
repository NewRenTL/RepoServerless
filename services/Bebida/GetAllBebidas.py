import json
import psycopg2
import os
from dotenv import load_dotenv

# Cargar las variables de entorno
load_dotenv()

# Configurar la conexión global
connection = None

def get_connection():
    global connection
    # Verificar si la conexión no existe o está cerrada
    if connection is None or connection.closed:
        connection_string = os.getenv('DATABASEURL')
        connection = psycopg2.connect(connection_string)
    return connection

def get_all_bebidas(event, context):
    try:
        # Obtener la conexión y crear el cursor
        conn = get_connection()
        cursor = conn.cursor()
        
        # Consulta SQL para obtener todas las bebidas
        query = "SELECT id_beb, name_beb, price FROM bebida"
        cursor.execute(query)
        
        # Obtener los resultados de la consulta
        bebidas = cursor.fetchall()
        
        # Convertir los resultados a un formato JSON
        bebidas_list = [{"id": bebida[0], "name_beb": bebida[1], "price": bebida[2]} for bebida in bebidas]
        
        cursor.close()
        
        return {
            "statusCode": 200,
            "body": json.dumps(bebidas_list)
        }
        
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Error al obtener las bebidas", "error": str(e)})
        }
