#!/bin/bash

# mount attached EBS drive
sudo mkdir -p /home/llama
(
  sleep 30  # wait for attaching process to finish
  #  there seems to be no guarantee that the EBS volume is any ot these
  if [[ -b /dev/xvdf1 ]]; then
    sudo mount /dev/xvdf1 /home/llama
  elif [[ -b /dev/nvme2n1p1 ]]; then
    sudo mount /dev/nvme2n1p1 /home/llama
  elif [[ -b /dev/nvme1n1p1 ]]; then
    sudo mount /dev/nvme1n1p1 /home/llama
  fi
) &

# install fish shell
sudo apt update
sudo apt -y install fish
sudo chsh -s /usr/bin/fish "$USER"

# update system software and install pytorch and dependencies
sudo apt -y upgrade
sudo apt -y install python-is-python3 python3-pip awscli ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED
sudo pip install torch torchvision torchaudio
