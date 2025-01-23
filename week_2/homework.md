# greglenane-de-hw

## Week 12
### Question 1
128.3 MB

### Question 2
{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv

once we ```{{render(vars.file)}}``` then this scenario would result in gree_tripdata_2020-04

### Question 3
```
select
  count(*)
from zoomcamp.yellow_tripdata 
where substr(filename, 17, 4) = '2020';
```
ANSWER: 24,648,499

### Question 4
```
select
  count(*)
from zoomcamp.green_tripdata 
where substr(filename, 16, 4) = '2020';
```
ANSWER: 1,734,051

### Question 5
```
select count(*)
from zoomcamp.yellow_tripdata
where substr(filename, 17, 7) = '2021-03'
```
ANSWER: 1,925,152

### Question 6
[Kestra trigger scheduling](https://kestra.io/docs/workflow-components/triggers/schedule-trigger)
Add a timezone property set to America/New_York in the Schedule trigger configuration