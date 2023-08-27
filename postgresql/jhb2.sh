
## Fetch the different cities json data and check if valid json is returned
###JHBRAW=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=-26.2023&longitude=28.0436&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max&timezone=Africa%2FCairo&start_date=2023-08-01&end_date=2023-08-27")
JHBRAW=$(cat jhb.json)

if [ $(echo -n $JHBRAW | jq empty >  /dev/null 2>&1; echo $?) -eq 0 ]; then
	# Clean up the temp table 
	psql -d netstock -a -f cleanup.sql
        #echo "JHB json is valid"
	echo $JHBRAW | jq '.daily.time[]' | tr -d '"' | awk '{print "JHB_"$1}' > id.csv
	echo $JHBRAW | jq '.daily.time[]' > timedaily.csv
	echo $JHBRAW | jq '.daily.temperature_2m_max[]' > tempmax.csv
	echo $JHBRAW | jq '.daily.temperature_2m_min[]' > tempmin.csv
	echo $JHBRAW | jq '.daily.sunset[]' > sunset.csv
	echo $JHBRAW | jq '.daily.sunrise[]' > sunrise.csv
	echo $JHBRAW | jq '.daily.windspeed_10m_max[]' > wind.csv
	rm out.csv
	#echo "dailytime,temperature_max,temperature_min,sunset,sunrise,windspeed" > out.csv
	paste -d',' id.csv timedaily.csv tempmax.csv tempmin.csv sunset.csv sunrise.csv wind.csv >>out.csv
	psql -d netstock -c "\copy temp.hld_weather from out.csv with delimiter ',' csv null as 'NULL';"
	#merge Delta changes into master table 
	psql -d netstock -a -f merge.sql
else
        echo "JHB json is invalid"
fi
