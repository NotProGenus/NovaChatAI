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
    ChatSessionUpdate,
    ChatSessionResponse
)

from schemas.messages import (
    MessageCreate,
    MessageResponse
)


router = APIRouter(prefix="/chat", tags=["Chat"])


@router.post("/sessions/create_session",
             response_model = ChatSessionResponse)
def new_chat_session(
    data: ChatSessionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    chat_session = create_chat_session(
        db,
        current_user.id,
        data.title
    )

    return chat_session


@router.get("/sessions/get_sessions",
             response_model = list[ChatSessionResponse])
def get_sessions(
    page: int = 1,
    limit: int = 10,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)

):
    sessions = get_user_chat_sessions(
        db,
        current_user.id,
        page,
        limit
    )

    return sessions



@router.get(
    "/sessions/{session_id}/get_session",
    response_model=ChatSessionResponse
)
def get_session(
    session_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    chat_session = get_chat_session(
        db,
        session_id,
        current_user.id
    )

    if not chat_session:
        raise HTTPException(
            status_code=404,
            detail="Chat session not found"
        )

    return chat_session



@router.put("/sessions/{session_id}/update_session", 
            response_model = ChatSessionResponse)
def update_chat_session(
    session_id: int,
    data: ChatSessionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    chat_session = get_chat_session(
        db,
        session_id,
        current_user.id
    )

    if not chat_session:
        raise HTTPException(
            status_code=404,
            detail="Chat session not found"
        )

    updated_session = rename_chat_session(
        db,
        chat_session,
        data.title
    )

    return updated_session


@router.delete("/sessions/{session_id}/delete_session")
def remove_chat_session(
    session_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    chat_session = get_chat_session(
        db,
        session_id,
        current_user.id
    )

    if not chat_session:
        raise HTTPException(
            status_code=404,
            detail="Chat session not found"
        )

    delete_chat_session(db, chat_session)

    return {
        "message": "Chat session deleted successfully"
    }



@router.post(
    "/sessions/{session_id}/messages",
    response_model=MessageResponse
)
def add_message(
    session_id: int,
    data: MessageCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    chat_session = get_chat_session(
        db,
        session_id,
        current_user.id
    )

    if not chat_session:
        raise HTTPException(
            status_code=404,
            detail="Chat session not found"
        )

    message = create_message(
        db,
        session_id,
        data.role,
        data.content
    )

    return message


@router.get("/sessions/{session_id}/messages",
            response_model = list[MessageResponse])
def get_messages(
    session_id: int,
    page: int = 1,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    chat_session = get_chat_session(
        db,
        session_id,
        current_user.id
    )

    if not chat_session:
        raise HTTPException(
            status_code=404,
            detail="Chat session not found"
        )

    messages = get_chat_messages(
        db,
        session_id,
        page,
        limit
    )

    return messages