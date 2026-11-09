import numpy as np
import pickle

with open("model.pkl", "rb") as f:
    model = pickle.load(f)

prediction = model.predict([[2.2, 3.6, 5.3, 4.8]])
print(prediction)
