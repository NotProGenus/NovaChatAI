import os
import httpx
from dotenv import load_dotenv
from fastapi import HTTPException
from google.oauth2 import id_token
from google.auth.transport import requests

load_dotenv()

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")

def verify_google_token(token: str):
    try:
        user_data = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )

        if not user_data.get("email_verified"):
            raise HTTPException(
                status_code=401,
                detail="Google email is not verified"
            )

        return {
            "email": user_data["email"],
            "name": user_data.get("name")
        }

    except ValueError:
        raise HTTPException(
            status_code=401,
            detail="Invalid Google ID Token"
        )



async def verify_github_token(token: str):

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json"
    }

    async with httpx.AsyncClient() as client:

        response = await client.get(
            "https://api.github.com/user",
            headers=headers
        )

        if response.status_code != 200:
            raise HTTPException(
                status_code=401,
                detail="Invalid GitHub token"
            )

        user_data = response.json()

        email_response = await client.get(
            "https://api.github.com/user/emails",
            headers=headers
        )

        if email_response.status_code != 200:
            raise HTTPException(
                status_code=400,
                detail="Unable to fetch GitHub email"
            )

        emails = email_response.json()

    primary_email = next(
        (
            item["email"]
            for item in emails
            if item.get("primary") and item.get("verified")
        ),
        None
    )

    if not primary_email:
        raise HTTPException(
            status_code=400,
            detail="Verified GitHub email not found"
        )

    name = user_data.get("name") or user_data.get("login")

    if not name:
        raise HTTPException(
            status_code=400,
            detail="GitHub username not found"
        )

    return {
        "email": primary_email,
        "name": name
    }


    