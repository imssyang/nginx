server {
    listen       80;
    server_name  imss.cc;

    location / {
        root   html;
        index  index.html index.htm index.php;
    }

    location ^~ /.well-known/acme-challenge {
        alias  html/acme;
    }

    location ~ ^/sample/?(.*)$ {
        alias sample;
        try_files /flv/$1 /mp4/$1;
        add_header Access-Control-Allow-Credentials true;
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
    }

    location ^~ /hls {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }

        alias hls;
        allow all;
        add_header Access-Control-Allow-Credentials true;
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods 'GET,POST,OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
    }

    # For v2ray-plugin for test
    location /vs {
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_pass http://127.0.0.1:61080; 
        proxy_set_header Host $http_host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

server {
    listen       443 ssl http2;
    server_name  imss.cc;

    ssl_certificate     $ssl_imss_cc_cer;
    ssl_certificate_key $ssl_imss_cc_key;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_session_cache   shared:SSL:1m;
    ssl_session_tickets on;
    ssl_session_timeout 5m;

    location / {
        root   html;
        index  index.html index.htm;
    }

    location ~ ^/sample/?(.*)$ {
        alias sample;
        try_files /flv/$1 /mp4/$1;
        add_header Access-Control-Allow-Credentials true;
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
    }

    # For v2ray-plugin
    location /vs {
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_pass http://127.0.0.1:61080; 
        proxy_set_header Host $http_host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

