from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
import pickle

# Load dataset
iris = load_iris()
X = iris.data
y = iris.target

# Train model
model = LogisticRegression(max_iter=200)
model.fit(X, y)

# Save model
model_name = "model_v2.pkl"
with open(model_name, "wb") as f:
    pickle.dump(model, f)
print("Model saved to", model_name)