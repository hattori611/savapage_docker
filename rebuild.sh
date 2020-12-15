#!/bin/bash
docker ps -a -q | xargs docker rm 
docker images | grep -v ubuntu | grep -v postgres | grep -v TAG | awk '{print }' | xargs docker image rm
rm -R data/ && mkdir data && cp -R ../etc data/
docker-compose up --build
