## Week 5

### Question 1: Install Spark and PySpark
```
export JAVA_HOME="${HOME}/spark/jdk-11.0.2"
export PATH="${JAVA_HOME}/bin:${PATH}"

export SPARK_HOME="${HOME}/spark/spark-3.5.5-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"

export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"

spark-shell

import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

spark.version
```
#### Outputs
```
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.5.5
      /_/

Using Scala version 2.12.18 (OpenJDK 64-Bit Server VM, Java 11.0.2)
Type in expressions to have them evaluated.
Type :help for more information.
```
'3.5.5'

### Question 2: Yellow October 2024
Code in 'homework.ipynb'

ANSWER: 25MB

### Question 3: Count records
Code in 'homework.ipynb'

ANSWER: 128,893 ~ 125,567

### Question 4: Longest trip
Code in 'homework.ipynb'

ANSWER: 162.62 ~ 162

### Question 5: User Interface
ANSWER: 4040

### Question 6: Least frequent pickup location zone
Code in 'homework.ipynb'

ANSWER: Governor's Island/Ellis Island/Liberty Island