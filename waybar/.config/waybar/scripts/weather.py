#!/usr/bin/env python3

from pyquery import PyQuery  # install using `pip install pyquery`
import json


################################### CONFIGURATION ###################################

# set your location_id
# to get your location_id, go to https://weather.com & search for your location.
# once you choose your location, you can see the location_id in the URL(64 chars long hex string)
# like this: https://weather.com/en-IN/weather/today/l/c3e96d6cc4965fc54f88296b54449571c4107c73b9638c16aafc83575b4ddf2e
# once you get the location_id, you can replace the below location_id with your own location_id
location_id = "c1e3ee55dee3715e0f7fbce1767941dbaaf0425a8a960e234439d087f8037aa5"  # TODO

# celcius or fahrenheit
unit = "metric"  # metric or imperial

# forcase type
forecast_type = "Hourly"  # Hourly or Daily

########################################## MAIN ##################################

# weather icons
WEATHER_CODES = {
    "113": "☀️",
    "116": "⛅️",
    "119": "☁️",
    "122": "☁️",
    "143": "🌫",
    "176": "🌦",
    "179": "🌧",
    "182": "🌧",
    "185": "🌧",
    "200": "⛈",
    "227": "🌨",
    "230": "❄️",
    "248": "🌫",
    "260": "🌫",
    "263": "🌦",
    "266": "🌦",
    "281": "🌧",
    "284": "🌧",
    "293": "🌦",
    "296": "🌦",
    "299": "🌧",
    "302": "🌧",
    "305": "🌧",
    "308": "🌧",
    "311": "🌧",
    "314": "🌧",
    "317": "🌧",
    "320": "🌨",
    "323": "🌨",
    "326": "🌨",
    "329": "❄️",
    "332": "❄️",
    "335": "❄️",
    "338": "❄️",
    "350": "🌧",
    "353": "🌦",
    "356": "🌧",
    "359": "🌧",
    "362": "🌧",
    "365": "🌧",
    "368": "🌨",
    "371": "❄️",
    "374": "🌧",
    "377": "🌧",
    "386": "⛈",
    "389": "🌩",
    "392": "⛈",
    "395": "❄️",
}

weather_icons = {
    "sunnyDay": "☀️",
    "clearNight": "",
    "cloudyFoggyDay": "",
    "cloudyFoggyNight": "",
    "rainyDay": "",
    "rainyNight": "",
    "snowyIcyDay": "",
    "snowyIcyNight": "",
    "severe": "",
    "default": "",
}

# get html page
_l = "en-IN" if unit == "metric" else "en-US"
url = f"https://weather.com/{_l}/weather/today/l/{location_id}"

# get html data
html_data = PyQuery(url=url)
# current temperature
temp = html_data("span[data-testid='TemperatureValue']").eq(0).text()
# current status phrase
status = html_data("div[data-testid='wxPhrase']").text()
status = f"{status[:16]}.." if len(status) > 17 else status

# status code
# status_code_class = html_data("div[data-testid='wxIcon']")
# print(status_code_class.html())
# status_code = str(status_code_class).split(" ")[1].split("-")[2]
status_code = "default"

# status icon
icon = (
    weather_icons[status_code]
    if status_code in weather_icons
    else weather_icons["default"]
)

# temperature feels like
temp_feel = html_data(
    "div[data-testid='FeelsLikeSection'] > span > span[data-testid='TemperatureValue']"
).text()
temp_feel_text = f"Feels like {temp_feel}{'c' if unit == 'metric' else 'f'}"

# min-max temperature
temp_min = (
    html_data("div[data-testid='wxData'] > span[data-testid='TemperatureValue']")
    .eq(1)
    .text()
)
temp_max = (
    html_data("div[data-testid='wxData'] > span[data-testid='TemperatureValue']")
    .eq(0)
    .text()
)
temp_min_max = f"  {temp_min}\t\t  {temp_max}"

# wind speed
wind_speed = str(html_data("span[data-testid='Wind']").text())
wind_text = f"煮  {wind_speed}"

# humidity
humidity = html_data("span[data-testid='PercentageValue']").text()
humidity_text = f"  {humidity}"

# visibility
visbility = html_data("span[data-testid='VisibilityValue']").text()
visbility_text = f"  {visbility}"

# air quality index
air_quality_index = html_data("text[data-testid='DonutChartValue']").text()

# rain prediction
r_prediction_text = html_data(f"section[aria-label='{forecast_type} Forecast']")(
    "div[data-testid='SegmentPrecipPercentage'] > span"
).text()
r_prediction = str(r_prediction_text).replace("Chance of Rain", "")
r_prediction = (
    f"    ({forecast_type}) {r_prediction}" if len(r_prediction) > 0 else r_prediction
)

# temperature prediction
t_prediction_text = html_data(f"section[aria-label='{forecast_type} Forecast']")(
    "div[data-testid='SegmentHighTemp'] > span"
).text()
t_prediction = str(t_prediction_text).replace(" /", "/")
t_prediction = (
    f"  ({forecast_type}) {t_prediction}" if len(t_prediction) > 0 else t_prediction
)

# pretty print all data
# print(f"temp: {temp}\nstatus: {status}\nstatus_code: {status_code}\nicon: {icon}\
#     \ntemp_feel_text: {temp_feel_text}\ntemp_min_max: {temp_min_max}\nwind_text: {wind_text}\
#     \nhumidity_text: {humidity_text}\nvisbility_text: {visbility_text}\nair_quality_index: {air_quality_index}\
#     \nprediction: \n{r_prediction}\n{t_prediction}")

# tooltip text
tooltip_text = str.format(
    "\t\t{}\t\n{}\n{}\n{}\n{}\n{}\n{}\n{}",
    f'<span size="xx-large">{temp}</span>',
    f"<big>{icon}</big>",
    f"<big>{status}</big>",
    f"{temp_feel_text}",
    f"{temp_min_max}",
    f"{wind_text}\t{humidity_text}",
    f"{visbility_text}\tAQI {air_quality_index}",
    # f"<i>{r_prediction}</i>",
    f"<i>{t_prediction}</i>",
)

# print waybar module data
out_data = {
    "text": f"{icon}  {temp}",
    "alt": status,
    "tooltip": tooltip_text,
    "class": status_code,
}
print(json.dumps(out_data))
