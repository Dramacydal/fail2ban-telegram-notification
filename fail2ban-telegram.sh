#!/bin/bash

# Sends text messages using Telegram
# to alert webmaster of banning.

# Require one argument, one of the following
# start
# stop
# ban
# unban
# Ban and unban actions have optional parameters: --jain=name --ip=addr

function markdown_escape() {
  echo $@ | sed 's/\([\-_*`]\)/\\\1/g'
}

function hashtag_escape() {
  echo $@ | sed 's/[.\-]/_/g'
}

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

  msg="$msg\n#$(markdown_escape $(hashtag_escape $servername))"

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
bantime=""

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
    --bantime=*)
      bantime="${arg#*=}"
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

function getFlag {
  local country_code="$1"
  local flag=""

  if [[ ! "$country_code" =~ ^[A-Z]{2}$ ]]; then
    echo ""
    return 1
  fi

  echo $(printf '\\U%X\\U%X' $(($(printf '%d' "'${1:0:1}") + 127397)) $(($(printf '%d' "'${1:1}") + 127397)))
}

if [ "$jail" != "" ]; then jail="\n🚨 ${jail}"; fi
if [ "$bantime" != "" ]; then bantime=" for ${bantime}"; fi

geoip_url="https://get.geojs.io/v1/ip/country/$ip.json"
response=$(curl -s "$geoip_url")
country=$(echo $response | jq -r .name)
country_code=$(echo $response | jq -r .country)

if [ "$country" != "null" ]; then
  if [ "$country_code" != "" ]; then
    country="\n$(getFlag "$country_code") $(markdown_escape $country)"
  else
    country="\n🌎 $(markdown_escape $country)"
  fi
else
  country=""
fi

# Take action depending on argument
if [ "$action" = 'start' ]; then
  send_msg "🖥️ $(markdown_escape $servername)\nService started"
elif [ "$action" = 'stop' ]; then
  send_msg "🖥️ $(markdown_escape $servername)\nService stopped"
elif [ "$action" = 'ban' ]; then
  if [ "$ip" != '' ]; then
    send_msg "🖥️ $(markdown_escape $servername)\n🏴‍☠️ Banned \`$ip\`$bantime $country $jail"
  else
    send_msg "🖥️ $(markdown_escape $servername)\n🏴‍☠️ Banned an ip $jail"
  fi
elif [ "$action" = 'unban' ]; then
  if [ "$ip" != '' ]; then
    send_msg "🖥️ $(markdown_escape $servername)\n🏳️ Unbanned \`$ip\` $country $jail"
  else
    send_msg "🖥️ $(markdown_escape $servername)\n🏳️ Unbanned an ip $jail"
  fi
else
  show_usage
fi
