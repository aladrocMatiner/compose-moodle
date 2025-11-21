# HA Moodle Stack – Install Guide

This project provides a local HA-style Moodle stack with HAProxy → Varnish → two Moodle nodes → PostgreSQL, plus Keycloak for SSO and Grafana/Prometheus-based monitoring.

## Prerequisites
- Docker and the Docker Compose plugin
- Bash, OpenSSL
- Ubuntu 24.04 (for the provided CA trust helper; other platforms can trust the CA manually)

## 1) Configure environment
1. Copy `.env.example` to `.env` and adjust secrets as needed (DB passwords, Moodle admin, Keycloak admin, Grafana admin).
2. Keep `MOODLE_REVERSEPROXY` and `MOODLE_SSLPROXY` enabled (already set in the compose file).

## 2) Generate and trust TLS certificates
1. Generate a local CA and leaf certs for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io`:
   ```bash
   ./scripts/generate-golum-certs.sh
   ```
   Certificates are placed in `certs/ca` (CA) and `certs/live` (leaf PEMs used by HAProxy).
2. Install the CA into Ubuntu 24.04 trust (optional but recommended to avoid browser warnings):
   ```bash
   ./scripts/install-golum-ca-ubuntu-24.04.sh
   ```
   On other platforms, import `certs/ca/golum-local-ca.crt` into the system/browser trust store.

## 3) Add hostnames to /etc/hosts
Add entries for the Golum domains to point to your local machine (default 127.0.0.1):
```bash
./scripts/add-golum-hosts-entries.sh           # uses 127.0.0.1
# or specify a custom IP (e.g., when testing from a VM):
# ./scripts/add-golum-hosts-entries.sh 192.168.56.10
```

## 4) Bring up the stack
```bash
docker compose up -d
docker compose ps
```

## 5) Verify endpoints
- Moodle (through HAProxy + Varnish): `https://learn.golum.io`
  - Login with the admin credentials from `.env` (e.g., `MOODLE_ADMIN_USER` / `MOODLE_ADMIN_PASSWORD`).
  - On first login, confirm the admin account, review site defaults, and update the admin password/email if desired.
- Keycloak SSO: `https://sso.golum.io`
  - Login with `KEYCLOAK_ADMIN_USER` / `KEYCLOAK_ADMIN_PASSWORD`, then follow `docs/SSO.md` to create a realm/client.
- Grafana: `https://grafana.golum.io`
  - Login with `GRAFANA_ADMIN_USER` / `GRAFANA_ADMIN_PASSWORD`. Dashboards and the Prometheus data source are pre-provisioned (see `docs/MONITORING.md`).

## 6) Stopping and cleanup
- Stop the stack: `docker compose down`
- Remove volumes (destructive): `docker compose down -v`

## Notes
- The HAProxy config expects certificates at `certs/live/*.pem`; regenerate if hostnames change.
- Keycloak runs behind HAProxy with `KC_PROXY=edge`; set redirect URIs to `https://learn.golum.io/*`.
- PostgreSQL, Moodle data, Grafana data, and Prometheus data are stored in Docker volumes. Remove with `docker compose down -v` if you need a clean slate.
