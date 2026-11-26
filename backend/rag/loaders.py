
import os
from io import BytesIO
from pathlib import Path, PureWindowsPath

import pytesseract
from dotenv import load_dotenv
from langchain_core.documents import Document
from pdf2image import convert_from_bytes
from pypdf import PdfReader
from pypdf.errors import PdfReadError


load_dotenv()

# Tesseract executable path
tesseract_path = os.getenv("TESSERACT_PATH")

if tesseract_path:
    pytesseract.pytesseract.tesseract_cmd = tesseract_path

# Poppler bin folder path
POPPLER_PATH = os.getenv("POPPLER_PATH") or None


def extract_pdf_pages(data: bytes, source: str) -> list[Document]:

    try:
        reader = PdfReader(BytesIO(data))

        if reader.is_encrypted:
            raise ValueError("Upload a PDF without password protection.")

        documents = []

        for page_number, page in enumerate(reader.pages, 1):

            # First try normal text extraction using PyPDF
            text = page.extract_text() or ""

            # If no text is found, use OCR
            if not text.strip():

                if not tesseract_path or not Path(tesseract_path).is_file():
                    raise ValueError(
                        "Tesseract not found. Check TESSERACT_PATH in .env."
                    )

                if POPPLER_PATH and not Path(POPPLER_PATH).is_dir():
                    raise ValueError(
                        "Poppler folder not found. Check POPPLER_PATH in .env."
                    )

                try:
                    images = convert_from_bytes(
                        data,
                        first_page=page_number,
                        last_page=page_number,
                        dpi=200,
                        poppler_path=POPPLER_PATH
                    )

                    if images:
                        text = pytesseract.image_to_string(
                            images[0],
                            lang="eng"
                        )

                except Exception as exc:
                    raise ValueError(
                        f"OCR failed on PDF page {page_number}. "
                        "Check Tesseract and Poppler installation."
                    ) from exc

            # Store extracted text
            if text.strip():
                documents.append(
                    Document(
                        page_content=text.strip(),
                        metadata={
                            "source": source,
                            "page": page_number
                        }
                    )
                )

        return documents

    except PdfReadError as exc:
        raise ValueError("Could not read the PDF.") from exc


def load_document(filename: str, data: bytes) -> list[Document]:

    source = PureWindowsPath(filename).name
    suffix = PureWindowsPath(source).suffix.lower()

    if not data or len(data) > 10 * 1024 * 1024:
        raise ValueError("Supply a nonempty document of at most 10 MiB.")

    if suffix == ".pdf":

        documents = extract_pdf_pages(data, source)

    elif suffix == ".txt":

        text = data.decode("utf-8-sig").strip()

        documents = [
            Document(
                page_content=text,
                metadata={"source": source}
            )
        ] if text else []

    else:
        raise ValueError("Supported file types are PDF and TXT.")

    if not documents:
        raise ValueError("No readable text found, even after OCR.")

    return documents

