import os
import time
import requests
from dagster import asset, Failure

AIRBYTE_API = "https://api.airbyte.com/v1"

@asset(name="bronze_airbyte_sync")
def bronze_airbyte_sync():
    token = os.getenv("AIRBYTE_TOKEN")
    connection_id = os.getenv("AIRBYTE_CONNECTION_ID")

    if not token or not connection_id:
        raise Failure("Missing AIRBYTE_TOKEN or AIRBYTE_CONNECTION_ID")

    trigger = requests.post(
        f"{AIRBYTE_API}/connections/sync",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={"connectionId": connection_id},
    )
    trigger.raise_for_status()

    job_id = trigger.json()["job"]["id"]

    # 2️⃣ Poll job status
    while True:
        status = requests.post(
            f"{AIRBYTE_API}/jobs/get",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json",
            },
            json={"id": job_id},
        )
        status.raise_for_status()

        job_status = status.json()["job"]["status"]

        if job_status == "succeeded":
            return {"job_id": job_id}

        if job_status in ("failed", "cancelled"):
            raise Failure(f"Airbyte job {job_id} {job_status}")

        time.sleep(30)
