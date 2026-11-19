from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db

from schemas.user import UserSignup, UserLogin
from schemas.oauth import OAuthResponse

from crud.normaluser import (
    create_normal_user,
    get_normal_user_by_email
)

from security.passhash import (
    hash_password,
    verify_password,
    create_access_token
)

router = APIRouter(prefix = "/auth", tags = ["Authentication"])

@router.post("/signup", response_model=OAuthResponse)
def normal_signup(
    data: UserSignup,
    db: Session = Depends(get_db)
):
    existing_user = get_normal_user_by_email(
        db,
        data.email
    )

    if existing_user:
        raise HTTPException(
            status_code=409,
            detail="Email already registered"
        )

    hashed_password = hash_password(data.password)

    new_user = create_normal_user(
        db,
        data.name,
        data.email,
        hashed_password
    )

    access_token = create_access_token({
        "sub": str(new_user.id)
    })

    return {
        "access_token_jwt": access_token,
        "token_type": "bearer",
        "user": new_user
    }


@router.post("/login", response_model=OAuthResponse)
def normal_login(
    data: UserLogin,
    db: Session = Depends(get_db)
):
    user = get_normal_user_by_email(
        db,
        data.email
    )

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    if not user.hashed_password:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    is_valid = verify_password(
        data.password,
        user.hashed_password
    )

    if not is_valid:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    access_token = create_access_token({
        "sub": str(user.id)
    })

    return {
        "access_token_jwt": access_token,
        "token_type": "bearer",
        "user": user
    }