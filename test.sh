#!/bin/bash

sudo -v
while true; do
    sudo -n true
    sleep 1
    kill -0 "$$" || exit
done 2>/dev/null &

sleep 1
echo "normal hello from $(whoami)"

sleep 1
sudo echo "sudo hello from $(whoami)"

sleep 1
