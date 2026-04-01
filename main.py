from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine, Base
from app.models import Character, Equipment
from app.routes import router

# Create all database tables
Base.metadata.create_all(bind=engine)

# Create FastAPI app
app = FastAPI(
    title="ListDetails API",
    description="Master-Detail CRUD API with Characters and Equipment",
    version="1.0.0"
)

# Enable CORS (allows frontend to call API)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include all routes
app.include_router(router)

# Root endpoint
@app.get("/")
def read_root():
    """Root endpoint - API info."""
    return {
        "message": "ListDetails API",
        "docs": "/docs",
        "redoc": "/redoc",
        "endpoints": {
            "characters": "/api/characters",
            "equipment": "/api/equipment"
        }
    }

# Run the server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
