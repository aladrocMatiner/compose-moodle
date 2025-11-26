## ADDED Requirements

### Requirement: Local Harbor Registry Service
The compose repository MUST provide a Harbor deployment (portal, core, jobservice, registry, chartmuseum, Trivy scanner, Redis, and PostgreSQL) that is reachable at `https://registry.golum.io` using the existing local certificate authority so developers can authenticate Docker against a private registry without external dependencies.

#### Scenario: Harbor services are defined
- **GIVEN** a developer inspects the compose configuration
- **WHEN** they view the Harbor-specific profile or file
- **THEN** they see services for Harbor portal, core, jobservice, registry, chartmuseum, Trivy, Redis, and PostgreSQL with persistent volumes defined.

#### Scenario: Harbor UI is reachable over HTTPS
- **GIVEN** the Harbor profile is running and the local CA is trusted
- **WHEN** a developer visits `https://registry.golum.io`
- **THEN** they can access the Harbor UI without TLS errors, sign in with the documented credentials, and manage projects locally.

### Requirement: Harbor-First Deployment Workflow
The project MUST document and enforce a workflow where Harbor is started and verified healthy before any other compose services run, ensuring the local registry is available and populated prior to launching Moodle or supporting components.

#### Scenario: Harbor bootstrap command exists
- **GIVEN** a developer has cloned the repo
- **WHEN** they look at the provided tooling (e.g., Makefile target or script)
- **THEN** they find a command that starts only the Harbor stack, waits for Harbor’s health/`/api/v2.0/` endpoint to succeed, and reports when the registry is ready for pushes.

#### Scenario: Stack startup depends on Harbor readiness
- **GIVEN** Harbor has not been started
- **WHEN** a developer attempts to run the main stack command without running the Harbor bootstrap first
- **THEN** the documentation (or tooling guardrails) clearly instructs them to initialize Harbor before continuing, preventing the rest of the stack from pulling public images directly.

### Requirement: Image Mirroring into Harbor
A helper script MUST pull every upstream image required by the Moodle stack, retag it with the Harbor hostname/project, push it to Harbor, and trigger a vulnerability scan so that the entire stack can later pull solely from the local registry.

#### Scenario: Mirroring script is discoverable
- **GIVEN** the repository is cloned
- **WHEN** a developer searches for instructions on copying images into Harbor
- **THEN** they find a documented script (for example `scripts/mirror-images-into-harbor.sh`) that enumerates the required upstream images and describes how to run it.

#### Scenario: All required images are mirrored
- **GIVEN** Harbor is running and the mirroring script executes successfully
- **WHEN** the script completes
- **THEN** each image used by the Moodle stack (Moodle, HAProxy, Varnish, PostgreSQL, Grafana, Keycloak, supporting utilities) exists inside Harbor with the expected tags, ready for local pulls.

### Requirement: Compose Services Pull from Harbor
All Docker Compose services for the Moodle stack MUST reference the Harbor registry hostname/tag so that runtime pulls never hit Docker Hub or other external registries once Harbor is initialized.

#### Scenario: Compose config references Harbor
- **GIVEN** a developer runs `docker compose config`
- **WHEN** they inspect the rendered services
- **THEN** every service image is prefixed with `registry.golum.io/` (or the configured Harbor hostname), proving that the compose stack depends solely on the private registry.

#### Scenario: Stack runs after Harbor mirroring
- **GIVEN** Harbor has been populated via the mirroring workflow
- **WHEN** the developer starts the Moodle stack
- **THEN** each container pulls from Harbor without attempting to fetch from public registries, completing successfully even when the machine is offline.

### Requirement: Vulnerability Scanning via Harbor
Harbor’s Trivy scanner MUST be enabled so that each push (manual or via the mirroring script) produces vulnerability reports that developers can review before proceeding with the stack deployment.

#### Scenario: Scans trigger on push
- **GIVEN** the mirroring script pushes an image into Harbor
- **WHEN** the push completes
- **THEN** Harbor automatically queues a Trivy scan for that artifact and the UI/API shows the scan status/results.

#### Scenario: Developers can review scan results
- **GIVEN** a developer wants to verify image health
- **WHEN** they open the Harbor UI or query the Harbor API for a mirrored artifact
- **THEN** they can see the latest vulnerability report, including severity counts, without running standalone scanners.

### Requirement: Harbor Workflow Documentation
The repository MUST document how to trust Harbor’s certificate, start the Harbor services, mirror images, validate scans, and then launch the Moodle stack against the local registry so new contributors can follow the workflow end-to-end.

#### Scenario: Documentation describes Harbor prerequisites
- **GIVEN** a new contributor reads the docs
- **WHEN** they follow the Harbor section
- **THEN** they learn how to trust the CA for `registry.golum.io`, authenticate the Docker CLI, and run the bootstrap/mirroring scripts.

#### Scenario: Documentation explains Harbor-first stack bring-up
- **GIVEN** developers need the final stack running
- **WHEN** they follow the documented sequence
- **THEN** they start Harbor, mirror/scan images, and only then start the rest of the compose services, confirming that the stack now runs entirely from the private registry.
