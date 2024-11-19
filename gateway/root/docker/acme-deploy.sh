#!/bin/sh
domain=$1
dco exec -e DEPLOY_DOCKER_CONTAINER_LABEL=sh.acme.autoload.container=nginx \
    -e DEPLOY_DOCKER_CONTAINER_KEY_FILE=/etc/nginx/ssl/${domain}/key.pem \
    -e DEPLOY_DOCKER_CONTAINER_CERT_FILE="/etc/nginx/ssl/${domain}/cert.pem" \
    -e DEPLOY_DOCKER_CONTAINER_CA_FILE="/etc/nginx/ssl/${domain}/ca.pem" \
    -e DEPLOY_DOCKER_CONTAINER_FULLCHAIN_FILE="/etc/nginx/ssl/${domain}/full.pem" \
    -e DEPLOY_DOCKER_CONTAINER_RELOAD_CMD="nginx -s reload" \
    acme-sh --deploy -d ${domain} --deploy-hook docker
