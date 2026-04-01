from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
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

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Include all routes
app.include_router(router)

# Root endpoint - serve frontend
@app.get("/", response_class=FileResponse)
def read_root():
    """Serve the frontend HTML."""
    return "templates/index.html"

# Run the server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
