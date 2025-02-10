# greglenane-de-hw

## Week 3
### Big Query Table setup
```
CREATE OR REPLACE EXTERNAL TABLE ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_external
OPTIONS(
  FORMAT = 'PARQUET',
  uris = ['gs://ny-rides-gregl-446219-gcp-bucket/yellow_tripdata_2024*.parquet']
);

CREATE OR REPLACE TABLE `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024` AS 
SELECT * FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_external`;
```

### Question 1
```
SELECT COUNT(*) FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`;
```
ANSWER: 20,332,093

### Question 2
```
SELECT COUNT(DISTINCT PULocationID) FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_external`;
SELECT COUNT(DISTINCT PULocationID) FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`;
```
ANSWER: 0 MB for the External Table and 155.12 MB for the Materialized Table

### Question 3
```
SELECT PULocationID FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`;
SELECT PULocationID, DOLocationID FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`;
```
ANSWER: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

### Question 4
```
SELECT COUNT(*)
FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`
WHERE fare_amount = 0;
```
ANSWER: 8333

### Question 5
```
CREATE OR REPLACE TABLE `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_external`;
```
ANSWER: Partition by tpep_dropoff_datetime and Cluster on VendorID

### Question 6
```
SELECT DISTINCT VendorID 
FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT VendorID 
FROM `ny-rides-gregl-446219.de_zoomcamp_hw3.yellow_taxi_2024_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```
ANSWER: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

### Question 7
ANSWER: GCP Bucket

### Question 8
ANSWER: FALSE

### Question 9
ANSWER: 0 bytes. This is because we are not querying a specific column and the table row count is stored and accessed in metadata.