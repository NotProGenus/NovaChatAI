from sqlalchemy.orm import Session
from models.user import User


def create_user(db: Session, name: str, email: str, provider: str):

    new_user = User(
        Name  = name,
        Email = email,
        provider = provider
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def get_user_by_email_and_provider(db: Session, email: str):

    query = db.query(User)

    return query.filter(User.email == email).first()