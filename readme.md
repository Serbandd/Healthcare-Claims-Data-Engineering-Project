

![Healthcare_claims_ETL](https://github.com/user-attachments/assets/aca015da-7bc2-4146-8853-f4f874466704)


📊 **About the Project**

This project uses synthetic Medicare claims data from CMS to simulate real-world healthcare data challenges. While the data is not linked to real patients, it mirrors the structure and complexity of actual claims, making it an ideal playground for data engineers to build production-grade pipelines without privacy concerns.

🏥 **Why This Data Matters**

Insurance companies rely heavily on claims data to track costs, spot billing anomalies, and detect fraud. Each medical procedure is tied to specific claim codes, which evolve over time, making it difficult to track changes in cost, policy, and procedure mapping across providers.

A single claims file may represent thousands of patients, procedures, and codes—data engineers must standardize, transform, and validate this at scale. For example:

A procedure billed at $1,000 by one provider may appear under a different claim code at $1,500 in another state.

Each provider or customer may require a custom SQL transformation depending on their schema, leading to dynamic ingestion and mapping logic.

🚧 **Main Challenges Addressed**

Tracking Pricing Changes Across Claims: Claim codes and their corresponding billing prices change frequently. Mapping and managing this over time requires intelligent design—especially for historical tracking.

Schema Differences Across Clients: Each insurance provider may structure and store their claims differently—some in AWS Redshift, others in Azure SQL, or Snowflake—forcing engineers to dynamically adapt SQL scripts and ingestion paths.

Insert vs. Upsert Logic: Some claims pipelines require full reloads, while others demand incremental upserts. Handling both in a generalized, scalable architecture is non-trivial.

Ensuring Data Quality & Trust: Missing claim IDs, duplicate records, and out-of-range dates directly impact downstream reporting and cost prediction models.

Complex Data Governance: Supporting data scientists and actuaries requires that data be clean, timely, and versioned properly for audits and regulatory reporting.

🧰 **Tech Stack: Solutions Implemente**

Layer	Tool	Role
Orchestration	Apache Airflow	DAG-based scheduling & dependency tracking
Data Warehouse	Snowflake	Scalable cloud warehouse for claims storage
Transformation	dbt	SQL-based modeling & data quality testing
Validation	Custom dbt Tests	Percent null, not null, and record consistency
Local Dev	Docker + VSCode	Environment containerization and reproducibility
🔭 Future Outlook
This foundational pipeline can be extended to drive powerful analytics use cases such as:

Diagnosis-Specific Projects
Overuse of Imaging (e.g., unnecessary MRIs or CT scans)

Diabetes Management Patterns over time

Provider-Level Insights
Readmission & Complication Rates

High-cost provider identification

Population-Level Trends
Chronic disease patterns

Pediatric treatment disparities





![Healthcare_claims_ETL](https://github.com/user-attachments/assets/aca015da-7bc2-4146-8853-f4f874466704)


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


## 🧪 Practical Use Cases for Analysts

This project goes beyond pipeline orchestration—it's designed to drive insights that improve healthcare delivery and cost efficiency. Using the cleaned and structured fact tables in the gold DBT layer, analysts and data scientists can power dashboards, audits, and ML-ready datasets.

Key Analytical Use Cases
- **🧍‍♂️ Duplicate Claim Detection**
Goal: Spot instances of repeated claim submissions for the same procedure and beneficiary.
Logic:

Group by beneficiary_id, provider_number, claim_start_date

Flag if COUNT(*) > 1

Use Case: Helps identify billing anomalies or fraud patterns for auditing and recovery.

 - **💰 Procedure Cost Benchmarking**
Goal: Evaluate cost consistency across regions and providers.
Logic:

Group by provider_number, claim_type_code, claim_payment_amount

Compare min, max, avg cost per procedure type

Use Case: Insights for insurance cost negotiations and fair pricing enforcement.

 - **🛡️ Underutilized Preventive Care**
Goal: Identify patients who likely didn’t receive preventive services.
Logic:

Assume preventive procedures have claim_payment_amount < $100

Identify beneficiary_ids missing such claims

Use Case: Supports outreach initiatives, preventive care programs, and cost-saving strategies.

 - **📈 Unified Metrics via DBT**
All gold-level analytical queries are written as DBT models under models/gold. This allows version-controlled transformation logic and easy downstream integration with tools like Power BI, Tableau, or Jupyter notebooks.
---

