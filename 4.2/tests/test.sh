#!/bin/bash

docker-compose build --no-cache && 
docker-compose up -d redminerm42-test --force-recreate 