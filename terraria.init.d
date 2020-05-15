#!/bin/bash
# terraria server startup script
#chkconfig: 2345 80 05
#description: terraria

#set -x


RUN_AS_USER=terraria
HOME=/home/terraria/server

start() {
        echo "Starting Terraria Server: "
        if [ "x$USER" != "x$RUN_AS_USER" ]; then
          su - $RUN_AS_USER -c "$HOME/terraria.start.sh"
        else
          $HOME/terraria.start.sh
        fi
        echo "done."
}
stop() {
        echo "Shutting down Terraria Server: "

        #send exit command
        $HOME/terraria.stop.sh
        sleep 30 #wait to be safe, necessary?
        
	echo "Mercilessly killing any remaining threads.."
        #TODO use pid files

        #get and echo all screen processes
        P=$(ps auwx | grep -v grep | grep 'SCREEN -dmS terraria')
	echo -e "$P"
        
        #kill them mercilessly (TODO check for no results)
        if [[ $P ]]; then 
            kill -9 $(echo -e "$P" | awk '{print $2}')
            sleep 15 #probably not required
        fi

        #remove any dead screens
        screen -wipe 

        echo "done."
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}"
esac

