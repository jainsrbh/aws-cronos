#!/bin/sh
sudo yum update
sudo yum install -y docker
sudo systemctl start docker
sudo aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 014498633927.dkr.ecr.ap-southeast-1.amazonaws.com
sudo docker pull 014498633927.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest
sudo docker run -d --name cronos-node 014498633927.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest