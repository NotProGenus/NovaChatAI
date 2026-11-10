import os
from dotenv import load_dotenv

from sqlalchemy import create_engine, URL
from sqlalchemy.orm import sessionmaker, DeclarativeBase

load_dotenv()

db_url = URL.create(
    drivername = "mysql+pymysql",
    host       = os.getenv("DB_HOST"),
    port       = int(os.getenv("DB_PORT")),
    username   = os.getenv("DB_USER"),
    password   = os.getenv("DB_PASSWORD"),
    database   = os.getenv("DB_NAME")
)

engine = create_engine(db_url)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

class Base(DeclarativeBase):
    pass

def get_db():
    db = SessionLocal()

    try:
        yield db
        
    finally:
        db.close()


