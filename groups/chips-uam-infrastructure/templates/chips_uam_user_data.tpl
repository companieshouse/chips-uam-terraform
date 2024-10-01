#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Run Ansible playbook for server setup using provided inputs
echo '${ANSIBLE_INPUTS}' > /root/ansible_inputs.json
/usr/local/bin/ansible-playbook /root/deployment.yml -e '@/root/ansible_inputs.json'

#Install Java OpenJDK version 8
yum -y install java-1.8.0-openjdk

#Install Xvfb
yum -y install Xvfb

#UAM GUI
mkdir /home/ec2-user/uam
pushd /home/ec2-user/uam
aws s3 cp s3://shared-services.eu-west-2.releases.ch.gov.uk/chips-user-admin-client/uam_gui-${UAM_GUI_VERSION}.zip .
unzip uam_gui-${UAM_GUI_VERSION}.zip
rm -rf uam_gui-${UAM_GUI_VERSION}.zip

#Retrieve master.txt from parameter store and encrypt
aws ssm get-parameter --with-decryption --region ${REGION} --output text --query 'Parameter.Value' --name '${MASTER_DATA_PATH}' > master.txt
./encryptUamDbConfigFile.sh master.txt
rm -rf master.txt

#Webswing
pushd /home/ec2-user
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing-2.5.5-distribution.zip .
unzip webswing-2.5.5-distribution.zip
rm -rf webswing-2.5.5-distribution.zip

#Create a systemd script that will control the startup of webswing including automated restarts for reboots
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing.service /etc/systemd/system/
systemctl enable webswing.service
systemctl start webswing.service

#Cron job to restart webswing service every Monday at 22:00
echo '#### CHIPS UAM restart job ####' > /root/cronfile
echo '00 22 * * 1 systemctl restart webswing' >> /root/cronfile
crontab -u root /root/cronfile