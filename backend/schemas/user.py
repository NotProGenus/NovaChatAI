from pydantic import BaseModel, EmailStr, Field


class UserSignup(BaseModel):

    name: str = Field(..., min_length=2, max_length=100)

    email: EmailStr

    password: str = Field(..., min_length=8, max_length=128)


class UserLogin(BaseModel):

    email: EmailStr

    password: str = Field(..., min_length=1)
 
class UserResponse(BaseModel):

    id       : int
    name     : str
    email    : EmailStr
    provider : str
model_config = {"from_attributes": True}