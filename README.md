# fail2ban-telegram-notification
Send notification to telegram when fail2ban ban an IP address and unban an IP address

## Requirements
- curl: `sudo apt install curl`
- jq: `sudo apt install jq`
- Telegram Bot API key
- Group id

## Installation

### Manual
- Add telegram action to DEFAULT section (or specific jail section) `/etc/fail2ban/jail.local`:

```
[DEFAULT]
action=telegram
```
 - Make `scripts` directory to place our shell script  
```
sudo mkdir /etc/fail2ban/scripts/
```  
 -  Copy `fail2ban-telegram.sh` to scripts directory and `sudo chmod +x fail2ban-telegram.sh` it
 - Copy `telegram.conf` to `/etc/fail2ban/action.d/` directory  
 - Configure `fail2ban-telegram.sh`
- Restart the service  
```
sudo service fail2ban restart
```
 ## Configuration
 - Edit `fail2ban-telegram.sh` and replace the `apiToken` and `chatId` with your api token and chat id (must start with *-*). 
```
sudo nano /etc/fail2ban/scripts/fail2ban-telegram.sh
```
```
apiToken="input apiToken"
chatId="input chat id"
```
