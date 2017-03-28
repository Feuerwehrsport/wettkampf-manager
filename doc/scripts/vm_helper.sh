#!/bin/bash

export PATH="$PATH:$HOME/.rvm/bin"
source /home/user/.rvm/scripts/rvm
cd /home/user/wettkampf-manager
./scripts/$1.sh

read -p "Press any key"