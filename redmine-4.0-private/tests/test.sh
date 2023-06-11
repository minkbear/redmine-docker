#!/bin/bash

docker-compose build --no-cache && 
docker-compose up -d redminerm40-test --force-recreate 