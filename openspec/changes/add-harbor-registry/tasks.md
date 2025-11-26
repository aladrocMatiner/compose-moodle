## 1. Harbor Stack Definition
- [ ] 1.1 Add a Docker Compose profile (or dedicated file) that starts Harbor core services (portal, core, jobservice, registry, trivy, redis, postgresql) exposed as `https://registry.golum.io` and backed by the local CA certificates.
- [ ] 1.2 Configure persistence for Harbor (database, registry data, jobservice artifacts) using Docker volumes suitable for local use.
- [ ] 1.3 Provide a helper command/script (e.g., `scripts/bootstrap-harbor.sh`) that starts only the Harbor profile, waits until the API responds, and seeds the required admin/project configuration.

## 2. Image Mirroring Workflow
- [ ] 2.1 Define the list of upstream images required by the Moodle HA stack (Moodle, HAProxy, Varnish, PostgreSQL, Grafana, Keycloak, etc.).
- [ ] 2.2 Extend the bootstrap script (or companion tooling) to pull those upstream images, retag them as `registry.golum.io/library/<service>:<tag>`, push them into Harbor, and trigger Trivy scans for each push.
- [ ] 2.3 Document and validate that the mirroring workflow is idempotent, emitting clear logs when images are already present/scanned.

## 3. Compose Integration
- [ ] 3.1 Update the main compose files to reference Harbor-hosted images (e.g., `registry.golum.io/library/moodle:tag`) instead of Docker Hub tags.
- [ ] 3.2 Ensure the default bring-up flow enforces "Harbor first": other services should only start after Harbor is healthy and populated (e.g., via explicit instructions, Make target, or orchestration script).
- [ ] 3.3 Add configuration/env variables so developers can authenticate `docker` CLI to the local Harbor registry before mirroring or pulling images.

## 4. Documentation & Validation
- [ ] 4.1 Extend the docs to explain prerequisites (trusting the CA for `registry.golum.io`), how to start Harbor, mirror images, review scan results, and finally bring up the Moodle stack from the private registry.
- [ ] 4.2 Document how to re-run scans or review Trivy findings inside Harbor.
- [ ] 4.3 Validate the entire flow: starting from a clean machine, bring up Harbor, mirror/push images, confirm Harbor shows scan results, and then bring up the Moodle stack that now pulls exclusively from `registry.golum.io`.
- [ ] 4.4 After validation, mark all checklist items as complete.
