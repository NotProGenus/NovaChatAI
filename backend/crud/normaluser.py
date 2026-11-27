from sqlalchemy.orm import Session
from models.user import User

def create_normal_user(
    db: Session,
    name: str,
    email: str,
    hashed_password: str,
    provider: str
):
    new_user = User(
        name=name,
        email=email,
        provider=provider,
        hashed_password=hashed_password
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def get_normal_user_by_email(
    db: Session,
    email: str,
    provider : str
):
    query = db.query(User)

    user = query.filter(
        User.email == email,
        User.provider == provider
    ).first()

    return user
