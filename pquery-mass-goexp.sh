#!/bin/bash
# Created by Roel Van de Paar, Percona LLC

SCRIPT_PWD=$(dirname $(readlink -f "${0}"))

if [ "$1" == "" ]; then
  echo "Error: please specify the workdir number (for example '123456') in /data to run pquery-go-expert.sh against. Terminating."
  exit 1
else
  if [ ! -d "/data/$1" ]; then
    echo "Error: the directory /data/$1 does not exist!"
    exit 1
  else
    #screen -admS ge$1 bash -c "ulimit -u 4000;cd /data/$1;${SCRIPT_PWD}/pquery-go-expert.sh;bash"
    screen -admS ge$1 bash -c "cd /data/$1;${SCRIPT_PWD}/pquery-go-expert.sh;bash"
    #screen -d -r ge$1
  fi
fi
