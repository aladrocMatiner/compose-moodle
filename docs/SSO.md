# Single Sign-On (SSO) with Keycloak

This stack ships Keycloak at `https://sso.golum.io` (TLS terminated by HAProxy). Configure it with a realm and client for Moodle, then wire Moodle to use OAuth 2 / OIDC.

## 1) Configure Keycloak
1. Sign in to `https://sso.golum.io` with `KEYCLOAK_ADMIN_USER` / `KEYCLOAK_ADMIN_PASSWORD`.
2. Create a **realm** named `moodle` (or another name you prefer).
3. Create a **client** for Moodle:
   - Client ID: `moodle`
   - Client type: `OpenID Connect`
   - Access type: `confidential`
   - Standard flow: enabled
   - Root URL: `https://learn.golum.io`
   - Valid redirect URIs: `https://learn.golum.io/*`
   - Web origins: `https://learn.golum.io`
4. Save the client and obtain the **Client Secret** (Credentials tab).
5. Create at least one test user in the realm and set a password.

Useful discovery endpoints (replace `moodle` if you used a different realm name):
- Well-known: `https://sso.golum.io/realms/moodle/.well-known/openid-configuration`
- Authorization endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/auth`
- Token endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/token`
- Userinfo endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/userinfo`

## 2) Configure Moodle to use Keycloak (OAuth 2 / OIDC)
1. Sign in to Moodle as the admin user (from `.env`) at `https://learn.golum.io`.
2. Navigate to **Site administration → Server → OAuth 2 services**.
3. Create a **new custom service**:
   - Name: `Keycloak`
   - Client ID: `moodle`
   - Client secret: from the Keycloak client
   - Auth endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/auth`
   - Token endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/token`
   - Userinfo endpoint: `https://sso.golum.io/realms/moodle/protocol/openid-connect/userinfo`
   - Login domains: `sso.golum.io`
   - Enable `Allow login` / `Allow link` options.
4. Save and then run **Site administration → Server → OAuth 2 services → Connect to a system account** if prompted.
5. Test login: open `https://learn.golum.io` in a private window and choose the Keycloak login button; authenticate with the Keycloak user created earlier.

## Notes
- HAProxy handles TLS and forwards to Keycloak over HTTP. `KC_PROXY=edge` is set in the Keycloak container to respect forwarded headers.
- If you change hostnames, regenerate certificates and update the Keycloak `KC_HOSTNAME`, client redirect URIs, and Moodle OAuth endpoints accordingly.
