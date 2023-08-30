#!/bin/bash

sudo mkdir -p /home/llama
sleep 30  # wait for attaching process to finish
sudo mount /dev/xvdf1 /home/llama
df / /home/llama
sudo apt update
sudo apt -y upgrade
sudo apt -y install fish python-is-python3 python3-pip awscli ubuntu-drivers-common