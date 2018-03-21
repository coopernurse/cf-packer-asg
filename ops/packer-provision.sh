#!/bin/bash

set -e
set -x

# install updates
sudo yum update -y

# install docker
sudo yum install aws-cfn-bootstrap docker -y
sudo systemctl enable docker
sudo systemctl start docker

# pull image
image_name="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest"
aws --debug ecr get-login --no-include-email --region $AWS_REGION > /tmp/install_docker.sh
echo "docker pull $image_name" >> /tmp/install_docker.sh
sudo bash /tmp/install_docker.sh
rm -f /tmp/install_docker.sh

# create systemd unit file
sudo touch /etc/webapp.env
cat << EOF > /tmp/webapp.service
[Unit]
Description=WebApp
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull redis
ExecStart=/usr/bin/docker run -p 80:5000 --env-file /etc/webapp.env --name %n $image_name
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
EOF

# enable systemd service
sudo mv /tmp/webapp.service /etc/systemd/system
sudo systemctl enable webapp
