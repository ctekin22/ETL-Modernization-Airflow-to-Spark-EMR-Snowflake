# Real Estate Data ETL Pipeline Modernization (Python + Airflow â Apache Spark + EMR + Snowflake)

## Project Overview

This project showcases the **modernization of a real estate data pipeline** originally built using **Python scripts with Airflow**, which was later upgraded to a **distributed, scalable solution using Apache Spark on Amazon EMR**, while still leveraging **Apache Airflow** for orchestration and **Snowflake** as the cloud data warehouse.

---

## Modernization Path (Same Orchestrator, Smarter Execution Engine)

### Legacy Stack

- **ETL Engine**: Pure Python scripts
- **Orchestration**: Apache Airflow
- **Storage**: AWS S3
- **Limitations**:
  - Single-threaded Python processing
  - Performance bottlenecks with large files
  - Difficult to scale compute dynamically

### Modern Stack

- **ETL Engine**: Apache Spark on Amazon EMR
- **Orchestration**: Apache Airflow (retained)
- **Data Warehouse**: Snowflake (via Snowpipe ingestion)
- **Benefits**:
  - Spark for distributed, fault-tolerant transformation
  - EMR clusters provisioned on demand and terminated automatically
  - Clean separation between raw and transformed data zones

---

## Tools & Technologies Used

| Category             | Tools/Technologies                                          |
|----------------------|-------------------------------------------------------------|
| **Workflow Engine**  | Apache Airflow                                              |
| **ETL Engines**      | Python (initial) â Apache Spark on Amazon EMR (modern)      |
| **Cloud Platform**   | Amazon Web Services (EMR, S3, IAM, VPC)                     |
| **Data Warehouse**   | Snowflake (with Snowpipe and External Stages)               |
| **Storage Format**   | CSV (initial) â Parquet (optimized)                         |
| **File Transfer**    | Shell scripts using `wget`, S3, and Spark Jobs              |
| **Automation**       | EMR job flow operators, EMR step sensors, Snowpipe ingest   |

---

## Project Architecture & Planning (Apache Spark + Airflow + EMR + Snowflake)

### Phase 1: Initial MVP using Python + AWS Lambda

- Wrote basic ETL scripts in Python
- Triggered execution using AWS Lambda
- Loaded and transformed Redfin real estate data
- Stored data in AWS S3 buckets
- Faced Lambda limitations with larger datasets

---

### Phase 2: Modernizing to Apache Spark on Amazon EMR (Scalable Compute)

- Replaced Python processing with **Spark jobs** for distributed performance
- Launched **EMR clusters** dynamically using `EmrCreateJobFlowOperator`
- Wrote **Spark steps** for:
  - **Extraction**: Downloading and preparing Redfin CSVs
  - **Transformation**: Cleaning, filtering, and converting to **Parquet**
- Automatically terminated clusters to control AWS costs

---

### Phase 3: Pipeline Orchestration with Apache Airflow (Workflow Automation)

- Used `EmrAddStepsOperator`, `EmrStepSensor`, and `EmrTerminateJobFlowOperator`
- Tracked job and step execution with Airflow **XComs and Sensors**
- AWS credentials: IAM role
- Modular Airflow DAG with:
  - `start_pipeline` â create EMR â add steps â monitor â terminate â `end_pipeline`

---

### Phase 4: Cloud-Native Data Ingestion with Snowflake + Snowpipe (Data Warehousing)

- Defined **Parquet FILE FORMAT** in Snowflake
- Created **external stage** pointing to transformed S3 location
- Used **Snowpipe** with `auto_ingest = TRUE` to:
  - Listen to S3 event notifications
  - Trigger `COPY INTO` commands for Snowflake table population
- Addressed compatibility by using `MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE`
  
---

## Data Flow Summary (End-to-End)

1. **Ingestion**: Spark job downloads and unzips Redfin data â stores raw in S3
2. **Transformation**: Spark job cleans and converts CSV â Parquet â stores transformed data in S3
3. **Ingestion to Warehouse**: Snowpipe listens for new Parquet â triggers copy to Snowflake

---

## Highlights & Achievements

- Migrated from single-threaded Python to scalable Spark on EMR
- Orchestrated entire process with Airflow (same DAG design, smarter steps)
- Used Snowflake best practices for file format, stages, and ingestion
- Built a modular, cost-effective, and scalable data pipeline

---

## Skills Demonstrated

- Data pipeline orchestration using Apache Airflow
- Distributed data processing with Apache Spark on EMR
- AWS EMR provisioning and lifecycle automation
- Snowflake external stage and Snowpipe configuration
- PySpark-based data cleaning and format conversion (CSV â Parquet)
- Working with Airflow XComs, sensors, and dynamic cluster/job tracking

---

