import requests

url = "http://api-container:8000/sqrt"

response = requests.post(
    url,
    params={"x": 25}
)
print("Status Code:", response.status_code)
print("Response:", response.json())