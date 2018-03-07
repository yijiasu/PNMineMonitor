#!/bin/bash
#
# Auto-reboot script for ethOS 1.2.9
# https://trick77.com/auto-restart-crashed-mining-processes-ethos
#
# This script will automatically reboot the mining rig depending on the reported
# mining status in ethOS.
# - The script should be triggered every 15 minutes from a cron job.
# - May or may not work with other ethOS versions than indicated above.
#
# This script should only be used in more or less stable rigs. Do not use it on rigs that aren't properly
# fine tuned.
#
DRY_RUN=false # set this to false to enable auto-restart/reboot
LOG_FILE=/home/ethos/rigcheck.log

if [ "$EUID" != 0 ]
  then echo "Please run as root or, if calling it from a console, use sudo $0"
  exit
fi

if [ ${DRY_RUN} = true ]; then
  echo "$(date) $0 running in DRY_RUN mode, auto-reboot not enabled!" | tee -a ${LOG_FILE}
fi

ALLOW=$(cat /opt/ethos/etc/allow.file)
if [ ${ALLOW} != 1 ]; then
  echo "$(date) Miner not enabled, exiting $0..." | tee -a ${LOG_FILE}
  exit 0
fi

if grep -q "gpu clock problem" /var/run/ethos/status.file; then
  CRASHED=$(cat /var/run/ethos/crashed_gpus.file)
  echo "$(date) GPU clock problem detected on GPU(s) ${CRASHED}, rebooting..." | tee -a ${LOG_FILE}
  if [ ${DRY_RUN} = false ]; then
    rm -f /var/run/ethos/crashed_gpus.file
    /opt/ethos/bin/minestop
    sleep 5
    /opt/ethos/bin/minestart
  fi
elif grep -q "gpu crashed" /var/run/ethos/status.file; then
  echo "$(date) GPU crash detected, rebooting..." | tee -a ${LOG_FILE}
  if [ ${DRY_RUN} = false ]; then
    rm -f /var/run/ethos/crashed_gpus.file
    /opt/ethos/bin/minestop
    sleep 5
    /opt/ethos/bin/minestart
  fi
else
  echo "Everything's fine, exiting..."
fi
