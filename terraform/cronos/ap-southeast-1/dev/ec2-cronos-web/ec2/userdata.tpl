#!/bin/sh
sudo yum update
sudo yum install -y docker
sudo systemctl start docker
#download image
sudo aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
sudo docker pull ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-web:${image_tag}
#mount volume is not mounted

# Variables
VOLUME="/dev/nvme1n1"
MOUNT_POINT="/data"

# Check if volume is already mounted
if ! mountpoint -q "$MOUNT_POINT"; then
  echo "Volume not mounted. Setting up..."
  if ! blkid "$VOLUME"; then
    sudo mkfs -t ext4 "$VOLUME"
  fi
  sudo mkdir -p "$MOUNT_POINT"
  sudo mount "$VOLUME" "$MOUNT_POINT"
  echo "$VOLUME $MOUNT_POINT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
  # Set permissions for the mount point
  sudo chown 101:101 "$MOUNT_POINT"
else
  echo "Volume already mounted at $MOUNT_POINT"
fi

sudo docker run -d --name cronos-web \
-p 8080:8080 \
-p 8000:8000 \
-p 8001:8001 \
-v "$MOUNT_POINT:/var/log/nginx" \
${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-web:${image_tag}

#sudo docker run -d --name cronos-web \
#-p 8080:8080 \
#-p 8000:8000 \
#-p 8001:8001 \
#-v "/data:/var/log/nginx" \
#014498633927.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-web:v6.0
