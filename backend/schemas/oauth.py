from pydantic import BaseModel, Field
from schemas.user import UserResponse

class OAuthToken(BaseModel):
    token : str = Field(..., min_length=1)

class OAuthResponse(BaseModel):
    access_token_jwt     : str
    refresh_token_jwt    : str
    token_type           : str
    user                 : UserResponse

    model_config = {"from_attributes": True}

class RefreshTokenRequest(BaseModel):
    refresh_token : str = Field(..., min_length=1)

class RefreshTokenResponse(BaseModel):
    access_token_jwt : str = Field(..., min_length = 1)

    model_config = {"from_attributes": True}

