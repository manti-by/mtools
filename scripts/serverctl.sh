#!/bin/bash
SERVER=$1
ACTION=$2

if [ -z "$SERVER" ] || [ -z "$ACTION" ]; then
  echo "Usage: serverctl [servername] [start|stop]"
else
  if [ "$ACTION" == "start" ]
    echo "[INFO] Starting $SERVER server"
    sudo etherwake 38:d5:47:10:9f:55 -i enp2s0
  elif [ "$ACTION" == "stop" ]; then
    echo "[INFO] Stoping $SERVER server"
    ssh $SERVER "sudo poweroff"
  else
    echo "[ERROR] Unknow action"
  fi
fi

