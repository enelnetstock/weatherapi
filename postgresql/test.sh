##cat jhb.json | jq '.daily.windspeed_10m_max[]'
if [ $(cat jhb.json | jq empty >  /dev/null 2>&1; echo $?) -eq 0 ]; then
	echo "json is valid"
else
	echo "json is invalid"
fi
