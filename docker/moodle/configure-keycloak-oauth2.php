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

// Ensure issuer record exists and is up to date.
$existing = $DB->get_record('oauth2_issuer', ['name' => 'Keycloak']);
if ($existing) {
    $issuer = $existing;
    $issuer->timemodified = $now;
    $issuer->usermodified = $admin->id;
    $issuer->image = $baseurl;
    $issuer->baseurl = $baseurl;
    $issuer->clientid = $clientid;
    $issuer->clientsecret = $clientsecret;
    $issuer->loginscopes = 'openid profile email';
    // Include offline_access so system accounts can upgrade tokens.
    $issuer->loginscopesoffline = 'openid profile email offline_access';
    $issuer->showonloginpage = issuer::EVERYWHERE;
    $issuer->loginpagename = 'Keycloak';
    $DB->update_record('oauth2_issuer', $issuer);
    $issuerid = $issuer->id;
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
    $issuer->loginscopesoffline = 'openid profile email offline_access';
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

// Relax cURL security so outbound calls to sso.golum.io (10.x) are not blocked.
$blocked = get_config('core', 'curlsecurityblockedhosts');
if (!empty($blocked)) {
    $lines = array_filter(array_map('trim', explode("\n", $blocked)));
    $lines = array_values(array_filter($lines, static function(string $line): bool {
        return $line !== '10.0.0.0/8';
    }));
    set_config('curlsecurityblockedhosts', implode("\n", $lines));
}

// Ensure default user field mappings exist for this issuer.
$DB->delete_records('oauth2_user_field_mapping', ['issuerid' => $issuerid]);

$mapping = [
    'given_name'   => 'firstname',
    'middle_name'  => 'middlename',
    'family_name'  => 'lastname',
    'email'        => 'email',
    'nickname'     => 'alternatename',
    'picture'      => 'picture',
    'address'      => 'address',
    'phone'        => 'phone1',
    'locale'       => 'lang',
];

foreach ($mapping as $external => $internal) {
    $record = new stdClass();
    $record->timecreated = $now;
    $record->timemodified = $now;
    $record->usermodified = $admin->id;
    $record->issuerid = $issuerid;
    $record->externalfield = $external;
    $record->internalfield = $internal;
    $DB->insert_record('oauth2_user_field_mapping', $record);
}

echo "Ensured Keycloak OAuth2 issuer (id {$issuerid}), endpoints, OAuth2 auth plugin, cURL security and user field mappings are configured.\n";
