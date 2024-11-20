#!/bin/sh

domain=$1
label="${2:-nginx}"
base="${3:-/etc/nginx/ssl}"
reload="${4:-nginx -s reload}"
dco exec -e DEPLOY_DOCKER_CONTAINER_LABEL=sh.acme.autoload.container="${label}" \
    -e DEPLOY_DOCKER_CONTAINER_KEY_FILE="${base}/${domain}/key.pem" \
    -e DEPLOY_DOCKER_CONTAINER_CERT_FILE="${base}/${domain}/cert.pem" \
    -e DEPLOY_DOCKER_CONTAINER_CA_FILE="${base}/${domain}/ca.pem" \
    -e DEPLOY_DOCKER_CONTAINER_FULLCHAIN_FILE="${base}/${domain}/full.pem" \
    -e DEPLOY_DOCKER_CONTAINER_RELOAD_CMD="${reload}" \
    acme-sh --deploy -d ${domain} --deploy-hook docker
