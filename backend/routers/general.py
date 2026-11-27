from fastapi import APIRouter

router = APIRouter(prefix="", tags=["General"])

@router.get("/")
def root():
    return {"message": "NovaChat API is running!"}


@router.get("/health")
def health_check():
    return {"status": "healthy"}