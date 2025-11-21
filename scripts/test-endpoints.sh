#!/usr/bin/env bash
set -euo pipefail

# Simple HTTPS reachability checks for the Golum stack endpoints.

LEARN_HOST="${LEARN_HOST:-https://learn.golum.io}"
SSO_HOST="${SSO_HOST:-https://sso.golum.io}"
GRAFANA_HOST="${GRAFANA_HOST:-https://grafana.golum.io}"

# Allow opting into -k if the local CA is not trusted yet.
CURL_INSECURE_FLAGS=()
if [[ "${ALLOW_INSECURE:-0}" == "1" ]]; then
  CURL_INSECURE_FLAGS=(-k)
fi

check_url() {
  local name="$1"
  local url="$2"

  printf "Checking %-8s %s ... " "${name}" "${url}"
  status=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 10 \
    "${CURL_INSECURE_FLAGS[@]}" \
    "${url}" || true)

  if [[ "${status}" == "200" || "${status}" == "301" || "${status}" == "302" ]]; then
    echo "OK (HTTP ${status})"
    return 0
  fi

  echo "FAIL (HTTP ${status:-none})"
  return 1
}

failed=0
check_url "learn" "${LEARN_HOST}" || failed=1
check_url "sso" "${SSO_HOST}" || failed=1
check_url "grafana" "${GRAFANA_HOST}" || failed=1

exit "${failed}"
