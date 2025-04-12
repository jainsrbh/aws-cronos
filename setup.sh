#!/usr/bin/env bash
HOME_DIR=$(pwd)
#AWS account id
export AWS_ACCOUNT_ID=014498633927
#Build Docker image
current_date=$(date +"%Y%m%d%H%M%S")
cd ${HOME_DIR}/docker-cronos
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest .
#Build Docker image
cd ${HOME_DIR}/docker-web
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-web:latest .
#Create ECR first
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/ecr
terragrunt apply --auto-approve
#LOGIN to ECR
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com
#PUSH IMAGE TO ECR
#Use fixed version for production
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-web:latest
#Setup network first
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/network
terragrunt apply --auto-approve
#Setup EC2 key-pair
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/key-pair
terragrunt apply --auto-approve
#Setup EC2 key-pair-jump
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/key-pair-jump
terragrunt apply --auto-approve
#Setup jump-server
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/ec2-jump-server
terragrunt run-all apply --terragrunt-non-interactive --auto-approve
#Setup cronos-node
cd ${HOME_DIR}/terraform/cronos/ap-southeast-1/dev/ec2-cronos-node
terragrunt run-all apply --terragrunt-non-interactive --auto-approve

