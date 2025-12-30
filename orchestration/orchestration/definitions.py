from dagster import Definitions
from orchestration.assets import bronze_airbyte_sync
from orchestration.assets import dbt_models

defs = Definitions(
    assets=[
        bronze_airbyte_sync,
        dbt_models,
    ]
)
