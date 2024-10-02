import uuid
import json
import psycopg2
import os
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

def create_bebida(event,context):
    body = json.loads(event.get("body","{}"));

    

    missing_fields = []
    
    if not body.get("name_beb"):
        missing_fields.append("name_beb")
        
    if not body.get("price"):
        missing_fields.append("price")

    nombre_bebida = body.get("name_beb")
    precio_bebida = body.get("price")
    
    try:
        precio_bebida = float(precio_bebida)
    except(ValueError,TypeError):
        return {
            "statusCode":400,
            "body":json.dumps({"message":"El campo 'price' debe ser un número"})
        }
    id_bebida = str(uuid.uuid4())
    
    try:
        conn = get_connection();
        cursor = conn.cursor();
        
        cursor.execute("""INSERT INTO bebida (id_beb,name_beb,price) VALUES(%s,%s,%s)""",(id_bebida,nombre_bebida,precio_bebida));
        
        conn.commit();
        cursor.close();
        
        return {
            "statusCode": 201,
            "body": json.dumps({"message": "Bebida creada con éxito", "id": id_bebida})
        }
    except Exception as e:
        return {
            "statusCode":500,
            "body": json.dumps({"message":"Error al crear la bebida","error":str(e)})
        }
    