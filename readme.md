
![chrome_AgOcikj3pi](https://github.com/user-attachments/assets/b830704f-af8c-4016-ac12-96ad94002916)

# Raw Claims ETL Pipeline

This repository contains an Apache Airflow DAG for processing healthcare claims data from customer CSV files and loading it into Snowflake.

## Features

- Dynamically determines the appropriate SQL transformation script based on the uploaded CSV file name.
- Uploads raw `.csv.gz` claim files to a Snowflake internal stage.
- Executes customer-specific transformations using SQL scripts stored in the repo.
- Loads transformed data into the `raw_claims` table in Snowflake.
- Performs basic data quality checks to validate the expected data range based on the file name.

## Components

- **Airflow DAG**: `raw_claims.py`
- **SQL Scripts**: `sql/customer_*.sql` (e.g., `customer_1_claims.sql`)
- **Utility Functions**: `utils.py`
- **Staging Area**: `RAW_CLAIMS_STAGE` (internal Snowflake stage)
- **Target Table**: `CLAIMS_DATABASE.PUBLIC.RAW_CLAIMS`

## Requirements

- Docker and Docker Compose
- Snowflake account with access to create databases, stages, and tables
- Python 3.12+
- Airflow with Snowflake provider installed

## Setup

1. Clone the repository.
2. Place customer CSV files into the `dags/` folder or configure a source path.
3. Configure Airflow Snowflake connection via UI or environment variables.
4. Start the Airflow containers:
   ```bash
   docker-compose up -d
   ```
5. Trigger the `raw_claims` DAG manually from the Airflow UI or CLI.

## Notes

- File naming must follow the format: `customer_<id>_inpatient_YYYYMMDD.csv.gz`.
- The expected date in the file name is used for validating that data falls within the correct monthly period.
- SQL transformation logic is mapped via the `customer_sql_mapping` table in PostgreSQL.

---

Let me know if you want to include usage examples or diagrams later.
