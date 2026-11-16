from fastapi import FastAPI
from database import Base, engine
import models.user
import models.chat_session
import models.messages
from fastapi.middleware.cors import CORSMiddleware
from routers.general import router as general_router
from routers.google_auth import router as google_router
from routers.github_auth import router as github_router

app = FastAPI(
    title="NovaChat API",
    version="1.0.0"
)

Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

app.include_router(general_router)
app.include_router(google_router)
app.include_router(github_router)