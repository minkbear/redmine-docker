#!/bin/bash

docker-compose build --no-cache && 
docker-compose up -d redminerm505-private-test --force-recreate 