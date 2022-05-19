#!/bin/bash
sudo yum update -y
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

curl -fsSL https://tailscale.com/install.sh | sh

tailscale up --advertise-routes=10.0.1.0/24,10.0.101.0/24 \
  --authkey "${tailscale_authkey}"
