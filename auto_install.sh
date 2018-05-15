#!/bin/bash
# Auto installation of miner check script for PNMine

cd /home/ethos
wget https://raw.githubusercontent.com/yijiasu/PNMineMonitor/master/checkrig.sh
chmod +x ./checkrig.sh
echo "add crontab: */1 * * * * /home/ethos/checkrig.sh"
