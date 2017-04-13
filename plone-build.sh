#!/bin/bash
set -e

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
#COL_RED=$ESC_SEQ"31;01m"
#COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
#COL_BLUE=$ESC_SEQ"34;01m"
#COL_MAGENTA=$ESC_SEQ"35;01m"
#COL_CYAN=$ESC_SEQ"36;01m"

buildDeps="
  wget
  git
  curl
  virtualenv
  python-setuptools
  python-dev
  build-essential
  libssl-dev
  libxml2-dev
  libxslt1-dev
  libbz2-dev
  libjpeg62-turbo-dev
"
runDeps="
  libjpeg62
  libxml2
  libxslt1.1
"

# Installing Build Dependencies
echo -en "$COL_YELLOW Installing Build Dependencies$COL_RESET\n"
apt update
apt install -y --no-install-recommends $buildDeps

# Installing GOSU
echo -en "$COL_YELLOW Installing GOSU$COL_RESET\n"
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
gpg --verify /usr/local/bin/gosu.asc
rm /usr/local/bin/gosu.asc
chmod +x /usr/local/bin/gosu
gosu nobody true

# Fetching Buildout and building Plone
echo -en "Fetching Buildout Configuration And Start Building$COL_RESET\n"
virtualenv -p python2.7 .
bin/pip2.7 install -r https://raw.githubusercontent.com/plone/buildout.coredev/5.1/requirements.txt
wget https://raw.githubusercontent.com/svx/plone5.mini/docker/buildout.cfg
bin/buildout
rm buildout.cfg

# Setting Permissions
echo -en "$COL_YELLOW Setting Permissions$COL_RESET\n"
chown -R plone:plone .

# Removing Build Dependencies
echo -en "$COL_YELLOW Removing $buildDeps$COL_RESET\n"
apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto)

# Installing Runtime Dependencies
echo -en "$COL_YELLOW Installing $runDeps$COL_RESET\n"
apt install -y --no-install-recommends $runDeps

# Cleaning Cache
echo -en "$COL_YELLOW Cleaning Cache$COL_RESET\n"
find /usr/local/plone \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' +
apt-get clean
rm -vrf /root/.cache/
rm -vrf /var/lib/apt/lists/*
rm -vrf /tmp/*

