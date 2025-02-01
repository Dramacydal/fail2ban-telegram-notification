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
  echo "Usage: $0 <action> [--param1=value1] [--param2=value2]"
  echo "Where action is: start, stop, ban, unban"
  echo "Ban and unban actions have optional parameters: --jain=name --ip=addr"
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

action=""
ip=""
jail=""

if [[ $# -gt 0 ]]; then
  action="$1"
  shift
else
  echo "Error: Action must be specified."
  usage
fi

for arg in "$@"; do
  case "$arg" in
    --ip=*)
      ip="${arg#*=}"
      ;;
    --jail=*)
      jail="${arg#*=}"
      ;;
    --help)
      usage
      ;;
    *)
      echo "Unknown parameter: $arg"
      show_usage
      exit 1
      ;;
  esac
done

if [ "$jail" != "" ]; then jail="\n🚨 ${jail}"; fi

geoip_url="https://get.geojs.io/v1/ip/country/full/$ip"
country=$(curl -s "$geoip_url")
if [ "$country" = "nil" ]; then country=""; else country="\n🌎 $country"; fi

# Take action depending on argument
if [ "$action" = 'start' ]; then
  send_msg "🖥️ $servername\nService started"
elif [ "$action" = 'stop' ]; then
  send_msg "🖥️ $servername\nService stopped"
elif [ "$action" = 'ban' ]; then
  if [ "$ip" != '' ]; then
    send_msg "🖥️ $servername\n 🏴‍☠️ Banned: \`$ip\` $country $jail"
  else
    send_msg "🖥️ $servername\n 🏴‍☠️ Banned an ip $jail"
  fi
elif [ "$action" = 'unban' ]; then
  if [ "$ip" != '' ]; then
    send_msg "🖥️ $servername\n🏳️ Unbanned: \`$ip\` $country $jail"
  else
    send_msg "🖥️ $servername\n🏳️ Unbanned an ip $jail"
  fi
else
  show_usage
fi
