from sqlalchemy.orm import Session
from models.user import User


def create_user(db: Session, name: str, email: str, hashed_password: str):

    new_user = User(
        Name  = name,
        Email = email,
        password = hashed_password
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def get_user_by_email(db: Session, email: str):

    return db.query(User).filter(User.email == email).first()