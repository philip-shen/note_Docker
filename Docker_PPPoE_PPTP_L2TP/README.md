# note_Docker
Take notes of Docker stuffs

# Docker PPPoE  

# Docker PPTP  
* [mobtitude/docker-vpn-pptp Latest commit on 9 Nov 2018](https://github.com/mobtitude/docker-vpn-pptp)  
## Starting VPN server  
To start VPN server as a docker container run:  
```
docker run -d --privileged -p 1723:1723 -v {local_path_to_chap_secrets}:/etc/ppp/chap-secrets mobtitude/vpn-pptp
```

## Docker 1.7.x and connection issues  
After upgrading from Docker 1.3.0 to Docker 1.7.1 the containers started from image mobtitude/vpn-pptp stopped accepting connections to VPN without any reason. Connections were dropped after timeout.  

It looked like Docker deamon didn't forward packets for GRE protocol to container.  

One of the possible solutions is to start container with networking mode set to host by adding param --net=host to run command:
```
docker run -d --privileged --net=host -v {local_path_to_chap_secrets}:/etc/ppp/chap-secrets mobtitude/vpn-pptp
```
Note: Before starting container in --net=host mode, please read how networking in host mode works in [Docker](https://docs.docker.com/reference/run/#mode-host)  

* [用 Docker 快速部署 PPTP VPN 和 L2TP + IPSEC VPN 2019-01-11](https://blog.domyself.me/2019/01/11/docker-pptp-vpn-l2tp-ipsec-vpn.html)  

使用的镜像是 mobtitude/vpn-pptp，首先需要把用户名和密码配置一下，打开 /etc/ppp/chap-secrets，  
```
# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
ety001         *          123456              *
```

# Docker L2TP
* [用 Docker 快速部署 PPTP VPN 和 L2TP + IPSEC VPN 2019-01-11](https://blog.domyself.me/2019/01/11/docker-pptp-vpn-l2tp-ipsec-vpn.html)  


# Reference
* [用30天來介紹和使用 Docker 系列 2017-12-04](https://ithelp.ithome.com.tw/users/20103456/ironman/1320?page=1)  
* [docker-pppoe 15 Dec 2017](https://github.com/longwdl/docker-pppoe)  

* [dockerが起動しない（OCI runtime create failed: container_linux.go:344）2019-01-21](https://qiita.com/sakapun/items/750e4e9f40e372aa1e5b)  


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