#!/bin/bash
#
#starts a terraria server instance on screen terraria

#set -x

#paths
PATH_TDSM=/home/terraria/server/tdsm
PATH_LOGS=/home/terraria/server/logs
PATH_WORLDS=/home/terraria/server/worlds
PATH_BIN="$PATH_TDSM/Binaries"

#the world to use
WORLD=below_and_beyond

#cmd to start the server
CMD="mono --llvm --server --gc=sgen -O=all tdsm.exe -config $PATH_WORLDS/$WORLD.config"

#screen name
SCREEN=terraria


echo "$PATH_BIN $CMD @ $SCREEN"


#ensure logs path exists
mkdir -p $PATH_LOGS 

#start screen and send commands to it (cd to tdsm binaries path and start server)
#NOTE: don't forget the newline ^M
screen -dmS $SCREEN
screen -r $SCREEN -p 0 -X stuff "cd $PATH_BIN^M"
screen -r $SCREEN -p 0 -X stuff "$CMD | tee $PATH_LOGS/$WORLD.`date +'%Y%m%d'`.`date +'%H%M'`.log 2>&1^M"

#mono commandline options
# --aot
#     use Ahead-of-Time compilation 
#
# --gc=sgen
#     use the sgen garbage collector
#
# --llvm
#     use LLVM optimizations and code generation engine to JIT or AOT compile
#
# -O=all
#     Turn on all optimizations
# 
# --server
#     Configures  the  virtual  machine to be better suited for server operations
#
