
from sqlalchemy.orm import Session
from models.chat_session import ChatSession


def create_chat_session(db: Session, user_id: int, title: str):
    new_session = ChatSession(
        user_id=user_id,
        title=title
    )

    db.add(new_session)
    db.commit()
    db.refresh(new_session)

    return new_session


def get_user_chat_sessions(
    db: Session,
    user_id: int,
    page: int = 1,
    limit: int = 10
):
    query = db.query(ChatSession)

    query = query.filter(ChatSession.user_id == user_id)

    start = (page - 1) * limit

    sessions = query.order_by(
        ChatSession.created_at.desc()
    ).offset(start).limit(limit).all()

    return sessions


def get_chat_session(db: Session, session_id: int, user_id: int):
    query = db.query(ChatSession)

    return query.filter(
        ChatSession.id == session_id,
        ChatSession.user_id == user_id
    ).first()


def delete_chat_session(db: Session, chat_session: ChatSession):
    db.delete(chat_session)
    db.commit()


def rename_chat_session(db: Session, chat_session: ChatSession, new_title: str):
    chat_session.title = new_title

    db.commit()
    db.refresh(chat_session)

    return chat_session
