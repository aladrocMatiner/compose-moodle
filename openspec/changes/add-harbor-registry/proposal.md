## Why

Developers want to run the Moodle compose stack without depending on public container registries and they also need built-in image vulnerability scans. Running Harbor locally solves both needs: it caches/publishes every image used by the stack and provides first-party scanners so the team can validate image health before starting the rest of the services.

## What Changes

- Add a Harbor deployment (registry, portal, jobservice, chartmuseum, Trivy) to the compose repo, exposed as `https://registry.golum.io` and protected by the existing local CA.
- Provide a scripted bootstrap flow that starts only the Harbor services first, waits for them to become healthy, seeds an admin/project, and mirrors all container images required by the Moodle stack into Harbor.
- Update the remaining compose services so they pull images exclusively from the private Harbor registry once it is warmed up.
- Document the "Harbor first, then rest of stack" workflow so a developer can bring up the registry, synchronize images, review scan results, and finally launch Moodle using only the local registry.
- Enable Harbor's built-in vulnerability scanner (Trivy) and describe how scans automatically run on pushed images so the team can gate deployments.

## Impact

- Introduces a new Harbor capability spec plus documentation/scripts for the bootstrap workflow.
- Requires updates to the compose definitions so all services reference the Harbor registry (no direct pulls from Docker Hub).
- Ensures scanners run locally, so compose bring-up is slightly longer but no longer depends on external registries.
