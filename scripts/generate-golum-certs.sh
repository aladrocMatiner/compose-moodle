#!/usr/bin/env bash
set -euo pipefail

DOMAINS=("learn.golum.io" "sso.golum.io" "grafana.golum.io")
CA_DIR="certs/ca"
LIVE_DIR="certs/live"
CA_KEY="${CA_DIR}/golum-local-ca.key"
CA_CRT="${CA_DIR}/golum-local-ca.crt"

mkdir -p "${CA_DIR}" "${LIVE_DIR}"

if [[ ! -f "${CA_KEY}" || ! -f "${CA_CRT}" ]]; then
  echo "Generating local CA..."
  openssl req -x509 -new -nodes -newkey rsa:4096 \
    -keyout "${CA_KEY}" \
    -out "${CA_CRT}" \
    -sha256 \
    -days 825 \
    -subj "/CN=Golum Local CA"
else
  echo "Using existing local CA at ${CA_DIR}"
fi

for domain in "${DOMAINS[@]}"; do
  echo "Generating leaf certificate for ${domain}"
  CNF_FILE="${LIVE_DIR}/${domain}.cnf"
  KEY_FILE="${LIVE_DIR}/${domain}.key"
  CSR_FILE="${LIVE_DIR}/${domain}.csr"
  CRT_FILE="${LIVE_DIR}/${domain}.crt"
  PEM_FILE="${LIVE_DIR}/${domain}.pem"

  cat > "${CNF_FILE}" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = v3_req
distinguished_name = dn

[dn]
CN = ${domain}

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${domain}
EOF

  openssl req -new -nodes -newkey rsa:2048 \
    -keyout "${KEY_FILE}" \
    -out "${CSR_FILE}" \
    -config "${CNF_FILE}"

  openssl x509 -req -in "${CSR_FILE}" \
    -CA "${CA_CRT}" -CAkey "${CA_KEY}" -CAcreateserial \
    -out "${CRT_FILE}" -days 397 -sha256 \
    -extensions v3_req -extfile "${CNF_FILE}"

  cat "${CRT_FILE}" "${KEY_FILE}" > "${PEM_FILE}"
  rm -f "${CSR_FILE}" "${CNF_FILE}"
done

echo "Certificates generated in ${LIVE_DIR}"
echo "Install the CA with scripts/install-golum-ca-ubuntu-24.04.sh on Ubuntu 24.04 or trust ${CA_CRT} on your platform."
