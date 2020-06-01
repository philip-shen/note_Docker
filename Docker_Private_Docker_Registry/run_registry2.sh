#!/bin/bash
# run_registry2.sh

export REGISTRY_PORT=8443

sudo docker run -d \
  -v $(pwd)/config.yml:/etc/docker/registry/config.yml \
  -p ${REGISTRY_PORT}:443 \
  -v $(pwd)/certs:/certs \
  -v $(pwd)/auth:/auth \
  --restart=always \
  --name registry \
  registry:2.7