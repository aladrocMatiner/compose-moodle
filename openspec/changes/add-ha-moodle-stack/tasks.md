## 1. Compose Stack Definition
- [x] 1.1 Add a Docker Compose file defining HAProxy, Varnish, two Moodle containers, PostgreSQL, Grafana, and Keycloak.
- [x] 1.2 Configure HAProxy to load-balance traffic across the two Moodle containers.
- [x] 1.3 Configure Varnish to cache front-end HTTP responses from Moodle where safe.
- [x] 1.4 Define volumes for PostgreSQL data and Moodle data to ensure persistence across container restarts.
- [x] 1.5 Define storage for Keycloak data and configure its database (reusing or adding PostgreSQL as appropriate).

## 2. Configuration and Environment
- [x] 2.1 Define required environment variables (e.g., DB credentials, Moodle base URL) and their defaults in documentation.
- [x] 2.2 Wire Moodle containers to PostgreSQL using shared credentials and consistent database naming.
- [x] 2.3 Configure HAProxy and Varnish to use appropriate ports and hostnames for local development, exposing Moodle at `https://learn.golum.io`.
- [x] 2.4 Configure Keycloak with a realm and client for Moodle, including redirect URIs and client secrets.
- [x] 2.5 Configure the Keycloak base URL to serve SSO at `https://sso.golum.io` (including any reverse proxy or TLS settings needed for local use).
- [x] 2.6 Configure Moodle to use Keycloak as its SSO/identity provider (e.g., OpenID Connect or OAuth2 plugin) using the values from 2.4.
- [x] 2.7 Define a single local certificate authority (CA) and use it to generate leaf certificates for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io`, and mount the resulting keys and certificates into the relevant services.
- [x] 2.8 Style the Moodle Keycloak SSO login button with a clear label and icon so users can easily see the “Login with Keycloak” option on the Moodle login page.

## 3. Monitoring and Grafana
- [x] 3.1 Add Grafana service to the Compose stack.
- [x] 3.2 Connect Grafana to a metrics data source (e.g., Prometheus) appropriate for basic container and database monitoring.
- [x] 3.3 Configure the Grafana base URL and any reverse proxy so that the UI is served at `https://grafana.golum.io` in the supported local setup.
- [x] 3.4 Provide at least one example dashboard or configuration snippet to visualize key metrics (e.g., HTTP traffic, PostgreSQL health).

## 4. Documentation and Validation
- [x] 4.1 Document how to start, stop, and inspect the Moodle HA stack (including ports and URLs).
- [x] 4.2 Document any required one-time Moodle setup steps (e.g., initial admin user creation) when first bringing up the stack.
- [x] 4.3 Document basic Keycloak setup steps (e.g., initial admin user, realm and client creation for Moodle, and any required DNS/hosts configuration for `sso.golum.io`).
- [x] 4.4 Document any required DNS/hosts configuration and TLS/reverse-proxy setup for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io`, including how to trust the local CA on common developer platforms.
- [x] 4.5 Provide an end-to-end install guide that covers prerequisites, CA/hosts helper scripts, stack bring-up, and verification steps for Moodle, SSO, and monitoring endpoints.
- [x] 4.6 Document how the monitoring integration works (e.g., metrics source, dashboards, ports) and how the SSO flow is wired between Moodle and Keycloak (including redirect URIs and expected hostnames).
- [x] 4.7 Validate the stack by bringing it up locally and confirming: Moodle is reachable at `https://learn.golum.io` over HTTPS, HAProxy routes to both Moodle instances, Varnish serves cached responses, Moodle talks to PostgreSQL, Grafana is reachable at `https://grafana.golum.io` with a working data source over HTTPS, and users can authenticate to Moodle via Keycloak at `https://sso.golum.io` over HTTPS.
- [x] 4.8 Add a helper script for Ubuntu 24.04 (e.g., `scripts/install-golum-ca-ubuntu-24.04.sh`) that installs the local CA into the system trust store using the standard certificate update mechanisms.
- [x] 4.9 Add a helper script (e.g., `scripts/add-golum-hosts-entries.sh`) that adds or updates `/etc/hosts` entries for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` to point at the appropriate local IP (typically `127.0.0.1`) in an idempotent way.
- [x] 4.10 Update tasks to `- [x]` after successful validation.
