## Why

We need simple helper scripts to smoke-test the three main endpoints (`https://learn.golum.io`, `https://sso.golum.io`, `https://grafana.golum.io`) so developers can quickly verify the HA Moodle stack is reachable after setup.

## What Changes

- Add CLI scripts that perform basic HTTPS checks against the Learn (Moodle), SSO (Keycloak), and Grafana endpoints using the configured hostnames.
- Provide clear success/failure output and non-zero exit on failure for use in local validation or automation.
- Document how to run these scripts as part of the install/verification flow.

## Non-Goals / Out of Scope

- Deep functional tests (e.g., logging in, exercising APIs).
- Browser-based tests or Playwright/Selenium flows.

## Open Questions / Assumptions

- Assumption: Hostnames remain `learn.golum.io`, `sso.golum.io`, `grafana.golum.io`.
- Assumption: CA trust/hosts setup is done before running the scripts so HTTPS succeeds without warnings.
- Question: Should the scripts accept alternate hostnames via env/flags for custom setups?

## Impact

- Faster local validation of the HA stack reachability.
- Minimal, single-purpose scripts to confirm endpoints respond over HTTPS.
