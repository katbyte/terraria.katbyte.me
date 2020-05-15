#!/bin/bash
#
#starts a terraria server instance on screen terraria

#set -x

#paths
PATH_TDSM=/home/terraria/server/tdsm
PATH_LOGS=/home/terraria/server/logs
PATH_WORLDS=/home/terraria/server/worlds
WORLD=below_and_beyond

CMD="mono --server --gc=sgen -O=all tdsm.exe -config $PATH_WORLDS/$WORLD.config"
SCREEN=terraria

#note: don't forget the newline ^M
echo "$PATH_TDSM $CMD @ $SCREEN"
mkdir -p $PATH_LOGS 
screen -dmS $SCREEN
screen -r $SCREEN -p 0 -X stuff "cd $PATH_TDSM^M"
screen -r $SCREEN -p 0 -X stuff "$CMD | tee $PATH_LOGS/$WORLD.`date +'%Y%m%d'`.`date +'%H%M'`.log 2>&1^M"
