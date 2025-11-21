## ADDED Requirements

### Requirement: HA Moodle Docker Compose Stack
A Docker Compose stack MUST provide a high-availability–style Moodle deployment with a load balancer, HTTP cache, two Moodle application instances, a PostgreSQL database, Grafana-based monitoring, and optional Keycloak-based single sign-on suitable for local use.

#### Scenario: Stack components are defined
- **GIVEN** a developer has the repository cloned
- **WHEN** they inspect the Docker Compose configuration for Moodle
- **THEN** they can see services defined for HAProxy, Varnish, two Moodle containers, PostgreSQL, Grafana, and Keycloak.

#### Scenario: Traffic flows through HAProxy and Varnish
- **GIVEN** the stack is running and local DNS/hosts are configured for `learn.golum.io`
- **WHEN** a user accesses Moodle at `https://learn.golum.io`
- **THEN** the request is handled by HAProxy, forwarded through Varnish, and then routed to one of the two Moodle containers.

#### Scenario: Two Moodle instances behind load balancer
- **GIVEN** the stack is running
- **WHEN** traffic is sent repeatedly to the Moodle HTTP endpoint
- **THEN** HAProxy distributes requests across both Moodle containers using a configured load-balancing strategy.

#### Scenario: Shared persistence for Moodle and PostgreSQL
- **GIVEN** the stack is running with Docker volumes configured
- **WHEN** the containers are restarted without destroying volumes
- **THEN** Moodle configuration, uploaded content (moodledata), and PostgreSQL data remain available after restart.

#### Scenario: Basic monitoring via Grafana
- **GIVEN** the stack is running and local DNS/hosts are configured for `grafana.golum.io`
- **WHEN** a developer opens `https://grafana.golum.io` in a browser
- **THEN** they can see at least one dashboard or panel showing basic health metrics for the stack (e.g., HTTP traffic or PostgreSQL status) sourced from a configured data source.

### Requirement: TLS for Golum Domains
The HA Moodle stack MUST provide a single local certificate authority (CA) and use it to issue TLS certificates for `https://learn.golum.io`, `https://sso.golum.io`, and `https://grafana.golum.io`, and configure services so these endpoints are accessible over HTTPS in a local development environment.

#### Scenario: CA and certificates are available to services
- **GIVEN** a developer has the repository cloned
- **WHEN** they inspect the configuration for the stack
- **THEN** they can see how the local CA and its leaf certificates for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` are generated or provided and mounted into the relevant services.

#### Scenario: HTTPS terminates with CA-issued certificates
- **GIVEN** the stack is running and local DNS/hosts are configured for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io`
- **WHEN** a user accesses `https://learn.golum.io`, `https://sso.golum.io`, or `https://grafana.golum.io`
- **THEN** the TLS handshake completes using certificates issued by the local CA, and (after trusting the CA if needed) the browser can establish an HTTPS connection to each service without unexpected certificate errors.

### Requirement: CA Trust on Ubuntu 24.04
The HA Moodle stack MUST provide a helper script that installs the local CA into the system trust store on Ubuntu 24.04 using the distribution’s standard certificate management tools.

#### Scenario: CA install script is discoverable
- **GIVEN** a developer has the repository cloned
- **WHEN** they look for tooling to trust the local CA on Ubuntu 24.04
- **THEN** they find a documented script (for example at `scripts/install-golum-ca-ubuntu-24.04.sh`) that explains how it should be used and what it changes.

#### Scenario: CA is trusted on Ubuntu 24.04
- **GIVEN** a developer is running Ubuntu 24.04 and has cloned the repository
- **WHEN** they run the CA install script with appropriate privileges
- **THEN** the local CA is added to the system trust store, and subsequent HTTPS requests to `https://learn.golum.io`, `https://sso.golum.io`, and `https://grafana.golum.io` succeed without certificate warnings in system-trusted applications.

### Requirement: Hosts Helper Script for Golum Domains
The HA Moodle stack MUST provide a helper script that adds or updates `/etc/hosts` entries for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` so they resolve to the appropriate local IP address for the stack (typically `127.0.0.1`) on Linux systems such as Ubuntu 24.04.

#### Scenario: Hosts script is discoverable
- **GIVEN** a developer has the repository cloned
- **WHEN** they look for tooling to configure name resolution for the Golum domains
- **THEN** they find a documented script (for example at `scripts/add-golum-hosts-entries.sh`) that explains how it should be used and what it changes.

#### Scenario: Hosts entries are present after running the script
- **GIVEN** a developer is running a Linux system (e.g., Ubuntu 24.04) and has cloned the repository
- **WHEN** they run the hosts helper script with appropriate privileges
- **THEN** `/etc/hosts` contains entries that map `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` to the configured local IP address, and name resolution for these hostnames succeeds on that machine.

### Requirement: Documentation for HA Moodle Stack
The HA Moodle stack MUST include clear documentation describing how to install and operate the stack, including TLS/hosts prerequisites, and how monitoring and SSO integrations are configured and verified.

#### Scenario: Install procedure is documented
- **GIVEN** a developer has the repository cloned
- **WHEN** they follow the provided install guide
- **THEN** they can see prerequisites, how to run the CA and hosts helper scripts, how to bring up the stack, and how to verify Moodle, SSO, and monitoring endpoints are reachable over HTTPS.

#### Scenario: Monitoring integration is documented
- **GIVEN** a developer has the repository cloned
- **WHEN** they read the monitoring documentation
- **THEN** they can understand where metrics come from, how Grafana is exposed at `https://grafana.golum.io`, and how to access dashboards relevant to the Moodle stack.

#### Scenario: SSO integration is documented
- **GIVEN** a developer has the repository cloned
- **WHEN** they read the SSO documentation
- **THEN** they can understand how Moodle delegates authentication to Keycloak at `https://sso.golum.io`, including required redirect URIs, hostnames, and any Moodle plugin or configuration needed to complete the flow.

### Requirement: Moodle SSO via Keycloak
The HA Moodle stack MUST support single sign-on using a Keycloak identity provider exposed at `https://sso.golum.io`, allowing users to authenticate through Keycloak and be redirected back to Moodle.

#### Scenario: Keycloak service is defined
- **GIVEN** a developer has the repository cloned
- **WHEN** they inspect the Docker Compose configuration for the stack
- **THEN** they can see a Keycloak service defined with appropriate configuration for persistence and database connectivity.

#### Scenario: SSO endpoint is reachable
- **GIVEN** the stack is running and local DNS/hosts are configured for `sso.golum.io`
- **WHEN** a user opens `https://sso.golum.io` in a browser
- **THEN** they see the Keycloak login interface (or a reverse proxy that forwards to Keycloak) without TLS or host header errors in the supported local setup.

#### Scenario: Moodle delegates authentication to Keycloak
- **GIVEN** the stack is running and Moodle and Keycloak are both configured
- **WHEN** a user attempts to access a protected Moodle page
- **THEN** they are redirected to Keycloak for login, can authenticate successfully, and are returned to Moodle with a valid session.
