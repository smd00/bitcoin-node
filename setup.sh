#!/bin/bash

# =============================================
# Usage:
# sudo chmod +x ./setup.sh
# sudo ./setup.sh rcpUser rpcPassword your.redis.host

# =============================================
# Install bitcoind
sudo apt-add-repository ppa:bitcoin/bitcoin -y
sudo apt update && sudo apt install bitcoind -y
sudo apt install redis-tools -y

# =============================================
# Setup additional volume
sudo mkfs.ext4 /dev/xvdb #Format the volume to ext4 filesystem
sudo mkdir /btcdata #Create a directory to mount the new volume
sudo mount /dev/xvdb /btcdata/ #Mount the volume to btcdata directory
df -h /btcdata #Check the disk space to confirm the volume mount

#EBS Automount on Reboot
sudo cp /etc/fstab /etc/fstab.bak
echo "/dev/xvdb  /btcdata/  ext4    defaults,nofail  0   0" | sudo tee -a /etc/fstab #Make a new entry in /etc/fstab
sudo mount -a #Check if the fstab file has any errors

lsblk #List the available disks
sudo file -s /dev/xvdb #Check if the volume has any data

# =============================================
RPCUSER=$1
RPCPASS=$2
REDISHOST=$3

# Copy config files
sudo rm -rf $HOME/build && sudo mkdir -p $HOME/build
sed -e "s;%RPCUSER%;$RPCUSER;g" -e "s;%RPCPASS%;$RPCPASS;g" bitcoin.conf.tmpl > $HOME/build/bitcoin.conf
cp notify.sh.tmpl $HOME/build/notify.sh

# =============================================
cat $HOME/build/bitcoin.conf | sudo tee /btcdata/bitcoin.conf
cat $HOME/build/notify.sh | sudo tee /btcdata/notify.sh

sudo mkdir $HOME/.bitcoin
cat $HOME/build/bitcoin.conf | sudo tee $HOME/.bitcoin/bitcoin.conf 
cat $HOME/build/notify.sh | sudo tee $HOME/.bitcoin/notify.sh
ls -la $HOME/.bitcoin

sudo chmod +x /btcdata/notify.sh
sudo touch /btcdata/notify.log

# =============================================
sudo cp /etc/environment /etc/environment.bak
echo "REDIS_HOST=$REDISHOST" | sudo tee -a /etc/environment #Make a new entry in /etc/environment
sudo cp /etc/crontab /etc/crontab.bak
echo "@reboot root bitcoind -daemon -datadir=/btcdata/" | sudo tee -a /etc/crontab #Make a new entry in /etc/crontab

# =============================================
echo "# START -----------------------------------------------------------------"
echo "# SMD00    sudo bitcoind -daemon -datadir=/btcdata/"
echo "# END   -----------------------------------------------------------------"
sudo bitcoind -daemon -datadir=/btcdata/ 

# =============================================
# sudo pkill -9 -f bitcoind

ps -e | grep bitcoin
sudo tail /btcdata/debug.log
bitcoin-cli getblockcount