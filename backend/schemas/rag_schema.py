from pydantic import BaseModel, Field, ConfigDict


class RAGQuery(BaseModel):

    question    : str = Field(..., min_length=1)
    document_id : str | None = None
    k           : int = Field(default=4, ge=1, le=10)


class RAGSource(BaseModel):

    source      : str | None = None
    page        : int | None = None
    chunk       : int | None = None
    document_id : str
    text        : str
    citation    : int

    model_config = ConfigDict(extra="allow")


class RAGQueryResponse(BaseModel):

    answer  : str
    sources : list[RAGSource]


class RAGUploadResponse(BaseModel):

    message      : str
    filename     : str
    document_id  : str
    chunks       : int