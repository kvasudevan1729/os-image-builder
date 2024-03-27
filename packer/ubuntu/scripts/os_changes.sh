#!/bin/bash

# setup CW Agent
sudo mkdir /opt/awslogs
cd /tmp
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo python awslogs-agent-setup.py --region eu-west-2 -n -c ~root/.aws/awslogs.conf -p /usr/bin/python3
