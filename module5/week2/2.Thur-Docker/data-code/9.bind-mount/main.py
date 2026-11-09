import numpy as np
import pickle
import os

model_name = os.getenv("MODEL_NAME")
with open(model_name, "rb") as f:
    model = pickle.load(f)

prediction = model.predict([[2.2, 3.6, 5.3, 4.8]])
print(model_name, prediction)