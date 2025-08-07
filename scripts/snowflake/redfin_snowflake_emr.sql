DROP DATABASE IF EXISTS redfin_database;
CREATE DATABASE redfin_database;
CREATE SCHEMA redfin_schema;

// Create Table
CREATE OR REPLACE TABLE redfin_database.redfin_schema.redfin_table (
period_duration INT,
city STRING,
state STRING,
property_type STRING,
median_sale_price FLOAT,
median_ppsf FLOAT,
homes_sold FLOAT,
inventory FLOAT,
months_of_supply FLOAT,
median_dom FLOAT,
sold_above_list FLOAT,
period_end_yr STRING,
period_end_months STRING
);

// Create file format object
CREATE SCHEMA file_format_schema;
CREATE OR REPLACE file format redfin_database.file_format_schema.format_parquet
    type = 'PARQUET'
    COMPRESSION = 'SNAPPY'

// Create staging schema
CREATE SCHEMA external_stage_schema;

CREATE OR REPLACE STAGE redfin_database.external_stage_schema.redfin_ext_stage
    url="s3://redfin-data-emr/transformed-data/redfin_data.parquet"
    credentials=(aws_key_id='AKIAZDSAVGW7LY6TPHEW'
    aws_secret_key='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')
    FILE_FORMAT = redfin_database.file_format_schema.format_parquet;

--list @redfin_database.external_stage_schema.redfin_ext_stage;
--LIST @redfin_database.external_stage_schema.redfin_ext_stage/redfin_data.parquet/part-00000-81864254-d222-4998-9640-179b99b478f2-c000.snappy.parquet;


// Create schema for snowpipe
-- DROP SCHEMA redfin_database.snowpipe_schema;
CREATE OR REPLACE SCHEMA redfin_database.snowpipe_schema;

// Create Pipe
CREATE OR REPLACE PIPE redfin_database.snowpipe_schema.redfin_snowpipe
auto_ingest = TRUE
AS 
COPY INTO redfin_database.redfin_schema.redfin_table
FROM @redfin_database.external_stage_schema.redfin_ext_stage
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SELECT * FROM redfin_database.redfin_schema.redfin_table

DESC PIPE redfin_database.snowpipe_schema.redfin_snowpipe;




    