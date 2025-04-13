export AWS_ACCOUNT_ID=014498633927
export AWS_REGION=ap-southeast-1
export VERSION=v4.0
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-node:${VERSION} .
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-node:${VERSION}