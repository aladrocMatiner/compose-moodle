vcl 4.1;

import directors;

backend moodle1 {
    .host = "moodle1";
    .port = "80";
}

backend moodle2 {
    .host = "moodle2";
    .port = "80";
}

sub vcl_init {
    new lb = directors.round_robin();
    lb.add_backend(moodle1);
    lb.add_backend(moodle2);
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

    set req.backend_hint = lb.backend();

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
