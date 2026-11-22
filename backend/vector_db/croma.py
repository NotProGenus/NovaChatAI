from hashlib import sha256
import chromadb

client = chromadb.PersistentClient(path="./chroma_db")

def open_collection(directory: str, user_id: int, model_name: str):

    if type(user_id) is not int or user_id < 1:
        raise ValueError("A positive user ID is required.")
    
    namespace = sha256(f"{user_id}:{model_name}".encode()).hexdigest()[:32]

    collection = client.get_or_create_collection(
        name = f"nova-{namespace}", 
        embedding_function = None,
        metadata = {"hnsw:space": "cosine"}
    )
    return collection
