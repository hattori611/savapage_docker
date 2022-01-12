#!/bin/bash

case "$1" in
  start)
	docker-compose up -d
    ;;
  stop)
	docker-compose down
	docker-compose rm
	;;
  restart)
	docker-compose down
	docker-compose rm
    docker-compose up -d
    ;;
  *)
	echo "$1 not supported"
	echo "use start or stop"
	;;
esac