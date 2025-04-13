export AWS_ACCOUNT_ID=014498633927
export AWS_REGION=ap-southeast-1
export VERSION=v16.0
docker build --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-web:${VERSION} .
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/cronos/cronos-web:${VERSION}