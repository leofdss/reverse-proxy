# reverse-proxy

$ docker-compose up -d --build

add configs to the "sites-available" directory

$ cd sites-enabled

$ ln -s ../sites-available/file .

$ docker exec <container-name> nginx -t
  
$ docker exec <container-name> nginx -s reload
  
$ docker exec <container-name> certbot --nginx
  
$ docker exec <container-name> certbot certonly --nginx
