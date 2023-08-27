
## Fetch the different cities json data and check if valid json is returned
###JHBRAW=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=-26.2023&longitude=28.0436&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,windspeed_10m_max&timezone=Africa%2FCairo&start_date=2023-08-01&end_date=2023-08-27")
JHBRAW=$(cat jhb.json)

if [ $(echo -n $JHBRAW | jq empty >  /dev/null 2>&1; echo $?) -eq 0 ]; then
        echo "JHB json is valid"
	JHBTIME=$(echo $JHBRAW | jq '.daily.time[]')
	JHBTEMPMAX=$(echo $JHBRAW | jq '.daily.temperature_2m_max[]')
	JHBTEMPMIN=$(echo $JHBRAW | jq '.daily.temperature_2m_min[]')
	JHBSUNSET=$(echo $JHBRAW | jq '.daily.sunset[]')
	JHBUNRISE=$(echo $JHBRAW | jq '.daily.sunrise[]')
	JHBWIND=$(echo $JHBRAW | jq '.daily.windspeed_10m_max[]')
	echo $JHBTIME
else
        echo "JHB json is invalid"
fi
