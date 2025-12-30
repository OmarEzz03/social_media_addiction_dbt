import os
import time
import requests
from dagster import asset, Failure

from dagster_dbt import DbtProject, dbt_assets

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



dbt_project = DbtProject(
    project_dir="D:\\markAyman\\personal_projects\\dbt_projects\\social_media_addiction_dbt\\dbt\\social_media_addiction",      # folder with dbt_project.yml
    profiles_dir="C:\\Users\\mark\\.dbt"      # folder with profiles.yml
    )

import re

def sanitize_name(name: str) -> str:
    """Replace invalid Dagster characters with underscores."""
    return re.sub(r"[^A-Za-z0-9_]", "_", name)

@dbt_assets(manifest=dbt_project.manifest_path)
def dbt_models():
    assets = {}
    for node_name, node in dbt_project.manifest.nodes.items():
        sanitized_name = sanitize_name(node["name"])
        assets[sanitized_name] = node
    return assets