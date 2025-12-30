from dagster_dbt import DbtProject, dbt_assets

dbt_project = DbtProject(
    project_dir="D:\markAyman\personal_projects\dbt_projects\social_media_addiction_dbt\dbt\social_media_addiction",      # folder with dbt_project.yml
    profiles_dir="C:\Users\mark\.dbt"      # folder with profiles.yml
)

@dbt_assets(manifest=dbt_project.manifest_path)
def dbt_models():
    pass
