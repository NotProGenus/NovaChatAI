from pydantic import BaseModel, Field
from schemas.user import UserResponse

class OAuthToken(BaseModel):

    token : str = Field(..., min_length=1)

class OAuthResponse(BaseModel):
    access_token_jwt : str
    token_type   : str
    user         : UserResponse