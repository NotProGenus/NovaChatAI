import os
from hashlib import sha256
from pathlib import Path, PureWindowsPath

from dotenv import load_dotenv

from .embeddings import create_embeddings, embedding_model_name
from .loaders import load_document
from .retriever import Retriever
from .splitter import split_documents


if __package__ == "rag":
    from services.llm import NO_ANSWER, generate_answer
else:
    from ..services.llm import NO_ANSWER, generate_answer


class RAGPipeline:
    """Construct with the authenticated user's database ID on the server."""

    def __init__(self, user_id: int):
        load_dotenv()
        model = embedding_model_name()
        default_dir = Path.home() / ".novachat" / "chroma"
        directory = os.getenv("RAG_CHROMA_DIR", str(default_dir))
        self.retriever = Retriever(directory, user_id, model, create_embeddings(model))

    def ingest(self, filename: str, data: bytes) -> dict:
        pages = load_document(filename, data)
        chunks = split_documents(pages)
        # A revision is immutable. Retrying the same upload uses the same IDs.
        name = PureWindowsPath(filename).name.encode("utf-8")
        document_id = sha256(name + b"\x00" + data).hexdigest()
        self.retriever.index(document_id, chunks)
        return {"document_id": document_id, "chunks": len(chunks)}

    def ask(self, question: str, *, document_id: str | None = None, k: int = 4) -> dict:
        passages = self.retriever.search(question.strip(), k, document_id)

        print("\n========== RAG DEBUG ==========")
        print("QUESTION:", question)
        print("DOCUMENT ID:", document_id)
        print("RETRIEVED PASSAGES:", len(passages))

        for i, passage in enumerate(passages, 1):
            print(f"\n--- PASSAGE {i} ---")
            print(passage["text"])

        print("========== END DEBUG ==========\n")

        return generate_answer(question, passages)
