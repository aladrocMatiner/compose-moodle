## ADDED Requirements

### Requirement: Optional Local CA Service via step-ca
The HA Moodle stack MUST support an optional `step-ca` service that can act as the local certificate authority for Golum domains, while preserving the existing script-based CA flow as a fallback.

#### Scenario: step-ca service is defined in the stack
- **GIVEN** a developer has the repository cloned
- **WHEN** they inspect the Docker Compose configuration for the HA Moodle stack
- **THEN** they can see an optional `step-ca` service defined with persistent storage for CA state and configuration.

#### Scenario: TLS certificates can be issued via step-ca
- **GIVEN** the stack is running with `step-ca` enabled
- **WHEN** a developer runs the documented certificate-generation flow for the Golum domains (`learn.golum.io`, `sso.golum.io`, `grafana.golum.io`)
- **THEN** the leaf certificates MAY be obtained from `step-ca`
- **AND** the resulting certificates are suitable for use by HAProxy to terminate HTTPS for those hostnames.

#### Scenario: Developer experience remains simple
- **GIVEN** a new developer on a supported system (e.g. Ubuntu 24.04)
- **WHEN** they follow the documented steps to enable TLS for the HA Moodle stack
- **THEN** they do not need to know the internal details of `step-ca` vs. script-only CA flows
- **AND** they can bring up HTTPS endpoints for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` with a single, clearly documented procedure.
