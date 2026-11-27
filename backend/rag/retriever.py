from langchain_core.documents import Document
from langchain_core.embeddings import Embeddings

if __package__ == "rag":
    from vector_db.croma import open_collection
else:
    from ..vector_db.croma import open_collection


class Retriever:
    def __init__(self, directory: str, user_id: int, model_name: str, embeddings: Embeddings):
        self.client, self.collection = open_collection(directory, user_id, model_name)
        self.embeddings = embeddings

    def index(self, document_id: str, chunks: list[Document]) -> None:
        if len(chunks) > min(2000, self.client.get_max_batch_size()):
            raise ValueError("The document is too large to index in one operation.")
        ids = [f"{document_id}:{chunk.metadata['chunk']}" for chunk in chunks]
        existing = self.collection.get(where={"document_id": document_id}, include=[])
        if set(existing["ids"]) == set(ids):
            return
        texts = [chunk.page_content for chunk in chunks]
        vectors = self.embeddings.embed_documents(texts)
        self.collection.upsert(
            ids=ids, embeddings=vectors, documents=texts,
            metadatas=[dict(chunk.metadata, document_id=document_id) for chunk in chunks],
        )

    def search(self, question: str, k: int = 4, document_id: str | None = None) -> list[dict]:
        if not question.strip() or not 1 <= k <= 10:
            raise ValueError("Supply a question and a result count between 1 and 10.")
        count = self.collection.count()
        if not count:
            return []
        result = self.collection.query(
            query_embeddings=[self.embeddings.embed_query(question)],
            n_results=min(k, count),
            where={"document_id": document_id} if document_id else None,
            include=["documents", "metadatas"],
        )
        return [
            dict(metadata, text=text)
            for text, metadata in zip(result["documents"][0], result["metadatas"][0], strict=True)
        ]
