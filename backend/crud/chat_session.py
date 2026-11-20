
from sqlalchemy.orm import Session
from models.chat_session import ChatSession
from models.messages import Message


def create_chat_session(db: Session, user_id: int, title: str):
    new_session = ChatSession(
        user_id = user_id,
        title = title
    )

    db.add(new_session)
    db.commit()
    db.refresh(new_session)

    return new_session


def get_user_chat_sessions(
    db      : Session,
    user_id : int,
    page    : int = 1,
    limit   : int = 10
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

    chat_session =  query.filter(
        ChatSession.id == session_id,
        ChatSession.user_id == user_id
    ).first()

    return chat_session


def rename_chat_session(db: Session, chat_session: ChatSession, new_title: str):
    chat_session.title = new_title

    db.commit()
    db.refresh(chat_session)

    return chat_session



def delete_chat_session(db: Session, chat_session: ChatSession):

    query = db.query(Message)

    query = query.filter(
        Message.chat_session_id == chat_session.id
    )

    query.delete(synchronize_session=False)

    db.delete(chat_session)
    db.commit()
