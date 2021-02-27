#!/bin/bash

# Sends text messages using Telegram
# to alert webmaster of banning.

# Require one argument, one of the following
# start
# stop
# ban
# unban
# Optional second argument: Ip for ban/unband

servername=$(hostname)
apiToken="input apiToken"
chatId="input chat id"

# Display usage information
function show_usage {
  echo "Usage: $0 action <ip>"
  echo "Where action start, stop, ban, unban"
  echo "and IP is optional passed to ban, unban"
  exit
}


# Send notification
function send_msg {
  msg=$@
  url="https://api.telegram.org/bot$apiToken/sendMessage"

  curl -s -X POST "$url" -d chat_id="$chatId" -d text="$msg" -d parse_mode="html"
  exit
}


# Check for script arguments
if [ $# -lt 1 ]
then
  show_usage
fi

geoip_url="https://get.geojs.io/v1/ip/country/full/$2"
# Take action depending on argument
if [ "$1" = 'start' ]
then
  msg="$servername sheild on"
  send_msg "$msg"
elif [ "$1" = 'stop' ]
then
  msg="$servername server shield turning off"
  send_msg "$msg"
elif [ "$1" = 'ban' ]
then
  #url="https://get.geojs.io/v1/ip/country/full/$2"
  country=$(curl -s "$geoip_url")
  full="$servername server shield banned %0AIP: <code>$2</code> %0ACountry: <code>$country</code>"
  half="$servername server shield banned an ip."
  msg=$([ "$2" != '' ] && echo -e "$full" || echo -e "$half" )
  send_msg "$msg"
elif [ "$1" = 'unban' ]
then
  country=$(curl -s "$geoip_url")
  full="$servername server shield unban %0AIP: <code>$2</code> %0ACountry: <code>$country</code>"
  half="$servername server shield unban an ip."
  msg=$([ "$2" != '' ] && echo -e "$full" || echo -e "$half" )
  send_msg "$msg"
else
  show_usage
fi
