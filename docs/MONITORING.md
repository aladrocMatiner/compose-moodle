# Monitoring

## What’s included
- **Prometheus**: scrapes metrics from:
  - `prom-node-exporter` (host/container metrics)
  - `postgres-exporter` (PostgreSQL metrics)
- **Grafana**: pre-provisioned with a Prometheus data source and a starter dashboard at `HA Moodle/HA Moodle Overview`.

## Access
- URL: `https://grafana.golum.io`
- Credentials: `GRAFANA_ADMIN_USER` / `GRAFANA_ADMIN_PASSWORD` from `.env`
- Data source: Prometheus at `http://prometheus:9090` (pre-provisioned in `config/grafana/provisioning/datasources/datasource.yml`).

## Dashboards
- Starter dashboard: `HA Moodle Overview` (from `config/grafana/dashboards/ha-overview.json`)
  - Postgres exporter uptime
  - Postgres connections for the Moodle DB
  - Node load average
- Add your own dashboards by dropping JSON into `config/grafana/dashboards/` and updating `config/grafana/provisioning/dashboards/dashboard.yml` if you add new folders.

## Prometheus configuration
- Config file: `config/prometheus/prometheus.yml`
- Scrape jobs:
  - `prometheus:9090`
  - `postgres-exporter:9187`
  - `prom-node-exporter:9100`
- Reload Prometheus after config changes:
  ```bash
  docker compose kill -s HUP prometheus
  ```
