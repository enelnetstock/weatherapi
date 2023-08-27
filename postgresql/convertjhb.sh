cat jhb.json | jq '.daily.time[]' > jhbTime
cat jhb.json | jq '.daily.temperature_2m_max[]' > jhbmax
cat jhb.json | jq '.daily.temperature_2m_min[]' > jhbmin
cat jhb.json | jq '.daily.sunset[]' > jhbsunset
cat jhb.json | jq '.daily.sunrise[]' > jhbsunrise
cat jhb.json | jq '.daily.windspeed_10m_max[]' > jhbwindspeedmax

