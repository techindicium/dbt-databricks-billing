# Databricks Billing
This package was built to help you monitor the costs involved in using Databricks as a data plataform. It makes it easier to keep up with the costs related to DBUs and clusters.

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
  - git:  # insert git URL
```
Then run `dbt deps` to finish the setup.

## Define database and schema
The location of the raw data to be used in this package is configurable, so it's importante to complete the following information at `dbt_project.yml`:
```yaml
vars:
  databricks_billing_database: # name of the database
  databricks_billing_schema: # name of the schema
```




