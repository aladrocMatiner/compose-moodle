#!/usr/bin/env bash
set -euo pipefail

cd /var/www/html

if [ ! -f config.php ]; then
  echo "Moodle not installed yet, running CLI installer..."
  sleep 10
  php admin/cli/install.php --non-interactive --agree-license --lang=en \
    --wwwroot="https://learn.golum.io" \
    --dataroot="/bitnami/moodledata" \
    --dbtype=pgsql --dbhost=postgres --dbport=5432 \
    --dbname="${MOODLE_DB_NAME}" --dbuser="${MOODLE_DB_USER}" --dbpass="${MOODLE_DB_PASSWORD}" \
    --fullname="${MOODLE_SITE_NAME}" --shortname="Golum" \
    --adminuser="${MOODLE_ADMIN_USER}" --adminpass="${MOODLE_ADMIN_PASSWORD}" --adminemail="${MOODLE_ADMIN_EMAIL}"
else
  echo "Moodle already installed, ensuring config settings..."
fi

if [ -f config.php ]; then
  # Remove any previous sslproxy/dbsessions lines (including broken ones)
  sed -i "/\\\$CFG->sslproxy/d;/\\\$CFG->dbsessions/d;/\\\\->dbsessions/d" config.php

  if grep -q '\$CFG->directorypermissions' config.php; then
    sed -i "s/\$CFG->directorypermissions = 02777;/\$CFG->directorypermissions = 02777;\n\$CFG->sslproxy = true;\n\$CFG->dbsessions = 1;/" config.php
  else
    sed -i "s~require_once(__DIR__ . '/lib/setup.php');~\$CFG->sslproxy = true;\n\$CFG->dbsessions = 1;\n\nrequire_once(__DIR__ . '/lib/setup.php');~" config.php
  fi

  # Configure Moodle OAuth2 issuer for Keycloak (idempotent).
  if [ -f /usr/local/bin/configure-keycloak-oauth2.php ]; then
    echo "Configuring Moodle OAuth2 issuer for Keycloak..."
    php /usr/local/bin/configure-keycloak-oauth2.php || echo "Keycloak OAuth2 configuration failed (continuing)."
  fi
fi

chown -R www-data:www-data /var/www/html /bitnami/moodledata
