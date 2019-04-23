#!/usr/bin/env bash

docker swarm init

SWARM_TOKEN=$(docker swarm join-token -q worker)
echo $SWARM_TOKEN

SWARM_MASTER_IP=$(docker info | grep -w 'Node Address' | awk '{print $3}')
echo $SWARM_MASTER_IP

DOCKER_VERSION=18.06.3-ce-dind
NUM_WORKERS=3

for i in $(seq "${NUM_WORKERS}"); do
    docker run -d --privileged \
        --name work-${i} \
        --hostname=worker-${i} \
        -p ${i}2375:2375 \
        docker:${DOCKER_VERSION};

    docker --host=localhost:${i}2375 \
        swarm join \
        --token ${SWARM_TOKEN} ${SWARM_MASTER_IP}:2377;
done
