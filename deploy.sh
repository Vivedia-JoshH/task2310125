#!/bin/bash

# remove existing containers
docker stop $(docker ps)
docker rm -f $(docker ps -qa)

# Create a network
docker network create lab9network

# Create volume
docker volume create lab9volume

# build the Flask and Mqsql images
docker build -t trio-task-mysql:5.7 db
docker build -t trio-task-flask-app:latest flask-app

# run mysql container
docker run -d  --name mysql  --network lab9network --mount type=volume,source=lab9volume,target=/var/lib/mysql trio-task-mysql:5.7

# run the flask container
docker run -d --name flask-app --network lab9network trio-task-flask-app:latest

# run nginx container
docker run -d --name nginx -p 80:80 --network lab9network --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf nginx:latest

# show all containers
docker ps -a
