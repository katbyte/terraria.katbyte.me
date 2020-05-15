#!/bin/bash
#
#stops the terraria server instance on screen terraria

#set -x

#paths
SCREEN=terraria

#note: don't forget the newline: ^M
echo "stopping screen '$SCREEN'"
screen -r $SCREEN -p 0 -X stuff "exit^M"
