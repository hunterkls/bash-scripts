# Directory locations
mkdir /my-cron-files
mkdir /my-cron-files/update-logs
mkdir /my-cron-files/upgrade-logs
mkdir /my-cron-files/reboot-logs
mkdir /my-cron-files/certbot-logs
mkdir /my-cron-files/curl-logs
mkdir /my-cron-files/scripts

# crontab variables

#creates variable for the date and time
LOG_DATE=$\(date\ \'+%Y-%m-%d_%H:%M.%S\'\)

#cron job 1 used to run apt update
CRON_SCHEDULE_1="0 1 * * *"
CRON_SCRIPT_1="/my-cron-files/scripts/update-me.sh"
CRON_JOB_1="$CRON_SCHEDULE_1 $CRON_SCRIPT_1"

#cron job 2 used to run apt upgrade
CRON_SCHEDULE_2="0 2 * * *"
CRON_SCRIPT_2="/my-cron-files/scripts/upgrade-me.sh"
CRON_JOB_2="$CRON_SCHEDULE_2 $CRON_SCRIPT_2"

#cron job 3 used to reboot computer if needed
CRON_SCHEDULE_3="0 3 * * *"
CRON_SCRIPT_3="/my-cron-files/scripts/reboot-me.sh >> /my-cron-files/reboot-logs/reboot.log"
CRON_JOB_3="$CRON_SCHEDULE_3 $CRON_SCRIPT_3"

#clears existing crontab entries
crontab -r

#crontab script referencing cron job variables above
(crontab -l ; echo "$CRON_JOB_1") | crontab
(crontab -l ; echo "$CRON_JOB_2") | crontab
(crontab -l ; echo "$CRON_JOB_3") | crontab

#used to pull most up to date version of this script
(crontab -l ; echo "0 0 * * * /my-cron-files/scripts/autoupdate.sh") | crontab

# Define the content of the new script

curl   -o /my-cron-files/scripts/autoupdate.sh -L https://raw.githubusercontent.com/hunterkls/bash-scripts/refs/heads/main/autoupdate.sh

chmod +x /my-cron-files/scripts/autoupdate.sh


UPDATE_SCRIPT="
#!/bin/bash
apt update > /my-cron-files/update-logs/$LOG_DATE.log
"

UPGRADE_SCRIPT="
#!/bin/bash
apt upgrade -y > /my-cron-files/upgrade-logs/$LOG_DATE.log
"

REBOOT_SCRIPT="
#!/bin/bash
if [ -f /var/run/reboot-required ]; then
echo "$LOG_DATE", 'reboot required'
reboot
else
echo "$LOG_DATE", 'reboot not rquired'
fi
"


# Define the name of the new script
UPDATE_SCRIPT_NAME="update-me.sh"
UPGRADE_SCRIPT_NAME="upgrade-me.sh"
REBOOT_SCRIPT_NAME="reboot-me.sh"


# Create the new script file
echo "$UPDATE_SCRIPT" > /my-cron-files/scripts/"$UPDATE_SCRIPT_NAME"
echo "$UPGRADE_SCRIPT" > /my-cron-files/scripts/"$UPGRADE_SCRIPT_NAME"
echo "$REBOOT_SCRIPT" > /my-cron-files/scripts/"$REBOOT_SCRIPT_NAME"
echo "GIT_DOWNLOAD" > /my-cron-files/scripts/"$GIT_DOWNLOAD_NAME"

# Make the new script executable
chmod +x /my-cron-files/scripts/"$UPDATE_SCRIPT_NAME"
chmod +x /my-cron-files/scripts/"$UPGRADE_SCRIPT_NAME"
chmod +x /my-cron-files/scripts/"$REBOOT_SCRIPT_NAME"


echo "Scripts  '$UPDATE_SCRIPT_NAME', '$UPGRADE_SCRIPT_NAME', and '$REBOOT_SCRIPT_NAME' has been created and made executable."

