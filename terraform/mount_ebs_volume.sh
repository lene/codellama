#!/bin/bash

# mount attached EBS drive
sudo mkdir -p /home/llama
(sleep 30; sudo mount /dev/xvdf1 /home/llama) &  # wait for attaching process to finish

# install fish shell
sudo apt update
sudo apt -y install fish
sudo chsh -s /usr/bin/fish "$USER"

# update system software and install pytorch and dependencies
sudo apt -y upgrade
sudo apt -y install python-is-python3 python3-pip awscli ubuntu-drivers-common
sudo pip install torch torchvision torchaudio
