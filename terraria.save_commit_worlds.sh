#!/bin/bash

#sends a save command to the server on screen $SCREEN and then commits to the local git repository


#run as cron, cron
# 7 7 * * * /home/terraria/server/terraria.save_commit_worlds.sh

HOME=/home/terraria/server
SCREEN=terraria

#change to server dir
pushd . > /dev/null
cd "$HOME"

#send save command to server
screen -r $SCREEN -p 0 -X stuff "save^M"
sleep 15

#update repo
git add worlds 
git add -u; 
git commit -m "worlds: `date +'%Y-%m-%d'` @ `date +'%H:%M'`";

#return to starting dir
popd > /dev/null
