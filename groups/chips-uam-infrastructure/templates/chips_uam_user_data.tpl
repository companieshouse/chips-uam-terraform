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
pushd /home/ec2-user/
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/uam_gui-1.109.0-rc1.zip /home/ec2-user/
unzip /home/ec2-user/uam_gui-1.109.0-rc1.zip
rm -rf /home/ec2-user/uam_gui-1.109.0-rc1.zip
mv /home/ec2-user/uam_gui-1.109.0-rc1 /home/ec2-user/uam

#Webswing
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing-2.5.5-distribution.zip /home/ec2-user/
unzip /home/ec2-user/webswing-2.5.5-distribution.zip
rm -rf /home/ec2-user/webswing-2.5.5-distribution.zip

#Retrieve master.txt from parameter store
aws ssm get-parameter --with-decryption --region ${REGION} --output text --query 'Parameter.Value' --name '${MASTER_DATA_PATH}' > /home/ec2-user/uam/master.txt

chmod 700 /home/ec2-user/uam/master.txt

#Encrypt master.txt
pushd /home/ec2-user/uam/
/home/ec2-user/uam/encryptUamDbConfigFile.sh master.txt
rm -rf /home/ec2-user/uam/master.txt

#Create a systemd script that will control the startup of webswing including automated restarts for reboots
aws s3 cp s3://shared-services.eu-west-2.resources.ch.gov.uk/chips/uam/webswing.service /etc/systemd/system/
systemctl enable webswing.service
systemctl start webswing.service

#Cron job to restart webswing service every Monday at 22:00
echo '#### CHIPS UAM restart job ####' > /root/cronfile
echo '00 22 * * 1 systemctl restart webswing' >> /root/cronfile
crontab -u root /root/cronfile