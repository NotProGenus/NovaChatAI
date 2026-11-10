from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title ="NovaChat API",
    version = "1.0.0"
)

@app.get('/')
def root():
    return{
        "message" : "NovachatAI is running "
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy"
        }

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)