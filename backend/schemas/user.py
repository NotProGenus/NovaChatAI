from pydantic import BaseModel, EmailStr
 
class UserResponse(BaseModel):

    id       : int
    name     : str
    email    : EmailStr
    provider : str
model_config = {"from_attributes": True}