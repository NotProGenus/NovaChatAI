from pydantic import BaseModel, Field, field_validator
from datetime import datetime


class MessageCreate(BaseModel):

    content : str = Field(..., min_length=1)


@field_validator("content")
@classmethod

def check_content(cls, value):
    if not value.strip():
        raise ValueError("Message cannot be empty")

    return value.strip()


class MessageResponse(BaseModel):

    id              : int
    chat_session_id : int
    role            : str
    content         : str
    created_at      : datetime

    model_config = {"from_attributes": True}