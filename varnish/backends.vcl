backend server1 {
            .host = "nginx";
            .port = "80";
        }

import std;
import directors;
sub vcl_init {
    new backends_director = directors.round_robin();
backends_director.add_backend(server1);
}

sub vcl_recv {
    set req.backend_hint = backends_director.backend();
    }
