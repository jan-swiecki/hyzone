#!/bin/bash

apt-get update && apt-get install -y curl

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs