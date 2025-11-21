## Why

The project needs a high-availability Docker Compose stack for Moodle that can be used for local development, demos, and basic HA experiments. The requested stack should front Moodle with HAProxy and Varnish, run two Moodle application instances, use PostgreSQL as the database, expose Moodle at `https://learn.golum.io`, provide basic Grafana-based monitoring via `https://grafana.golum.io`, and support single sign-on (SSO) via a Keycloak identity provider.

## What Changes

- Define a new Docker Compose–based HA stack for Moodle, including HAProxy, Varnish, two Moodle containers, PostgreSQL, Grafana, and a Keycloak container.
- Specify how traffic flows through HAProxy and Varnish to the Moodle instances exposed at `https://learn.golum.io`.
- Describe persistence expectations for PostgreSQL and Moodle data in a Compose-friendly way.
- Introduce basic observability via Grafana dashboards, assuming standard exporters (e.g., Prometheus stack) that can be refined later, and expose the Grafana UI at `https://grafana.golum.io`.
- Add Keycloak as an identity provider for Moodle, exposing SSO at `https://sso.golum.io` and configuring Moodle to delegate authentication to Keycloak.
- Provide self-signed TLS certificates for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` suitable for local use, and configure the stack to use them.
- Produce coherent documentation that covers end-to-end installation (including CA trust and hosts setup) and explains how monitoring and SSO integrations are wired.
- Document environment variables and minimal configuration required to bring up the stack, including SSO- and TLS-related settings.

## Non-Goals / Out of Scope

- Production-grade clustering for PostgreSQL (single PostgreSQL instance is acceptable for this iteration).
- Automated horizontal scaling beyond two Moodle application containers.
- Detailed security hardening of HAProxy, Varnish, Moodle, Grafana, or Keycloak beyond sane defaults.
- Multi-datacenter or multi-node orchestration (e.g., Kubernetes) – this change focuses on Docker Compose only.
- Complex Keycloak realm design (advanced roles, multi-tenant setups, or external identity provider federation).

## Open Questions / Assumptions

- Assumption: A single PostgreSQL instance with persistent volumes is acceptable for now, even though it is a single point of failure.
- Assumption: Moodle files (moodledata) and configuration can be shared via Docker volumes suitable for both application containers.
- Assumption: Using standard container images from Docker Hub (e.g., official PostgreSQL, community Moodle images, official Keycloak, Grafana) is acceptable.
- Assumption: A single local certificate authority (CA) can be used to issue leaf certificates for `https://learn.golum.io`, `https://sso.golum.io`, and `https://grafana.golum.io`, and developers can install this CA into their systems’ trust stores for a warning-free HTTPS experience.
- Question: Are there preferred versions for Moodle, PostgreSQL, Grafana, or Keycloak that the stack should standardize on?
- Question: Is Prometheus + node/exporter acceptable as the basis for Grafana dashboards, or should Grafana consume metrics from another existing system?
- Question: Should Keycloak reuse the existing PostgreSQL instance or have a dedicated database for identity data?

## Impact

- Provides a reproducible HA-style Moodle environment for local use.
- Establishes a pattern for composing reverse proxy, cache, application, database, identity provider, and monitoring services together.
- Adds SSO via Keycloak at `https://sso.golum.io`, improving the realism of the environment for authentication flows.
- Adds new configuration and documentation but does not change any existing specs or behavior (no existing specs yet).
