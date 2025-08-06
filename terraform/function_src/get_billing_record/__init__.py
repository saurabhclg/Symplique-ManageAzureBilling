import os, json
from azure.cosmos import CosmosClient, exceptions
from azure.storage.blob import BlobClient
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    record_id = req.route_params.get('id')
    cosmos = CosmosClient.from_connection_string(os.environ['CosmosDB_Connection'])
    db = cosmos.get_database_client('billingdb').get_container_client('billingrecords')
    try:
        record = db.read_item(record_id, partition_key='partitionKey')
        return func.HttpResponse(json.dumps(record), status_code=200)
    except exceptions.CosmosResourceNotFoundError:
        # Fallback: Compute blob path, try to read from Blob Storage
        # Implement your date to path mapping logic as needed
        blob_connection = os.environ['Blob_Connection']
        blob_path = f"YYYY/MM/{record_id}.json" # replace with logic to map id->date or store metadata mapping
        blob = BlobClient.from_connection_string(blob_connection, container_name="archive", blob_name=blob_path)
        data = blob.download_blob().readall()
        return func.HttpResponse(data, status_code=200)

