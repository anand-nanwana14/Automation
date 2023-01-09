#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
name="Anand"
bucket="upgrad-anand"

#Inserting logs into inventory.html

size=`du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}'`

echo -e "httpd-logs\t-\t${timestamp}\t-\ttar\t-\t${size}" >> /var/www/html/inventory.html

echo "Log File is Inserted"



# Create a cron job that runs service every minutes/day
if [[ ! -f /etc/cron.d/automation ]]; then

	echo "* * * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
else 
	echo "Cron job is already created"
fi