#!/bin/sh
# weather information for location based on seen WiFi BSSIDs or IP as fallback

# get close WiFi BSSIDs
# BSSIDS="$(nmcli device wifi list |
#     awk 'NR>1 {if ($1 != "*") {print $1}}' |
#     tr -d ":" |
#     tr "\n" ",")"

# # get geographical location
# LOC=""
# REQUEST_GEO="$(wget -qO - http://openwifi.su/api/v1/bssids/"$BSSIDS")"
# if  [ "$(jq ".count_results" <<< "$REQUEST_GEO")" -gt 0 ]; then
#     LAT="$(jq ".lat" <<< "$REQUEST_GEO")"
#     LON="$(jq ".lon" <<< "$REQUEST_GEO")"
#     LOC="$LAT,$LON"
# fi

# # get weather information
# text="$(curl -s "https://wttr.in/$LOC?format=1")"
# https://wttr.in/$LOC?0QT

text="$(curl -s "wttr.in/Huadu\?format=1")"
# tooltip="$(curl -s "wttr.in/Huadu?0\&lang=zh" |
#     sed 's/\\/\\\\/g' |
#     sed ':a;N;$!ba;s/\n/\\n/g' |
#     sed 's/"/\\"/g')"

# output for Waybar
# \"tooltip\": \"<tt>$tooltip</tt>\",
if ! grep -q "Unknown location" <<< "$text"; then
    echo "{\"text\": \"$text\", \"class\": \"weather\"}"
fi
