merge into TEMP.lve_weather sda
using TEMP.hld_weather sdn
on sda.id = sdn.id
when matched then
  update set city = sdn.city, dailytime = sdn.dailytime, temp_max = sdn.temp_max, temp_min = sdn.temp_min, sunset = sdn.sunset, sunrise = sdn.sunrise, windspeed = sdn.windspeed
when not matched then
  insert (id, city, dailytime, temp_max,temp_min,sunset,sunrise,windspeed)
  values (sdn.id, sdn.city, sdn.dailytime, sdn.temp_max,sdn.temp_min,sdn.sunset,sdn.sunrise,sdn.windspeed);
