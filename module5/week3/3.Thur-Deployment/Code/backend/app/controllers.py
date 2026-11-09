import numpy as np
from PIL import Image
from rapidocr import RapidOCR
from app.schemas import OCR_Output

# Load the models once at startup instead of on every request
OCR_ENGINE = RapidOCR()

def extract_ocr(image_path) -> list[OCR_Output]:
    pil_img = Image.open(image_path).convert("RGB")
    result = OCR_ENGINE(np.asarray(pil_img))

    # RapidOCR returns None fields when no text is found
    if result.boxes is None:
        return []

    return [
        OCR_Output(
            bbox=[[int(x) for x in point] for point in box],
            text=str(text),
            score=float(score),
        )
        for box, text, score in zip(result.boxes, result.txts, result.scores)
    ]
