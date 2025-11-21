#!/usr/bin/env bash
set -euo pipefail

CA_CERT_PATH="${1:-certs/ca/golum-local-ca.crt}"
CA_CERT_NAME="${2:-golum-local-ca.crt}"
TARGET="/usr/local/share/ca-certificates/${CA_CERT_NAME}"

if [[ ! -f "${CA_CERT_PATH}" ]]; then
  echo "CA certificate not found at ${CA_CERT_PATH}. Generate it first with scripts/generate-golum-certs.sh."
  exit 1
fi

if ! grep -q "Ubuntu 24.04" /etc/os-release; then
  echo "Warning: This helper is intended for Ubuntu 24.04. Continuing anyway..."
fi

copy_cmd=(cp "${CA_CERT_PATH}" "${TARGET}")
update_cmd=(update-ca-certificates)

if [[ $EUID -ne 0 ]]; then
  echo "Elevating privileges to install CA certificate..."
  sudo "${copy_cmd[@]}"
  sudo "${update_cmd[@]}"
else
  "${copy_cmd[@]}"
  "${update_cmd[@]}"
fi

echo "Installed CA certificate to ${TARGET} and refreshed trust store."
