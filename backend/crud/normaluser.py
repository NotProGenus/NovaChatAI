from sqlalchemy.orm import Session
from models.user import User


def create_normal_user(
    db: Session,
    name: str,
    email: str,
    hashed_password: str
):
    new_user = User(
        name=name,
        email=email,
        provider="normal",
        hashed_password=hashed_password
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def get_normal_user_by_email(
    db: Session,
    email: str
):
    query = db.query(User)

    user = query.filter(
        User.email == email,
        User.provider == "normal"
    ).first()

    return user
