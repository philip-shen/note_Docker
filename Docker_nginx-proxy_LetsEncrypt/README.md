Table of Contents  
=================


# Purpose


# Troubleshooting


# Reference
[letsencrypt-nginx-proxy-companionを使って複数ドメイン名に無料SSL証明書を適用する posted at 2019-02-11](https://qiita.com/fukuyama012/items/5d4390ae4a34ba477cef)  
[Dockerで簡単にマルチドメインかつSSL証明（自動更新） nginx-proxyとLetsEncrypt updated at 2018-11-15](https://qiita.com/pipinosuke/items/e35368711c845b04fde7)  
```
nginx-proxy:
image: jwilder/nginx-proxy
container_name: nginx-proxy
privileged: true
ports:
- 80:80
- 443:443
volumes:
- ./docker-compose.d/certs:/etc/nginx/certs:ro
- ./docker-compose.d/htpasswd:/etc/nginx/htpasswd
- /etc/nginx/vhost.d
- /usr/share/nginx/html
- /var/run/docker.sock:/tmp/docker.sock:ro
restart: always

letsencrypt-nginx:
image: jrcs/letsencrypt-nginx-proxy-companion
container_name: letsencrypt-nginx
privileged: true
volumes:
- ./docker-compose.d/certs:/etc/nginx/certs:rw
- /var/run/docker.sock:/var/run/docker.sock:ro
volumes_from:
- nginx-proxy
restart: always
```

```
dockerAコンテナをrun
$ docker run -e VIRTUAL_HOST=a.com -e LETSENCRYPT_HOST=a.com -e LETSENCRYPT_EMAIL=アドレス 
```



[]()  


* []()  
![alt tag]()  

# h1 size

## h2 size

### h3 size

#### h4 size

##### h5 size

*strong*strong  
**strong**strong  

> quote  
> quote

- [ ] checklist1
- [x] checklist2

* 1
* 2
* 3

- 1
- 2
- 3
