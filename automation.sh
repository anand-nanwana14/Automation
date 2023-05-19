#!/bin/bash

sudo apt update -y


#Variables for my name and for my s3 bucket
timestamp=$(date '+%d%m%Y-%H%M%S')
name="Anand"
bucket="minor-project-AITR"



#Checking apache2 installed in our machine or not 
present=`dpkg --get-selections apache2 | awk '{print $2}'`
if [ install != $present ];
then
	sudo apt install apache2 -y
else 
	echo "Already installed apache2"
fi



#Ensuring the status of apache2 service is it running or not
status=`systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()'`
if [ running != $status ];
then
	sudo systemctl start apache2
else 
	echo "Apache2 is already running"
fi



#Ensuring apache2 is enabled or not 
apache2=`systemctl is-enabled apache2`
if [ enabled != $apache2 ];
then
	sudo systemctl enable apache2 
else 
	echo "Apache2 is already Enabled"
fi



#Archiving Access logs and Error logs via tar 

cd /var/log/apache2
tar -cvf /tmp/${name}-httpd-logs-${timestamp}.tar *.log



#Copying logs to our s3 bucket

aws s3 \
	cp /tmp/${name}-httpd-logs-${timestamp}.tar \
	s3://${bucket}/${name}-httpd-logs-${timestamp}.tar



# Checking inventory.html file is present or not 

if [ ! -f /var/www/html/inventory.html ];then

	echo -e "log Type\t-\tTime Created\t-\tType\t-\tSize" > /var/www/html/inventory.html
else 
	echo "inventory.html is present"
fi



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
