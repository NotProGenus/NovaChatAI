from pydantic import BaseModel, Field


class OAuthToken(BaseModel):

    token : str = Field(..., min_length=1)