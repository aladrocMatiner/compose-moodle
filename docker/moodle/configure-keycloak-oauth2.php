<?php
// Local CLI helper to configure Moodle OAuth2 issuer for Keycloak.

define('CLI_SCRIPT', true);

require_once('/var/www/html/config.php');

use core\oauth2\issuer;

global $DB;

$realm = getenv('KEYCLOAK_REALM') ?: 'moodle';

// For local development we use a fixed client id/secret matching the Keycloak realm import.
$clientid = getenv('KEYCLOAK_MOODLE_CLIENT_ID') ?: 'moodle';
$clientsecret = getenv('KEYCLOAK_MOODLE_CLIENT_SECRET') ?: 'moodle-client-secret';

$baseurl = "https://sso.golum.io/realms/{$realm}";

$now = time();
$admin = get_admin();

// Ensure issuer record exists.
$existing = $DB->get_record('oauth2_issuer', ['name' => 'Keycloak']);
if ($existing) {
    $issuerid = $existing->id;
} else {
    $issuer = new stdClass();
    $issuer->timecreated = $now;
    $issuer->timemodified = $now;
    $issuer->usermodified = $admin->id;
    $issuer->name = 'Keycloak';
    $issuer->image = $baseurl;
    $issuer->baseurl = $baseurl;
    $issuer->clientid = $clientid;
    $issuer->clientsecret = $clientsecret;
    $issuer->loginscopes = 'openid profile email';
    $issuer->loginscopesoffline = 'openid profile email';
    $issuer->loginparams = '';
    $issuer->loginparamsoffline = '';
    $issuer->alloweddomains = '';
    $issuer->scopessupported = null;
    $issuer->enabled = 1;
    $issuer->showonloginpage = issuer::EVERYWHERE;
    $issuer->basicauth = 0;
    $issuer->sortorder = 0;
    $issuer->requireconfirmation = 1;
    $issuer->servicetype = null;
    $issuer->loginpagename = 'Keycloak';
    $issuer->systememail = null;

    $issuerid = $DB->insert_record('oauth2_issuer', $issuer);
}

// Add core endpoints for Keycloak OIDC.
$endpoints = [
    'authorization_endpoint' => "https://sso.golum.io/realms/{$realm}/protocol/openid-connect/auth",
    'token_endpoint' => "https://sso.golum.io/realms/{$realm}/protocol/openid-connect/token",
    'userinfo_endpoint' => "https://sso.golum.io/realms/{$realm}/protocol/openid-connect/userinfo",
];

foreach ($endpoints as $name => $url) {
    $existingendpoint = $DB->get_record('oauth2_endpoint', ['issuerid' => $issuerid, 'name' => $name]);
    if ($existingendpoint) {
        continue;
    }
    $endpoint = new stdClass();
    $endpoint->timecreated = $now;
    $endpoint->timemodified = $now;
    $endpoint->usermodified = $admin->id;
    $endpoint->name = $name;
    $endpoint->url = $url;
    $endpoint->issuerid = $issuerid;
    $DB->insert_record('oauth2_endpoint', $endpoint);
}

// Ensure OAuth2 authentication plugin is enabled alongside manual auth.
$auth = get_config('core', 'auth');
if (empty($auth)) {
    $auth = 'manual';
}
$authplugins = array_filter(array_map('trim', explode(',', $auth)));
if (!in_array('oauth2', $authplugins, true)) {
    $authplugins[] = 'oauth2';
    set_config('auth', implode(',', $authplugins));
}

echo "Ensured Keycloak OAuth2 issuer (id {$issuerid}), endpoints and OAuth2 auth plugin are configured.\n";
