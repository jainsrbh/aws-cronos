#!/bin/sh
sudo yum update
sudo yum install -y docker
sudo systemctl start docker
sudo aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
sudo docker pull ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-web:${image_tag}
sudo docker run -d --name cronos-web ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-web:${image_tag}