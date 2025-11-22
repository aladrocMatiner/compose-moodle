## ADDED Requirements

### Requirement: Centralised Container Logging
All containers in the Moodle HA stack MUST have their stdout/stderr logs collected centrally and queryable via Grafana.

#### Scenario: Loki service receives logs from stack containers
- **GIVEN** the Docker compose stack is running with the logging components enabled
- **WHEN** any service container in the stack writes logs to stdout/stderr
- **THEN** those logs MUST be ingested by a Loki instance running in the same compose stack
- **AND** logs MUST be stored in a way that survives container restarts (within the limits of the Loki retention policy).

#### Scenario: Promtail discovers Docker containers automatically
- **GIVEN** promtail is running in the compose stack
- **WHEN** a service container (e.g. `moodle1`, `haproxy`, `keycloak`, `postgres`) is started or restarted
- **THEN** promtail MUST automatically discover the container via Docker service discovery
- **AND** attach useful labels (at least container name) to the log stream before sending it to Loki.

### Requirement: Grafana Loki Datasource
Grafana MUST be configured with a Loki datasource that allows querying logs from the Moodle stack.

#### Scenario: Loki datasource is provisioned automatically
- **GIVEN** the compose stack is started from a clean environment
- **WHEN** Grafana starts for the first time
- **THEN** a Loki datasource pointing at the in-stack Loki instance MUST be provisioned automatically
- **AND** the datasource MUST be visible in the Grafana UI without manual configuration.

#### Scenario: Logs visible in Grafana Explore
- **GIVEN** the Loki datasource is available in Grafana
- **WHEN** an operator opens Grafana Explore and selects the Loki datasource
- **THEN** they MUST be able to see log entries from at least the core services (`haproxy`, `moodle1`, `moodle2`, `keycloak`, `postgres`)
- **AND** they MUST be able to filter by container name.

