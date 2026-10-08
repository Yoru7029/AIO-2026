import pandas as pd
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression

# Required imports

# Load and split data
data = pd.read_csv("data.csv")
train_data, test_data = train_test_split(data, test_size=0.3)

# Classification - Logistic Regression


def logistic_regression(train_data, test_data):
    model = LogisticRegression()
    model.fit(train_data.drop('label', axis=1), train_data['label'])
    predictions = model.predict(test_data.drop('label', axis=1))
    return predictions

# Regression - Linear Regression


def linear_regression(train_data, test_data):
    model = LinearRegression()
    model.fit(train_data.drop('label', axis=1), train_data['label'])
    predictions = model.predict(test_data.drop('label', axis=1))
    return predictions

# Clustering - KMeans


def kmeans_clustering(data):
    model = KMeans(n_clusters=3)
    predictions = model.fit_predict(data)
    return predictions

# Data Preprocessing - StandardScaler


def scale_features(data):
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(data)
    return scaled_data

# Data Preprocessing - LabelEncoder (for categorical variables)


def index_categorical_features(data):
    le = LabelEncoder()
    data['category'] = le.fit_transform(data['category'])
    return data

# Model Evaluation - accuracy for classification tasks


def evaluate_model(predictions, labels):
    accuracy = accuracy_score(labels, predictions)
    return accuracy

