import os
from langchain_google_genai import GoogleGenerativeAIEmbeddings

def embedding_model_name() -> str:
    return os.getenv("RAG_EMBEDDING_MODEL", "gemini-embedding-001")


def create_embeddings(model_name: str) -> GoogleGenerativeAIEmbeddings:
    return GoogleGenerativeAIEmbeddings(model=model_name)
