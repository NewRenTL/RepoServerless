import json
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

connection = None

def get_connection():
    global connection
    # Verificar si la conexión no existe o está cerrada
    if connection is None or connection.closed:
        connection_string = os.getenv('DATABASEURL')
        connection = psycopg2.connect(connection_string)
    return connection

def hello(event, context):
    try:
        # Obtener la conexión activa
        conn = get_connection()
        cursor = conn.cursor()
        
        query = "SELECT version();"
        cursor.execute(query)
        result = cursor.fetchone()

        cursor.close()  # Cerramos solo el cursor, no la conexión

        return {
            "statusCode": 200,
            "body": f"psycopg2 binary works here successfully, fetched data: {result}"
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error occurred: {str(e)}"
        }