from pydantic import BaseModel
from datetime import datetime


class ChatSessionCreate(BaseModel):
    title : str


class ChatSessionResponse(BaseModel):
    id         : int
    user_id    : int
    title      : str
    created_at : datetime

    class Config:
        from_attributes = True