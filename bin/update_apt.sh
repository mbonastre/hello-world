#!/bin/sh

LOG_FILE=/var/log/update_apt.log

exec >> ${LOG_FILE} 2>&1 < /dev/null

HLine="##################################################################################################"

echo ${HLine}
echo
date "+          START PACKAGE UPDATE PROCESS          %Y-%m-%dT%H:%M:%S"
echo
echo ${HLine}

export DEBIAN_FRONTEND=noninteractive

echo "apt-get update ..." &&
  apt-get -qy update &&
echo "apt-get upgrade ..." &&
  apt-get -y upgrade &&
echo "apt-get autoremove ..." &&
  apt-get -y autoremove &&
echo "apt-get autoclean ..." &&
  apt-get -y autoclean

echo
date "+Process ended at %Y-%m-%dT%H:%M:%S"
echo ${HLine}
