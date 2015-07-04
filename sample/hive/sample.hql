DROP TABLE IF EXISTS events;

CREATE TABLE events (
  patient_id STRING,
  event_name STRING,
  date_offset INT,
  value INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH 'data'
OVERWRITE INTO TABLE events;

SELECT patient_id, count(*) FROM events
GROUP BY patient_id;
