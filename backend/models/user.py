from sqlalchemy import Column, Integer, String
from database import Base
class User(Base):
    __tablename__ = "users"

    id       = Column(Integer, primary_key = True, index = True)
    name     = Column(String(30), nullable = False)
    email    = Column(String(50), unique = False, index = True, nullable = False)
    provider = Column(String(20), nullable=False)
    hashed_password = Column(String(255), nullable=True)