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

  curl -s -X POST "$url" -dchat_id="$chatId" -dtext="$(echo -e $msg)" -dparse_mode="MarkDown"
  exit
}

# Check for script arguments
if [ $# -lt 1 ]
then
  show_usage
fi

geoip_url="https://get.geojs.io/v1/ip/country/full/$2"
country=$(curl -s "$geoip_url")
if [ "$country" = "nil" ]; then country=""; else country="\n🌎 $country"; fi

# Take action depending on argument
if [ "$1" = 'start' ]; then
  send_msg "🖥️ $servername\nService started"
elif [ "$1" = 'stop' ]; then
  send_msg "🖥️ $servername\nService stopped"
elif [ "$1" = 'ban' ]; then
  if [ "$2" != '' ]; then
    send_msg "🖥️ $servername\n 🏴‍☠️ Banned: \`$2\` $country"
  else
    send_msg "🖥️ $servername\n 🏴‍☠️ Banned an ip"
  fi
elif [ "$1" = 'unban' ]; then
  if [ "$2" != '' ]; then
    send_msg "🖥️ $servername\n🏳️ Unbanned: \`$2\` $country"
  else
    send_msg "🖥️ $servername\n🏳️ Unbanned an ip"
  fi
else
  show_usage
fi
