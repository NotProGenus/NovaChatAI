from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.oauth import OAuthResponse, OAuthToken
from database import get_db
from security.tokenverify import verify_google_token
from security.auth import create_access_token
from crud.user import get_user_by_email_and_provider, create_user

router = APIRouter(prefix = "/auth", tags = ["Authentication"])

@router.post("/google/signup", response_model=OAuthResponse)
def google_signup(
    data: OAuthToken,
    db: Session = Depends(get_db)
):
    google_user = verify_google_token(data.token)

    email = google_user["email"]
    name = google_user.get("name") or email.split("@")[0]

    user = get_user_by_email_and_provider(db, email,"google")

    if user:
        raise HTTPException(
            status_code=409,
            detail="User already exists. Please login."
        )

    user = create_user(db, name, email, "google")

    access_token_jwt = create_access_token({
        "sub": str(user.id)
    })

    return {
        "access_token_jwt": access_token_jwt,
        "token_type": "bearer",
        "user": user
    }


@router.post("/google/login", response_model=OAuthResponse)
def google_login(
    data: OAuthToken,
    db: Session = Depends(get_db)
):
    google_user = verify_google_token(data.token)

    email = google_user["email"]

    user = get_user_by_email_and_provider(db, email, "google")

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User does not exist. Please signup."
        )

    access_token_jwt = create_access_token({
        "sub": str(user.id)
    })

    return {
        "access_token_jwt": access_token_jwt,
        "token_type": "bearer",
        "user": user
    }



