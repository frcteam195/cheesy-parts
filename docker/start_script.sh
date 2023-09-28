#!/bin/bash


if [ ! -f /var/lib/mysql/.initialized_db ]
then
    echo "Database not found. Initializing"
    cp -R /var/lib/mysql_initial/. /var/lib/mysql
    touch /var/lib/mysql/.initialized_db
    chown -R mysql:mysql /var/lib/mysql
fi


_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

cd /cheesy-parts
source /root/rbenv.env
sleep 4
ruby parts_server_wrapper.rb &

child=$!
wait "$child"

