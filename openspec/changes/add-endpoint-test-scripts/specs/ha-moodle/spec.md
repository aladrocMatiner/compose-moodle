## ADDED Requirements

### Requirement: Endpoint Test Scripts
The HA Moodle stack MUST provide helper scripts that perform HTTPS reachability checks for `https://learn.golum.io`, `https://sso.golum.io`, and `https://grafana.golum.io`, returning a non-zero exit code if any endpoint is unavailable.

#### Scenario: Learn endpoint smoke test
- **GIVEN** a developer has the repository cloned
- **WHEN** they run the provided script to test `https://learn.golum.io`
- **THEN** the script attempts an HTTPS request to that hostname, reports success on a 200/302 response, and exits non-zero on failure.

#### Scenario: SSO endpoint smoke test
- **GIVEN** a developer has the repository cloned
- **WHEN** they run the provided script to test `https://sso.golum.io`
- **THEN** the script attempts an HTTPS request to that hostname, reports success on a 200/302 response, and exits non-zero on failure.

#### Scenario: Grafana endpoint smoke test
- **GIVEN** a developer has the repository cloned
- **WHEN** they run the provided script to test `https://grafana.golum.io`
- **THEN** the script attempts an HTTPS request to that hostname, reports success on a 200/302 response, and exits non-zero on failure.
