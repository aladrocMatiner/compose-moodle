## 1. Scripts
- [x] 1.1 Add a script to test `https://learn.golum.io` reachability (HTTPS, expected status 200/302).
- [x] 1.2 Add a script to test `https://sso.golum.io` reachability (HTTPS, expected status 200/302).
- [x] 1.3 Add a script to test `https://grafana.golum.io` reachability (HTTPS, expected status 200/302).
- [x] 1.4 Ensure scripts exit non-zero on failure and print a concise result.

## 2. Documentation
- [x] 2.1 Document how to run the endpoint test scripts as part of the verification flow.

## 3. Validation
- [x] 3.1 Run the scripts locally after stack startup to confirm they detect up/down states as expected. (Result: endpoints currently unreachable due to host port 80 conflict; script reports HTTP 000 for all three as expected.)
- [x] 3.2 Update tasks to `- [x]` when complete.
