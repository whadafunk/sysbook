#/bin/bash

# Installs google-drive-ocamlfuse on Debian (Stretch & Buster)
#
# Run this oneliner to make it happen
#   bash <(curl -sSL https://gist.github.com/hannesbe/6c110e9de6644f07a48eecfdbe6b728d/raw)

sudo apt install -y software-properties-common dirmngr
sudo cat > /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-bionic.list << EOF
deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main
deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main
EOF
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AD5F235DF639B041
sudo apt-get update
sudo apt-get install -y google-drive-ocamlfuse
