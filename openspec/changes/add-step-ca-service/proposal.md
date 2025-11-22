## Why

The current HA Moodle stack already provides a local certificate authority (CA) and helper scripts to generate and trust self-signed certificates for `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io`. However, certificate issuance and lifecycle are handled by shell scripts only, without a dedicated CA service. Introducing `step-ca` (Smallstep CA) would give us:

- A more realistic, service-based CA that can issue and manage certificates for the Golum domains.
- A clearer path to extend certificate management (e.g. automated renewal, more hostnames) without rewriting scripts.
- A closer resemblance to production-grade PKI flows, while still remaining local and self-contained.

## What Changes

- Add an optional `step-ca` service to the Docker Compose stack to act as the local CA.
- Configure `step-ca` with a minimal configuration suitable for issuing certificates for:
  - `learn.golum.io`
  - `sso.golum.io`
  - `grafana.golum.io`
- Wire the existing TLS tooling so it can either:
  - Use `step-ca` to issue the leaf certificates, or
  - Fall back to the current “script-only” CA generation flow when `step-ca` is not enabled.
- Keep the experience simple for developers: a single documented path to “bring up CA + certificates” for local use.

## Impact

- Improves the realism and maintainability of the local CA story.
- Adds another long-running service (`step-ca`) to the stack when enabled, with some CPU/memory overhead.
- Does not remove the existing CA helper script capabilities; instead, it builds on them and routes issuance through `step-ca` where practical.

