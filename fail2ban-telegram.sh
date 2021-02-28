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
  msg=$1
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
country=$(curl -s "$geoip_url")
if [ "$country" = "nil" ]; then country=""; else country="%0A🌎 Country: $country"; fi

# Take action depending on argument
if [ "$1" = 'start' ]
then
  msg="🏳️ Fail2ban ON %0A🖥️ $servername"
  send_msg "$msg"
elif [ "$1" = 'stop' ]
then
  msg="🏳️ Fail2ban OFF %0A🖥️ $servername"  
  send_msg "$msg"
elif [ "$1" = 'ban' ]
then
  full="🏳️ Fail2ban %0A🖥️ $servername %0A🏴‍☠️ Banned IP: $2 $country"
  half="🏳️ Fail2ban %0A🖥️ $servername banned an ip."
  msg=$([ "$2" != '' ] && echo -e "$full" || echo -e "$half" )
  send_msg "$msg"
elif [ "$1" = 'unban' ]
then
  full="🏳️ Fail2ban %0A🖥️ $servername unban %0AIP: <code>$2</code> $country"
  half="🏳️ Fail2ban %0A🖥️ $servername unban an ip."
  msg=$([ "$2" != '' ] && echo -e "$full" || echo -e "$half" )
  send_msg "$msg"
else
  show_usage
fi
