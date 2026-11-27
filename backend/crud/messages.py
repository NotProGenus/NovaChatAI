from sqlalchemy.orm import Session
from models.messages import Message

def create_message(
    db              : Session,
    chat_session_id : int,
    role            : str,
    content         : str
):
    new_message = Message(
        chat_session_id = chat_session_id,
        role = role,
        content = content
    )

    db.add(new_message)
    db.commit()
    db.refresh(new_message)

    return new_message


def get_chat_messages(
    db: Session,
    chat_session_id: int,
    page: int = 1,
    limit: int = 20
):
    query = db.query(Message)

    query = query.filter(
        Message.chat_session_id == chat_session_id
    )

    start = (page - 1) * limit

    messages = query.order_by(
        Message.created_at.desc()
    ).offset(start).limit(limit).all()

    return messages
