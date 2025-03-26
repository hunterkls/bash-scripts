#!/bin/bash
mkdir /my-cron-files
mkdir /my-cron-files/update-logs
mkdir /my-cron-files/upgrade-logs
mkdir /my-cron-files/reboot-logs
mkdir /my-cron-files/scripts


LOG_DATE=$\(date\ \'+%Y-%m-%d_%H:%M.%S\'\)
CRON_SCHEDULE_1="0 1 * * *"
CRON_SCRIPT_1="/my-cron-files/scripts/update-me.sh"
CRON_JOB_1="$CRON_SCHEDULE_1 $CRON_SCRIPT_1"
CRON_SCHEDULE_2="0 2 * * *"
CRON_SCRIPT_2="/my-cron-files/scripts/upgrade-me.sh"
CRON_JOB_2="$CRON_SCHEDULE_2 $CRON_SCRIPT_2"
CRON_SCHEDULE_3="0 3 * * *"
CRON_SCRIPT_3="/my-cron-files/scripts/reboot-me.sh >> /my-cron-files/reboot-logs/reboot.log"
CRON_JOB_3="$CRON_SCHEDULE_3 $CRON_SCRIPT_3"

(crontab -l ; echo "$CRON_JOB_1") | crontab
(crontab -l ; echo "$CRON_JOB_2") | crontab
(crontab -l ; echo "$CRON_JOB_3") | crontab


# Script to create another executable script

# Define the content of the new script
UPDATE_SCRIPT="
#!/bin/bash
apt update > /my-cron-files/update-logs/'$LOG_DATE'.log
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

# Make the new script executable
chmod +x /my-cron-files/scripts/"$UPDATE_SCRIPT_NAME"
chmod +x /my-cron-files/scripts/"$UPGRADE_SCRIPT_NAME"
chmod +x /my-cron-files/scripts/"$REBOOT_SCRIPT_NAME"

echo "Scripts '$UPDATE_SCRIPT_NAME', '$UPGRADE_SCRIPT_NAME', and '$REBOOT_SCRIPT_NAME' has been created and made executable."

