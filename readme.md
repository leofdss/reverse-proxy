# Reverse proxy

### add proxy config on ./config/etc/nginx/sites-enabled/tizza
```
server {
  server_name app.tizza.com.br;

  location / {
    client_max_body_size 2G;
    proxy_pass http://ip_private:4300;
    proxy_http_version 1.1;
    proxy_cache_bypass $http_upgrade;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location ^~/.well-known/acme-challenge/ {
    root /var/www/certbot;
  }
}
```

### Start nginx
```
docker-compose up -d
```

### Generate certificate
```
docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d app.tizza.com.br
```

### Result
```
Account registered.
Requesting a certificate for app.tizza.com.br

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/app.tizza.com.br/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/app.tizza.com.br/privkey.pem
This certificate expires on 2022-05-26.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

```

### add certificate
```
server {
  server_name app.tizza.com.br;

  location / {
    client_max_body_size 2G;
    proxy_pass http://172.31.37.80:4300;
    proxy_http_version 1.1;
    proxy_cache_bypass $http_upgrade;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Port $server_port;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location ^~/.well-known/acme-challenge/ {
    root /var/www/certbot;
  }

  listen 443 ssl;
  ssl_certificate /etc/letsencrypt/live/app.tizza.com.br/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/app.tizza.com.br/privkey.pem;
}

# Redirect http -> https
server {
  if ($host = app.tizza.com.br) {
    return 301 https://$host$request_uri;
  }

  server_name app.tizza.com.br;
  listen 80;
  return 404;
}
```