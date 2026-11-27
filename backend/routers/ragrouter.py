from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from security.auth import get_current_user
from rag.pipeline import RAGPipeline
from schemas.rag_schema import (
    RAGQuery,
    RAGQueryResponse,
    RAGUploadResponse
)

router = APIRouter(
    prefix="/rag",
    tags=["RAG"]
)


@router.post("/upload", response_model=RAGUploadResponse)
async def upload_document(
    file: UploadFile = File(...),
    current_user = Depends(get_current_user)
):
    try:
        data = await file.read()

        pipeline = RAGPipeline(user_id=current_user.id)

        result = pipeline.ingest(
            filename=file.filename,
            data=data
        )

        return {
            "message": "Document uploaded and indexed successfully.",
            "filename": file.filename,
            **result
        }

    except ValueError as exc:
        raise HTTPException(
            status_code=400,
            detail=str(exc)
        )

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail="Document processing failed."
        ) from exc

    finally:
        await file.close()


@router.post("/query", response_model=RAGQueryResponse)
async def query_document(
    data: RAGQuery,
    current_user = Depends(get_current_user)
):
    try:
        pipeline = RAGPipeline(user_id=current_user.id)

        result = pipeline.ask(
            question=data.question,
            document_id=data.document_id,
            k=data.k
        )

        return result

    except ValueError as exc:
        raise HTTPException(
            status_code=400,
            detail=str(exc)
        )

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail="Failed to generate an answer."
        ) from exc
