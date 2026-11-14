from pydantic import BaseModel, Field, EmailStr, field_validator


class UserCreate(BaseModel):

    name     : str = Field(..., min_length=2, max_length=50)
    email    : EmailStr


    @field_validator("name")
    @classmethod
    def check_name(cls, value):

        if not value.replace(" ", "").isalpha():
            raise ValueError("The name is incorrect")

        return value.title()


class UserLogin(BaseModel):

    email    : EmailStr
    password : str


class UserResponse(BaseModel):

    id    : int
    name  : str
    email : EmailStr

model_config = {"from_attributes": True}