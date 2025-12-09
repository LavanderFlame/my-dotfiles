#!/bin/bash

# Orlando coordinates
LAT=28.5383
LON=-81.3792

# Fetch weather
DATA=$(curl -s \
  "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current_weather=true&timezone=auto")

TEMP=$(echo "$DATA" | jq -r '.current_weather.temperature')
WIND=$(echo "$DATA" | jq -r '.current_weather.windspeed')

# Fallback if null
if [ -z "$TEMP" ] || [ "$TEMP" = "null" ]; then
    TEMP="?"
fi

TEXT="${TEMP}°C"
TOOLTIP="Temperature: ${TEMP}°C\nWind: ${WIND} km/h"

TOOLTIP_ESCAPED=$(echo "$TOOLTIP" | sed ':a;N;$!ba;s/\n/\\n/g')

echo "{\"text\": \"$TEXT\", \"tooltip\": \"<tt>$TOOLTIP_ESCAPED</tt>\"}"
