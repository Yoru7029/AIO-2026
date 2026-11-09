import logging
import os

os.makedirs("/app/logs", exist_ok=True)
logging.basicConfig(
    filename="/app/logs/app.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
container_id = os.getenv("HOSTNAME", "unknown")
logging.info(f"Hello from container {container_id}")
print(f"Log saved from container {container_id}")