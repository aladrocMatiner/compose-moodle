#!/usr/bin/env bash
set -euo pipefail

IP_ADDRESS="${1:-127.0.0.1}"
DOMAINS=("learn.golum.io" "sso.golum.io" "grafana.golum.io")
HOSTS_FILE="/etc/hosts"

filter_regex="$(printf '%s|' "${DOMAINS[@]}")"
filter_regex="${filter_regex%|}"

tmpfile="$(mktemp)"
trap 'rm -f "${tmpfile}"' EXIT

echo "Updating ${HOSTS_FILE} to point Golum domains to ${IP_ADDRESS}..."

grep -vE "\\b(${filter_regex})\\b" "${HOSTS_FILE}" > "${tmpfile}" || true
echo "${IP_ADDRESS} ${DOMAINS[*]}" >> "${tmpfile}"

if [[ $EUID -ne 0 ]]; then
  echo "Switching to sudo to write ${HOSTS_FILE} (password may be required)..."
  sudo cp "${tmpfile}" "${HOSTS_FILE}"
else
  cp "${tmpfile}" "${HOSTS_FILE}"
fi

echo "Hosts entries set:"
echo "  ${IP_ADDRESS} ${DOMAINS[*]}"
