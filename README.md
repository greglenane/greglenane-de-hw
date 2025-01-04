# greglenane-de-hw

## Week 1
### Question 1. Knowing docker tags
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker --help
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker build --help
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker run --help
```
"docker run --rm" will automatically reomove the container when it exits

### Question 2. Understanding docker first run
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker run -it --entrypoint="bash" python:3.9
```
pip list
wheel version: 0.45.1

### Prepare Postgres
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ sudo chown 5050:5050 data_pgadmin
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ docker-compose up -d
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ sudo chmod a+rwx ny_taxi_postgres_data
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ wget wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ gzip -d green_tripdata_2019-09.csv.gz
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```
run prepare_postgres.ipynb

### Question 3. Count records
```
SELECT COUNT(*)
FROM ny_taxi_data
WHERE CAST(lpep_pickup_datetime AS DATE) = '2019-09-18' AND
	  CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18';
```

ANSER: 15612 trips

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

ANSWER: 2019-09-26 had the longest trip

### Question 5. Three biggest pick up Boroughs
```
SELECT
	zones."Borough" AS borough,
	COUNT(taxi.*) AS trips
FROM 
	ny_taxi_data taxi
LEFT JOIN
	zones ON taxi."PULocationID" = zones."LocationID"
WHERE 
	zones."Borough" != 'Unknown'
GROUP BY 
	zones."Borough"
ORDER BY
	trips DESC;
```

ANSWER: "Brooklyn" "Manhattan" "Queens"

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
	zpu."Zone" = 'Astoria'
GROUP BY
	zpu."Zone",
	zdo."Zone"
ORDER BY 
	max_tip DESC;
```

ANSWER: JFK Airport

### Terraform
```
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ export GOOGLE_APPLICATION_CREDENTIALS=~/terrademo/keys/my-creds.json
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
(base) greg@de-zoomcamp:~/greglenane-de-hw/week_1$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "ny-rides-gregl-446219"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)

      + access (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "ny-rides-gregl-446219-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type          = "AbortIncompleteMultipartUpload"
                # (1 unchanged attribute hidden)
            }
          + condition {
              + age                    = 1
              + matches_prefix         = []
              + matches_storage_class  = []
              + matches_suffix         = []
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }

      + versioning (known after apply)

      + website (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_storage_bucket.demo-bucket: Creation complete after 1s [id=ny-rides-gregl-446219-terra-bucket]
google_bigquery_dataset.demo_dataset: Creation complete after 1s [id=projects/ny-rides-gregl-446219/datasets/demo_dataset]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```