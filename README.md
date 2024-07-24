# Databricks Billing
This package was built to help you monitor the costs involved in using Databricks as a data plataform. It makes it easier to keep up with the costs related to DBUs and clusters.

## Before creating a branch

Pay attention, it is very important to know if your modification to this repository is a release (breaking changes), a feature (functionalities) or a patch(to fix bugs). With that information, create your branch name like this:

- `release/<branch-name>` or `major/<branch-name>` or `Release/<branch-name>` or `Major/<branch-name>`
- `feature/<branch-name>` or `minor/<branch-name>` with capitalised letters work as well
- `patch/<branch-name>` or `fix/<branch-name>` or `hotfix/<branch-name>` with capitalised letters work as well


# Revisions
0.3.0 - For Snowflake warehouses
0.3.1 - For Databricks warehouses

# Quickstart
## Requirements
dbt
`dbt version >= 1.0.0`

dbt_utils package:
`dbt-labs/dbt_utils version: 1.1.1`

## Install the package
Include the following package version in your `packages.yml` file.
```yaml
packages:
  - git: https://github.com/techindicium/dbt-databricks-billing
    revision: # 0.3.0 or 0.3.1
```
Then run `dbt deps` to finish the setup.

## Define database and schema
The location of the raw data to be used in this package is configurable, so it's importante to complete the following information at `dbt_project.yml`:
```yaml
models:
  databricks_billing:
    marts:
      +materialized: table
    staging:
      +materialized: view

vars:
  databricks_billing_database: # name of the database
  databricks_billing_schema: # name of the schema
```




