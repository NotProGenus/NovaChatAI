from io import BytesIO
from pathlib import PureWindowsPath

from langchain_core.documents import Document
from pypdf import PdfReader
from pypdf.errors import PdfReadError


def load_document(filename: str, data: bytes) -> list[Document]:
    source = PureWindowsPath(filename).name
    suffix = PureWindowsPath(source).suffix.lower()

    if not data or len(data) > 10 * 1024 * 1024:
        raise ValueError("Supply a nonempty document of at most 10 MiB.")

    if suffix == ".pdf":
        try:
            reader = PdfReader(BytesIO(data))

            if reader.is_encrypted:
                raise ValueError("Upload a PDF without password protection.")

            pages = (
                (i, page.extract_text() or "")
                for i, page in enumerate(reader.pages, 1)
            )

            documents = [
                Document(
                    page_content=text.strip(),
                    metadata={"source": source, "page": i}
                )
                for i, text in pages if text.strip()
            ]

        except PdfReadError as exc:
            raise ValueError("Could not read the PDF.") from exc

    elif suffix == ".txt":
        text = data.decode("utf-8-sig").strip()

        documents = [
            Document(page_content=text, metadata={"source": source})
        ] if text else []

    else:
        raise ValueError("Supported file types are PDF and TXT.")

    if not documents:
        raise ValueError("No readable text found. Scanned PDFs require OCR.")

    return documents
