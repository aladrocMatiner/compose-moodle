# compose-moodle

Local HA-style Moodle stack running on Docker Compose:
- HAProxy (TLS + host routing) → Varnish (HTTP cache) → two Moodle instances → PostgreSQL
- Keycloak for SSO (`https://sso.golum.io`)
- Grafana + Prometheus for monitoring (`https://grafana.golum.io`)

## Quick start
1. Copy `.env.example` to `.env` and adjust secrets.
2. Generate certificates: `./scripts/generate-golum-certs.sh`
3. Trust the CA (Ubuntu 24.04 helper): `./scripts/install-golum-ca-ubuntu-24.04.sh`
4. Add host entries: `./scripts/add-golum-hosts-entries.sh`
5. Start everything: `docker compose up -d`
6. Verify: `https://learn.golum.io`, `https://sso.golum.io`, `https://grafana.golum.io`

## Documentation
- Install & verification: `docs/INSTALL.md`
- Monitoring stack: `docs/MONITORING.md`
- SSO setup with Keycloak: `docs/SSO.md`
