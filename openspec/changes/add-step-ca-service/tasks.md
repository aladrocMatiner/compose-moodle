## 1. Introduce `step-ca` service
- [ ] 1.1 Define a `step-ca` service in `docker-compose.yml` with a persistent volume for CA state and a minimal configuration for local use.
- [ ] 1.2 Add a `config/step-ca` directory with an initial `ca.json` / bootstrap configuration suitable for issuing certificates for the Golum domains.
- [ ] 1.3 Ensure `step-ca` is reachable from the certificate-generation tooling (scripts or helper containers) over the `golum` network.

## 2. Integrate `step-ca` with existing TLS flow
- [ ] 2.1 Update the certificate-generation script(s) to optionally use `step-ca` for issuing the `learn.golum.io`, `sso.golum.io`, and `grafana.golum.io` leaf certificates.
- [ ] 2.2 Keep backwards compatibility so an existing “script-only” flow still works if `step-ca` is not enabled.
- [ ] 2.3 Ensure HAProxy continues to receive and use valid certificates regardless of whether `step-ca` is active.

## 3. Developer experience and documentation
- [ ] 3.1 Document how to start `step-ca` as part of the stack and how the CA interacts with the existing TLS scripts.
- [ ] 3.2 Update TLS/CA documentation (e.g. install/monitoring docs) to mention `step-ca` and describe when and why to use it.
- [ ] 3.3 Verify that a new developer can follow the docs to bring up `step-ca`, generate/refresh certificates, trust the CA, and access all three HTTPS endpoints without unexpected certificate errors.

