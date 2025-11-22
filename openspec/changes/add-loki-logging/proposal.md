## Why

The current monitoring stack provides metrics (Prometheus + exporters) and dashboards (Grafana), but it does not capture or visualise logs from the Moodle, HAProxy, Keycloak, Postgres, or other containers. For troubleshooting and operational visibility, we want a standard, self-contained log pipeline that plugs into the existing Grafana instance.

## What Changes

- Introduce a Loki service to store logs for all containers in the compose stack.
- Introduce a promtail service configured to discover Docker containers and forward their logs to Loki.
- Provision a Loki datasource in Grafana so logs are queryable directly from the existing monitoring UI.
- Keep the integration minimal and self-contained (no host-specific changes beyond the Docker socket mount for promtail).

## Impact

- Developers and operators can inspect logs for any container in the stack via Grafana.
- No changes to application code; only compose services and configuration are updated.
- Additional resource usage for Loki/promtail, but limited to this stack.

