## 1. Loki + promtail services
- [x] 1.1 Add `loki` service to `docker-compose.yml` with minimal single-node config and persistent volume.
- [x] 1.2 Add `promtail` service to `docker-compose.yml` configured to use Docker service discovery via `/var/run/docker.sock`.
- [x] 1.3 Add `config/loki/loki-config.yml` and `config/promtail/promtail-config.yml` with minimal, production-friendly defaults for this stack.

## 2. Grafana integration
- [x] 2.1 Add a Loki datasource provisioning file under `config/grafana/provisioning/datasources/`.
- [x] 2.2 Ensure Grafana can reach Loki over the internal `golum` network and that the datasource appears in the UI.

## 3. Validation
- [x] 3.1 Bring the stack up with `docker compose up -d` and confirm `loki` and `promtail` are healthy.
- [x] 3.2 Generate some logs (e.g., hitting Moodle and Keycloak endpoints) and verify they appear in Grafana’s Explore view via the Loki datasource.
- [x] 3.3 Update any relevant documentation to mention the new logging pipeline and how to access logs.
