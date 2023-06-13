import random
import string
from typing import List

from fastapi import FastAPI, HTTPException, WebSocket
from fastapi.responses import JSONResponse
from starlette.websockets import WebSocketDisconnect

app = FastAPI()

# Store active connections
active_connections: List[WebSocket] = []

# Route for creating a new audio stream
@app.post("/stream")
async def create_stream():
    try:
        stream_id = generate_unique_id()  # Implement your logic to generate a unique stream ID
        return JSONResponse({"stream_id": stream_id})
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Route for joining an existing audio stream
@app.websocket("/stream/{stream_id}")
async def join_stream(stream_id: str, websocket: WebSocket):
    try:
        await websocket.accept()
        active_connections.append(websocket)
        try:
            while True:
                audio_data = await websocket.receive_bytes()
                await broadcast(audio_data)
        except WebSocketDisconnect:
            active_connections.remove(websocket)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Broadcast audio data to all active connections
async def broadcast(audio_data: bytes):
    for connection in active_connections:
        try:
            await connection.send_bytes(audio_data)
        except Exception as e:
            print("Error broadcasting audio data:", str(e))
            # You can handle the error according to your requirements

# Function to generate a unique stream ID
def generate_unique_id():
    k = 3
    word1 = ''.join(random.choices(string.ascii_lowercase, k=k))
    word2 = ''.join(random.choices(string.ascii_lowercase, k=k))
    word3 = ''.join(random.choices(string.ascii_lowercase, k=k))
    return f"{word1}-{word2}-{word3}"

