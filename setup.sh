#!/usr/bin/env bash
HOME_DIR=$(pwd)
#AWS account id
export AWS_ACCOUNT_ID=014498633927
export AWS_REGION=ap-southeast-1
export VERSION=${1}
#Build Docker image
current_date=$(date +"%Y%m%d%H%M%S")
cd ${HOME_DIR}/docker-cronos
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-node:${VERSION} .
#Build Docker image
cd ${HOME_DIR}/docker-web
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-web:${VERSION} .
#Create ECR first
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/ecr
terragrunt apply --auto-approve
#LOGIN to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
#PUSH IMAGE TO ECR
#Use fixed version for production
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-node:${VERSION}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-web:${VERSION}
#Setup network first
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/network
terragrunt apply --auto-approve
#Setup EC2 key-pair
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/key-pair
terragrunt apply --auto-approve
#Setup EC2 key-pair-jump
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/key-pair-jump
terragrunt apply --auto-approve
#Setup jump-server
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/ec2-jump-server
terragrunt run-all apply --terragrunt-non-interactive --auto-approve
#Setup cronos-node
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/ec2-cronos-node
terragrunt run-all apply --terragrunt-non-interactive --auto-approve
#Setup cronos-web
cd ${HOME_DIR}/terraform/cronos/${AWS_REGION}/dev/ec2-cronos-web
terragrunt run-all apply --terragrunt-non-interactive --auto-approve

