from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db

from schemas.user import UserSignup, UserLogin
from schemas.oauth import OAuthResponse,RefreshTokenRequest,RefreshTokenResponse
from models.user import User

from security.auth import (
    get_current_user, 
    create_access_token,
    create_refresh_token,
    verify_refresh_token
)

from crud.normaluser import (
    create_normal_user,
    get_normal_user_by_email
)

from security.passhash import (
    hash_password,
    verify_password,
)

router = APIRouter(prefix = "/auth", tags = ["Authentication"])

@router.post("/signup", response_model=OAuthResponse)
def normal_signup(
    data: UserSignup,
    db: Session = Depends(get_db)
):
    existing_user = get_normal_user_by_email(
        db,
        data.email,
        "Normal"
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
        hashed_password,
        "Normal"
    )

    access_token = create_access_token({
        "sub": str(new_user.id)
    })

    refresh_token = create_refresh_token({
        "sub": str(new_user.id)
    })

    return {
        "access_token_jwt": access_token,
        "refresh_token_jwt": refresh_token,
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
        data.email,
        "Normal"
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="Normal account not found. Please signup first."
        )

    if not user.hashed_password:
        raise HTTPException(
            status_code=400,
            detail="Password is not set for this account. Please use Google/GitHub login."
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

    refresh_token = create_refresh_token({
            "sub": str(user.id)
        })

    return {
        "access_token_jwt": access_token,
        "refresh_token_jwt": refresh_token,
        "token_type": "bearer",
        "user": user
    }



@router.post("/refresh", response_model = RefreshTokenResponse)
def refresh_access_token(
    data: RefreshTokenRequest,
    db: Session = Depends(get_db)
):
    user_id = verify_refresh_token(data.refresh_token)

    user = db.query(User).filter(
        User.id == user_id
    ).first()

    if user is None:
        raise HTTPException(
            status_code=401,
            detail="User not found"
        )

    new_access_token = create_access_token({
        "sub": str(user.id)
    })

    return {
        "access_token_jwt": new_access_token,
        "token_type": "bearer"
    }




@router.post("/logout")
def logout(
    current_user: User = Depends(get_current_user)
):
    return {
        "message": f"Logout successful for {current_user.name}"
    }