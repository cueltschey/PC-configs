#!/bin/bash

DOCKER_PROC=$(docker ps --filter="ancestor=local/llama" | awk '!/CONTAINER/{print $1}')
if [ -z "$DOCKER_PROC" ]; then
	# Start ollama container
	docker run -it -d local/llama
	sleep 10
	DOCKER_PROC=$(docker ps --filter="ancestor=local/llama" | awk '!/CONTAINER/{print $1}')
fi

if [ -z "$DOCKER_PROC" ]; then
	echo "Docker ollama failed"
	exit 1
fi

docker exec -it $DOCKER_PROC ollama run llama3.2
