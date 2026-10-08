# Required imports
from pyspark.sql import SparkSession
from pyspark.mllib.classification import LogisticRegressionWithLBFGS
from pyspark.mllib.regression import LinearRegressionWithSGD
from pyspark.mllib.clustering import KMeans
from pyspark.mllib.feature import StandardScaler, StringIndexer
from pyspark.mllib.evaluation import MulticlassMetrics
from pyspark.mllib.recommendation import ALS, Rating

# Initialize Spark session
spark = SparkSession.builder.appName("MLlib_Example").getOrCreate()

# Load and split data
data = spark.read.csv("data.csv", header=True, inferSchema=True).rdd
train_data, test_data = data.randomSplit([0.7, 0.3])

# Classification - Logistic Regression
def logistic_regression(train_data, test_data):
    model = LogisticRegressionWithLBFGS.train(train_data)
    predictions = model.predict(test_data.map(lambda x: x.features))
    return predictions

# Regression - Linear Regression
def linear_regression(train_data, test_data):
    model = LinearRegressionWithSGD.train(train_data)
    predictions = model.predict(test_data.map(lambda x: x.features))
    return predictions

# Clustering - KMeans
def kmeans_clustering(data):
    model = KMeans.train(data.map(lambda x: x.features), k=3)
    predictions = model.predict(data.map(lambda x: x.features))
    return predictions

# Collaborative Filtering - ALS
def collaborative_filtering(ratings):
    model = ALS.train(ratings, rank=10, iterations=10)
    unrated_data = spark.parallelize([(user_id, product_id)])
    predictions = model.predictAll(unrated_data)
    return predictions

# Data Preprocessing - StandardScaler
def scale_features(data):
    scaler = StandardScaler(inputCol="features", outputCol="scaledFeatures")
    scaled_data = scaler.fit(data).transform(data)
    return scaled_data

# Data Preprocessing - StringIndexer (for categorical variables)
def index_categorical_features(data):
    indexer = StringIndexer(inputCol="category", outputCol="categoryIndex")
    indexed_data = indexer.fit(data).transform(data)
    return indexed_data

# Model Evaluation - MulticlassMetrics for classification tasks
def evaluate_model(predictions, labels):
    prediction_and_labels = predictions.zip(labels)
    metrics = MulticlassMetrics(prediction_and_labels)
    accuracy = metrics.accuracy
    return accuracy
