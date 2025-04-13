#!/bin/sh
sudo yum update
sudo yum install -y docker
sudo systemctl start docker
sudo aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
sudo docker pull ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-node:${image_tag}

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
  sudo chown 1000:1000 "$MOUNT_POINT"
else
  echo "Volume already mounted at $MOUNT_POINT"
fi


sudo docker run -d \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  -v "$MOUNT_POINT:/home/cronos/.chain-maind/data" \
--name cronos-node ${aws_account_id}.dkr.ecr.${region}.amazonaws.com/cronos/cronos-node:${image_tag}


#sudo docker run -d \
#  -p 8545:8545 \
#  -p 8546:8546 \
#  -p 30303:30303 \
#  -p 30303:30303/udp \
#  -v /data:/home/cronos/.chain-maind/data \
#--name cronos-node 014498633927.dkr.ecr.ap-southeast-1.amazonaws.com/cronos/cronos-node:v1.0