from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.oauth import OAuthResponse, OAuthToken
from database import get_db
from security.tokenverify import verify_github_token
from security.auth import create_access_token
from crud.user import get_user_by_email_and_provider, create_user

router = APIRouter(prefix = "/auth", tags = ["Authentication"])


@router.post("/github/signup", response_model=OAuthResponse)
async def github_signup(
    data: OAuthToken,
    db: Session = Depends(get_db)
):
    github_user = await verify_github_token(data.token)

    email = github_user["email"]
    name = github_user["name"]

    user = get_user_by_email_and_provider(db, email, "github")

    if user:
        raise HTTPException(
            status_code=409,
            detail="User already exists. Please login."
        )

    user = create_user(db, name, email)

    access_token_jwt = create_access_token({
        "sub": str(user.id)
    })

    return {
        "access_token_jwt": access_token_jwt,
        "token_type": "bearer",
        "user": user
    }


@router.post("/github/login", response_model=OAuthResponse)
async def github_login(
    data: OAuthToken,
    db: Session = Depends(get_db)
):
    github_user = await verify_github_token(data.token)

    email = github_user["email"]

    user = get_user_by_email_and_provider(db, email, "github")

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