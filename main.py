from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from database import engine, Base
from app.models import Character, Equipment
from app.routes import router
import asyncio
import os
import signal
import sys
import webbrowser
import threading
import time

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

# Shutdown endpoint
@app.post("/api/shutdown")
async def shutdown():
    """Shutdown the server and close the terminal."""
    # Schedule the exit to happen after response is sent
    asyncio.create_task(delayed_shutdown())
    return {"message": "Server shutting down..."}

async def delayed_shutdown():
    """Delay shutdown to allow response to be sent."""
    await asyncio.sleep(0.5)
    # Force exit the Python process (closes terminal as well)
    os._exit(0)

def open_browser():
    """Open the browser after a short delay to allow server to start."""
    time.sleep(2)
    webbrowser.open('http://localhost:8000')

# Run the server
if __name__ == "__main__":
    import uvicorn
    
    # Start browser in background thread
    browser_thread = threading.Thread(target=open_browser, daemon=True)
    browser_thread.start()
    
    # Run the server
    uvicorn.run(app, host="0.0.0.0", port=8000)
