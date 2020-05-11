Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Purpose](#purpose)
   * [Portainer.io](#portainerio)
      * [Deploy Portainer Server](#deploy-portainer-server)
      * [PORTAINER AGENT DEPLOYMENTS ONLY](#portainer-agent-deployments-only)
      * [Login and Account Creatrion](#login-and-account-creatrion)
   * [Private docker registry](#private-docker-registry)
      * [Setup Procedures](#setup-procedures)
   * [Portainer + Sub Domain + HTTPs](#portainer--sub-domain--https)
      * [Settings](#settings)
      * [Register SubDomains](#register-subdomains)
      * [docker-compose.yml](#docker-composeyml)
         * [nginx-proxy, letsencrypt (必須)](#nginx-proxy-letsencrypt-必須)
         * [portainer (必須)](#portainer-必須)
         * [minecraft (任意)](#minecraft-任意)
      * [Execution](#execution)
   * [Troubleshooting](#troubleshooting)
   * [Reference](#reference)
      * [GUI: Portainer](#gui-portainer)
   * [h1 size](#h1-size)
      * [h2 size](#h2-size)
         * [h3 size](#h3-size)
            * [h4 size](#h4-size)
               * [h5 size](#h5-size)
   * [Table of Contents](#table-of-contents-1)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)


# Purpose
Take note of Portainer.io  

# Portainer.io   
[Portainer.io  2019-09-24](https://ithelp.ithome.com.tw/articles/10214585)  

## Deploy Portainer Server  
```
$ docker volume create portainer_data
$ docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```

## PORTAINER AGENT DEPLOYMENTS ONLY  
```
docker service create --name portainer_agent --network portainer_agent_network --publish mode=host,target=9001,published=9001 -e AGENT_CLUSTER_ADDR=tasks.portainer_agent --mode global --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes –-mount type=bind,src=/,dst=/host portainer/agent
```

## Login and Account Creatrion   
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403Ja1FgmCc71.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403Ia08RIMAo4.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403rmboOoIUVb.png)  

# Private docker registry  
[Private docker registry 2019-09-25](https://ithelp.ithome.com.tw/articles/10217364)  

## Setup Procedures  
> 放在ssd  

```
icekimo@Kris:~$ sudo mkdir /media/nvme0n1p1/registry
icekimo@Kris:~$ sudo docker run -d -p 5000:5000 -v /media/nvme0n1p1/storage:/var/lib/registry --name registry registry:2

Unable to find image 'registry:2' locally
2: Pulling from library/registry
c87736221ed0: Pull complete
1cc8e0bb44df: Pull complete
54d33bcb37f5: Pull complete
e8afc091c171: Pull complete
b4541f6d3db6: Pull complete
Digest: sha256:8004747f1e8cd820a148fb7499d71a76d45ff66bac6a29129bfdbfdc0154d146
Status: Downloaded newer image for registry:2
e5d39198730e7a93cd7f41f7626338505d4c1e9449a1098aede5048947668e4b
icekimo@Kris:~$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                                            NAMES
e5d39198730e        registry:2            "/entrypoint.sh /etc…"   4 seconds ago       Up 3 seconds        0.0.0.0:5000->5000/tcp                           registry
255531a6efde        portainer/portainer   "/portainer"             4 hours ago         Up 4 hours          0.0.0.0:8000->8000/tcp, 0.0.0.0:9000->9000/tcp   boring_poincare
```
> Find out IP
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403TwaAcGSN2m.png)  

> Regist registry
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403MtJpiqKxXI.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403ip9R01WUfb.png)  

> --restart=always  
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403hMDLRoaHya.png)  

> Private registry
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403jrRNAL1vjw.png)  


# Portainer + Sub Domain + HTTPs  
[Docker サーバ管理 なるべく楽に サブドメインありhttpsあり updated at 2019-11-16](https://qiita.com/sumeshi/items/a40c162e4c53623ecc48)  

## Settings  
* DNSへサブドメインの登録  
* docker-composeファイルの作成, 起動  
* portainerへのアクセス  

## Register SubDomains  
![alt tag](https://qiita-user-contents.imgix.net/https%3A%2F%2Fi.gyazo.com%2Fa06992fb8e92e3268be6c6382eeb3cdd.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&s=5ee9192e10d991fd1d2f5a1d98dd2724)  

## docker-compose.yml  
### nginx-proxy, letsencrypt (必須)  
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

### portainer (必須)  
```
version: '3.3'
services:
  portainer:
    image: portainer/portainer
    command: -H unix:///var/run/docker.sock
    ports:
      - 8000:8000
      - 9000:9000
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    environment:
      VIRTUAL_PORT: 9000
      VIRTUAL_HOST: <portainerに割り当てたいサブドメイン>
      LETSENCRYPT_HOST: <portainerに割り当てたいサブドメイン>
      LETSENCRYPT_EMAIL: <メールアドレス(ドメインのhttps化に必要です)>

networks:
  default:
    external:
      name: shared

volumes:
  portainer_data:
```

### minecraft (任意)  
```
version: '3.3'
services:
  mc:
    image: itzg/minecraft-server
    ports:
      - 25565:25565
    restart: always
    volumes:
      - "./mc-data:/data"
    environment:
      EULA: "true"
      VERSION: 1.14.4
      VIRTUAL_PORT: 25565
      VIRTUAL_HOST: <minecraftに割り当てたいサブドメイン>
      LETSENCRYPT_HOST: <minecraftに割り当てたいサブドメイン>
      LETSENCRYPT_EMAIL: <メールアドレス(ドメインのhttps化に必要です)>

networks:
  default:
    external:
      name: shared
```

## Execution  
```
$ docker-compose up -d
```


# Troubleshooting


# Reference

## GUI: Portainer
[DockerにおけるGUI管理(Portainer 導入編) 2019/07/02](https://www.nedia.ne.jp/blog/2019/07/02/14868)  
```
5 Portainer による管理

        5.0.1 管理ユーザの登録
        5.0.2 管理対象 Docker ホストの登録
        5.0.3 サンプル用Dockerイメージの入手
        5.0.4 コンテナの起動
        5.0.5 コンソール接続
```

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
