FROM nginx
COPY ./config/nginx.conf /etc/nginx/nginx.conf
RUN apt-get update
RUN apt-get install certbot python3-certbot-nginx -y