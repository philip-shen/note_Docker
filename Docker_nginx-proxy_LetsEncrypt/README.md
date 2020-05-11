
Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Purpose](#purpose)
   * [docker-letsencrypt-django-nginx-proxy-uwsgi-postgres](#docker-letsencrypt-django-nginx-proxy-uwsgi-postgres)
      * [Method 2](#method-2)
   * [LetsEncrypt and nginx-proxy-companion](#letsencrypt-and-nginx-proxy-companion)
      * [docker-compose.yml of test site](#docker-composeyml-of-test-site)
      * [docker-compose.yml of nginx-proxy](#docker-composeyml-of-nginx-proxy)
      * [Testing](#testing)
   * [Troubleshooting](#troubleshooting)
   * [Reference](#reference)
   * [h1 size](#h1-size)
      * [h2 size](#h2-size)
         * [h3 size](#h3-size)
            * [h4 size](#h4-size)
               * [h5 size](#h5-size)
   * [Table of Contents](#table-of-contents-1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# Purpose
Take note of letsencrypt and nginx-proxy-companion

# docker-letsencrypt-django-nginx-proxy-uwsgi-postgres  
[twtrubiks/docker-letsencrypt-django-nginx-proxy-uwsgi-postgres](https://github.com/twtrubiks/docker-letsencrypt-django-nginx-proxy-uwsgi-postgres)  

## Method 2  
```
明明一個 docker-compose 能解決的事情，為什麼要拆成兩個 docker-compose❓

原因是這種方法比較有彈性，如果我今天要加新的 docker container ( 加到 docker-compose 內 )，

可以直接另外寫一個 docker-compose，然後直接 run，nginx-proxy 以及 docker-letsencrypt-nginx-proxy-companion 會自動偵測

到這些 container，這樣就不用把原本的先停止 ( docker-compose down )，也比較好管理，不會一堆東西都塞在一起。

但這方法要多注意 networks 的部分，建議可先參考 docker-compose networks 說明 了解一下觀念。
```


# LetsEncrypt and nginx-proxy-companion  
[letsencrypt-nginx-proxy-companionを使って複数ドメイン名に無料SSL証明書を適用する posted at 2019-02-11](https://qiita.com/fukuyama012/items/5d4390ae4a34ba477cef)  

## docker-compose.yml of test site  
```
version: '3.3'
services:
  myapp:
    image: pbadhe34/my-apps:tomcat-web
    environment:
      VIRTUAL_HOST: example.com,www.example.com # ←　カンマ区切り指定
      LETSENCRYPT_HOST: example.com,www.example.com # ←　カンマ区切り指定
      LETSENCRYPT_EMAIL: mail@example.com

networks:
  default:
    external:
      name: shared
```

## docker-compose.yml of nginx-proxy  
```
version: "2"
services:
  nginx-proxy:
    image: jwilder/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./certs:/etc/nginx/certs:ro
      - /etc/nginx/vhost.d
      - /usr/share/nginx/html
    restart: always
    networks:
      - shared

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: letsencrypt
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./certs:/etc/nginx/certs:rw
    volumes_from:
      - nginx-proxy
    restart: always
    networks:
      - shared

networks:
  shared:
    external: true
```

## Testing  
> 1. 上記の様にdocker-compose.ymlを分離している場合は事前にDocker networkを作成し同じネットワークを利用する様に指定しておく必要が有る。  
```
docker network create --driver bridge shared
```

>2. nginx側、自作サービスの両方を起動する  
```
docker-compose up -d
```

> 3. 指定した保存ディレクトリ内に以下の様にドメイン名別の証明書が生成される。 どちらのドメイン名でもSSL接続可能となる。
```
example.com.chain.pem
example.com.crt
example.com.dhparam.pem
example.com.key

www.example.com.chain.pem
www.example.com.crt
www.example.com.dhparam.pem
www.example.com.key
```

```
1.  前提としてDNS設定済みの独自ドメインが必要です。 

2.  利用するドメイン名を事前に名前解決設定しておく必要有り。 
```


# Troubleshooting


# Reference

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

