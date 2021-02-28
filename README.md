# fail2ban-telegram-notification
Send notification to telegram when fail2ban ban an IP address and unband an IP address

## Requirements
`sudo apt install fail2ban openssh-server curl`
- fail2ban
- openssh
- curl
- Telegram Bot

## Installation



### Manual
- Create a copy of jail.conf 

```
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
 
 - Add `action = telegram` to sshd
```
[sshd]  
...
action  =  telegram 
```
   
 - Make `script` directory to place our shell script  
```
sudo mkdir /etc/fail2ban/scripts/
```  
 -  Copy `fail2ban-telegram.sh` to script directory

```
cd /etc/fail2ban/scripts
wget https://raw.githubusercontent.com/jaimey/fail2ban-telegram-notification/master/fail2ban-telegram.sh
sudo chmoxd +x fail2ban-telegram.sh
```
 - Copy `telegram.conf` to `/etc/fail2ban/action.d/` directory  
```
cd /etc/fail2ban/action.d/
wget https://raw.githubusercontent.com/jaimey/fail2ban-telegram-notification/master/telegram.conf
```

- Restart the service  
```
sudo service fail2ban restart
```
 ### Configuration
 - Edit `fail2ban-telegram.sh` and replace the `apiToken` and `chatId` with your api. 
```
sudo nano /etc/fail2ban/scripts/fail2ban-telegram.sh
```
```
apiToken="input apiToken"
chatId="input chat id"
```
