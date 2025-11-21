vcl 4.1;

backend default {
    .host = "haproxy";
    .port = "8080";
}

acl purge {
    "localhost";
    "127.0.0.1";
    "haproxy";
}

sub vcl_recv {
    if (client.ip !~ purge && req.method == "PURGE") {
        return (synth(405, "Not allowed."));
    }
    if (req.method == "PURGE") {
        return (purge);
    }

sub vcl_recv {
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }

    if (req.http.Authorization) {
        return (pass);
    }

    # Bypass caching for authenticated sessions.
    if (req.http.Cookie) {
        if (req.http.Cookie ~ "MoodleSession") {
            return (pass);
        }
    }

    # Allow caching of static assets.
    if (req.url ~ "\\.(css|js|png|jpg|jpeg|gif|svg|ico|woff|woff2)$") {
        unset req.http.Cookie;
        return (hash);
    }

    return (pass);
}

sub vcl_backend_response {
    if (bereq.url ~ "\\.(css|js|png|jpg|jpeg|gif|svg|ico|woff|woff2)$") {
        set beresp.ttl = 10m;
        set beresp.grace = 5m;
        return (deliver);
    }

    set beresp.ttl = 0s;
    return (pass);
}

sub vcl_deliver {
    return (deliver);
}
