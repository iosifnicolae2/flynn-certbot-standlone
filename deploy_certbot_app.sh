#!/usr/bin/env bash

echo "Type your email: (eg: john@example.com)"
read LETS_ENCRYPT_EMAIL

echo "Type the domain name (eg: example.your-domain.com)"
read DOMAIN

echo "Type Flynn app name associated with the domain (eg: basic-app)"
read APP_NAME

echo "Type Flynn Cluster host domain name (eg: server1.your-domain.com)"
read FLYNN_CLUSTER_HOST

flynn -c "$FLYNN_CLUSTER_HOST" create "certbot-$APP_NAME"

FLYNN_CONTROLLER_KEY=$(flynn -c "$FLYNN_CLUSTER_HOST" -a controller env get AUTH_KEY)

FLYNN_TLS_PIN=$(openssl s_client -connect "controller.$FLYNN_CLUSTER_HOST:443" \
  -servername "controller.$FLYNN_CLUSTER_HOST" 2>/dev/null </dev/null \
  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
  | openssl x509 -inform PEM -outform DER \
  | openssl dgst -binary -sha256 \
  | openssl base64)

flynn env set LETS_ENCRYPT_EMAIL="$LETS_ENCRYPT_EMAIL"
flynn env set DOMAIN="$DOMAIN"
flynn env set APP_NAME="$APP_NAME"
flynn env set FLYNN_CLUSTER_HOST="$FLYNN_CLUSTER_HOST"
flynn env set FLYNN_CONTROLLER_KEY="$FLYNN_CONTROLLER_KEY"
flynn env set FLYNN_TLS_PIN="$FLYNN_TLS_PIN"

echo "Deploying certbot.."
git push flynn master

flynn scale clock=1
