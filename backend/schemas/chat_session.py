from pydantic import BaseModel, Field
from datetime import datetime


class ChatSessionCreate(BaseModel):

    title: str = Field(..., min_length=1, max_length=255)


class ChatSessionResponse(BaseModel):

    id         : int
    user_id    : int
    title      : str | None
    created_at : datetime

    model_config = {"from_attributes": True}