#!/bin/bash
#SSM Run Command via GitHub Repo script test to create a test file and write to it
touch /root/ssm-test-file.txt
echo 'This is a test of SSM Run Command via GitHub Repo on:' > /root/ssm-test-file.txt
date >> /root/ssm-test-file.txt