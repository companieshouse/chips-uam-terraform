#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Update Nagios registration script with relevant template
#sed 's/linux-server/CHIPS_UAM_${HERITAGE_ENVIRONMENT}' /usr/local/bin/nagios-host-add.sh
#sed 's/API_KEY="";/API_KEY="${API_KEY}";' /usr/local/bin/nagios-host-add.sh

#Install Java OpenJDK version 8
yum -y install java-1.8.0-openjdk

#Install Xvfb
yum -y install Xvfb

#UAM GUI
pushd /home/ec2-user/
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/uam_gui-1.109.0-rc1.zip /home/ec2-user/
unzip /home/ec2-user/uam_gui-1.109.0-rc1.zip
rm -rf /home/ec2-user/uam_gui-1.109.0-rc1.zip
mv /home/ec2-user/uam_gui-1.109.0-rc1 /home/ec2-user/uam

#Webswing
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing-2.5.5-distribution.zip /home/ec2-user/
unzip /home/ec2-user/webswing-2.5.5-distribution.zip
rm -rf /home/ec2-user/webswing-2.5.5-distribution.zip

#Copy master.txt from vault to /home/ec2-user/uam
#Create key:value variable
cat <<EOF >> /home/ec2-user/uam/master.txt
${CHIPS_UAM_INPUTS}
EOF

chmod 700 /home/ec2-user/uam/master.txt

#Encrypt master.txt
pushd /home/ec2-user/uam/
/home/ec2-user/uam/encryptUamDbConfigFile.sh master.txt
rm -rf /home/ec2-user/uam/master.txt

#Create a systemd script that will control the startup of webswing including automated restarts for reboots
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing.service /etc/systemd/system/
systemctl enable webswing.service
systemctl start webswing.service