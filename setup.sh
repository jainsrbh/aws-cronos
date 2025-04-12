#!/usr/bin/env bash
HOME_DIR=$(pwd)
#AWS account id
AWS_ACCOUNT_ID=014498633927
#Build Docker image
current_date=$(date +"%Y%m%d%H%M%S")
cd ${HOME_DIR}/docker
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest .
#Create ECR first
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/ecr
terragrunt apply --auto-approve
#LOGIN to ECR
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com
#PUSH IMAGE TO ECR
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest
#Setup network first
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/network
terragrunt apply --auto-approve
#Setup EC2 key-pair
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/key-pair
terragrunt apply --auto-approve
