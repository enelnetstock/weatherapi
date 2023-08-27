#!/bin/bash

## This scrpt fetch the different cities json data and check if valid json is returned.
## It then transform the different columns and post the data to a postgresql temp table.
## Using the native postgresql merge statment to merge delta changes into the master table. 

##------------------------------------------------------
##--- Global Variables ---
##------------------------------------------------------
CITY="latitude=-40.710335&longitude=-73.99307"
STARTDATE="2023-06-01"
ENDDATE="2023-08-27"
WORKFOLDER=/media/sf_shared/netstock/postgresql
SQLLOG=$WORKFOLDER/log.txt
##------------------------------------------------------

##-- Load the JSON from the webservice into a temp variable --
JSONRAW=$(curl -s "https://api.open-meteo.com/v1/forecast?$CITY&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max&timezone=Africa%2FCairo&start_date=$STARTDATE&end_date=$ENDDATE")
###JHBRAW=$(cat $WORKFOLDER/jhb.json)
##-- Cleanup the log file
touch $SQLLOG
rm $SQLLOG

##------------------------------------------------------
##-- Check if the returned JSON is valid  and transform the columns into csv --
if [ $(echo -n $JSONRAW | jq empty >  /dev/null 2>&1; echo $?) -eq 0 ]; then
	# Clean up the temp table 
	psql -d netstock -a -f $WORKFOLDER/cleanup.sql >> $SQLLOG 2>&1
        #echo "JHB json is valid"
	echo $JSONRAW | jq '.daily.time[]' | tr -d '"' | awk '{print "NYC_"$1}' > $WORKFOLDER/id.csv
	echo $JSONRAW | jq '.daily.time[]' | tr -d '"' | awk '{print "New York"}' > $WORKFOLDER/city.csv
	echo $JSONRAW | jq '.daily.time[]' > $WORKFOLDER/timedaily.csv
	echo $JSONRAW | jq '.daily.temperature_2m_max[]' > $WORKFOLDER/tempmax.csv
	echo $JSONRAW | jq '.daily.temperature_2m_min[]' > $WORKFOLDER/tempmin.csv
	echo $JSONRAW | jq '.daily.sunset[]' > $WORKFOLDER/sunset.csv
	echo $JSONRAW | jq '.daily.sunrise[]' > $WORKFOLDER/sunrise.csv
	echo $JSONRAW | jq '.daily.windspeed_10m_max[]' > $WORKFOLDER/wind.csv
	touch $WORKFOLDER/out.csv
	rm $WORKFOLDER/out.csv
	#echo "dailytime,temperature_max,temperature_min,sunset,sunrise,windspeed" > out.csv
	paste -d',' $WORKFOLDER/id.csv $WORKFOLDER/city.csv $WORKFOLDER/timedaily.csv $WORKFOLDER/tempmax.csv $WORKFOLDER/tempmin.csv $WORKFOLDER/sunset.csv $WORKFOLDER/sunrise.csv $WORKFOLDER/wind.csv >>$WORKFOLDER/out.csv
	psql -d netstock -c "\copy temp.hld_weather from $WORKFOLDER/out.csv with delimiter ',' csv null as 'NULL';" >> $SQLLOG 2>&1
	#merge Delta changes into master table 
	psql -d netstock -a -f $WORKFOLDER/merge.sql >> $SQLLOG 2>&1
else
        echo "json is invalid"
fi
##------------------------------------------------------

##------------------------------------------------------
## Do a cleanup 
rm $WORKFOLDER/*.csv
##------------------------------------------------------
