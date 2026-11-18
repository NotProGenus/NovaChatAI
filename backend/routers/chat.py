
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db
from security.auth import get_current_user
from models.user import User

from crud.chat_session import (
    create_chat_session,
    get_user_chat_sessions,
    get_chat_session,
    delete_chat_session,
    rename_chat_session
)

from crud.messages import (
    create_message,
    get_chat_messages
)

from schemas.chat_session import (
    ChatSessionCreate,
    ChatSessionUpdate
)

from schemas.messages import (
    MessageCreate,
    MessageResponse
)


router = APIRouter(prefix="/chat", tags=["Chat"])


