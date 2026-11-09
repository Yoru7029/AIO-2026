from fastapi import FastAPI
import math

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/sqrt")
def sqrt(x: float):
    return {
        "input": x,
        "result": math.sqrt(x)
    }