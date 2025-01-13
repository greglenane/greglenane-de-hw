# greglenane-de-hw

## Week 1
### Question 1. Understanding docker first run
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker run -it --entrypoint="bash" python:3.12.8
pip list
```
pip version: 24.3.1

### Question 2. Understanding Docker networking and docker-compose
postgres:5432

### Prepare Postgres
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ wget wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ gzip -d green_tripdata_2019-10.csv.gz
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ sudo chown 5050:5050 data_pgadmin
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker-compose up -d
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ sudo chmod a+rwx ny_taxi_postgres_data
```
run week_1/prepare_postgres.ipynb

### Question 3. Trip Segmentation Count
*Assumption: trip distace field is in miles unit
```
SELECT 
	COUNT(*)
FROM ny_taxi_data
WHERE 
	lpep_pickup_datetime >= DATE '2019-10-01' AND
	lpep_dropoff_datetime < DATE '2019-11-01' AND
	trip_distance <= 1;

SELECT 
	COUNT(*)
FROM ny_taxi_data
WHERE 
	lpep_pickup_datetime >= DATE '2019-10-01' AND
	lpep_dropoff_datetime < DATE '2019-11-01' AND
	trip_distance > 1 AND
	trip_distance <= 3;

SELECT 
	COUNT(*)
FROM ny_taxi_data
WHERE 
	lpep_pickup_datetime >= DATE '2019-10-01' AND
	lpep_dropoff_datetime < DATE '2019-11-01' AND
	trip_distance > 3 AND
	trip_distance <= 7;

SELECT 
	COUNT(*)
FROM ny_taxi_data
WHERE 
	lpep_pickup_datetime >= DATE '2019-10-01' AND
	lpep_dropoff_datetime < DATE '2019-11-01' AND
	trip_distance > 7 AND
	trip_distance <= 10;

SELECT 
	COUNT(*)
FROM ny_taxi_data
WHERE 
	lpep_pickup_datetime >= DATE '2019-10-01' AND
	lpep_dropoff_datetime < DATE '2019-11-01' AND
	trip_distance > 10;
```
ANSWER:

### Question 4. Longest trip for each day
```
SELECT 
	CAST(lpep_pickup_datetime AS DATE) AS pu_date,
	MAX(trip_distance) AS max_trip_distance
FROM ny_taxi_data
GROUP BY 
	pu_date
ORDER BY  
	max_trip_distance DESC
LIMIT 10;
```
ANSWER: 2019-10-31

### Question 5. Three biggest pickup zones
```
SELECT
	zones."Zone" AS borough,
	SUM(taxi.total_amount) as total_amount_sum
FROM 
	ny_taxi_data taxi
LEFT JOIN
	zones ON taxi."PULocationID" = zones."LocationID"
WHERE 
	CAST(lpep_pickup_datetime AS DATE) = DATE '2019-10-18'
GROUP BY 
	zones."Zone"
ORDER BY
	total_amount_sum DESC;
```
ANSWER: East Harlem North, East Harlem South, Morningside Heights

### Question 6. Largest tip
```
SELECT 
	zpu."Zone" AS pickup_zone,
	zdo."Zone" AS dropoff_zone,
	MAX(t."tip_amount") AS max_tip
FROM
	ny_taxi_data t
LEFT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
LEFT JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
WHERE
	zpu."Zone" = 'East Harlem North'
GROUP BY
	zpu."Zone",
	zdo."Zone"
ORDER BY 
	max_tip DESC;
```
ANSWER: JFK Airport

## Terraform

### Question 7. Terraform Workflow
ANSWER: terraform init, terraform apply -auto-aprove, terraform destroy
