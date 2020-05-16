#!/bin/bash
#
#starts a terraria server instance on screen terraria

#set -x

#paths
HOME=/home/terraria
REPO=$HOME/terraria.katbyte.me
PATH_SERVER=$REPO/server/1401
PATH_LOGS=$HOME/logs
PATH_WORLDS=$REPO/worlds

#the world to use
WORLD=deep,_deeper,_deepest.wld

#cmd to start the server
CMD="$PATH_SERVER/TerrariaServer.bin.x86_64 -port 7777 -players 32 -pass digdiggerdiggest -motd \"beware hidden ice\" -world $PATH_WORLDS/$WORLD -secure -noupnp"

#screen name
SCREEN=terraria


echo "|$SCREEN| <-- $CMD"


#ensure logs path exists
mkdir -p $PATH_LOGS 

#NOTE: don't forget the newline ^M
screen -dmS $SCREEN
screen -r $SCREEN -p 0 -X stuff "$CMD | tee $PATH_LOGS/$WORLD.`date +'%Y%m%d'`.`date +'%H%M'`.log 2>&1^M"
