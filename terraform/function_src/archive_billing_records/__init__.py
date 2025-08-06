import os, json
from datetime import datetime, timedelta
from azure.cosmos import CosmosClient
from azure.storage.blob import BlobClient
import azure.functions as func

def main(mytimer: func.TimerRequest) -> None:
    cosmos_uri = os.environ['CosmosDB_Connection']
    blob_connection = os.environ['Blob_Connection']
    threshold_days = int(os.environ.get('THRESHOLD_DAYS', 90))

    cosmos = CosmosClient.from_connection_string(cosmos_uri)
    db = cosmos.get_database_client('billingdb').get_container_client('billingrecords')
    threshold_date = (datetime.utcnow() - timedelta(days=threshold_days)).isoformat()

    query = f"SELECT * FROM c WHERE c.date < '{threshold_date}'"
    for rec in db.query_items(query=query, enable_cross_partition_query=True):
        blob_path = f"{rec['date'][:7]}/{rec['id']}.json"
        blob = BlobClient.from_connection_string(blob_connection, container_name="archive", blob_name=blob_path)
        blob.upload_blob(json.dumps(rec), overwrite=True)
        db.delete_item(item=rec['id'], partition_key=rec['partitionKey'])

