#!/bin/bash
# run_registry.sh

#export PROXY_SERVER=proxy_server
#export PROXY_PORT=8080
#export NO_PROXY=127.0.0.1,localhost,192.168.0.1

export REGISTRY_PORT=8443

sudo docker run -d \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/hyperv-ubuntu18.local.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/hyperv-ubuntu18.local.key \
  -p ${REGISTRY_PORT}:443 \
  -v $(pwd)/certs:/certs \
  -v $(pwd)/auth:/auth \
  --restart=always \
  --name registry \
  registry:2.7

#  -e HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT} \
#  -e HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT} \
#  -e NO_PROXY=${NO_PROXY} \