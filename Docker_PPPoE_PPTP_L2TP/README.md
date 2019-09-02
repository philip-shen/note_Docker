# note_Docker
Take notes of Docker stuffs
# Table of Contents  
[Docker PPPoE](#docker-pppoe)  
[Docker PPTP](#docker-pptp)  
[Docker L2TP](#docker-l2tp)  
[PPTP vs L2TP vs OpenVPN ™ vs Chameleon ™ | VyprVPN](#pptp-vs-l2tp-vs-openvpn--vs-chameleon---vyprvpn)  

# accel-ppp-docker
[Fluke667/accel-ppp-docker](https://github.com/Fluke667/accel-ppp-docker)    


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
上面的就是配置了一个用户名 ety001 和 密码 123456 的用户，然后执行下面的命令就可以了，  

```
docker run -d --name pptp --restart always  --privileged -p 1723:1723 -v /etc/ppp/chap-secrets:/etc/ppp/chap-secrets mobtitude/vpn-pptp
```
最后检查下 tcp 1723 端口在防火墙上是否打开就可以了。  

# Docker L2TP
* [docker-ipsec-vpn-server ](https://github.com/hwdsl2/docker-ipsec-vpn-server)  

* [用 Docker 快速部署 PPTP VPN 和 L2TP + IPSEC VPN 2019-01-11](https://blog.domyself.me/2019/01/11/docker-pptp-vpn-l2tp-ipsec-vpn.html)  

使用的镜像是 hwdsl2/ipsec-vpn-server，需要先配置下用户名、密码和PSK，新建一个环境变量的文件 /etc/l2tp-env，内容如下  
```
VPN_IPSEC_PSK=abcdef
VPN_USER=ety001
VPN_PASSWORD=123456
```
上面的就是配置了一个用户名 ety001，密码 123456，PSK 为 abcdef 的用户，然后执行下面的命令就可以了，  

```
docker run --name ipsec-vpn-server --env-file /etc/l2tp-env --restart=always -p 500:500/udp -p 4500:4500/udp -v /lib/modules:/lib/modules:ro -d --privileged hwdsl2/ipsec-vpn-server
```
最后检查下 udp 500 和 udp 4500 端口在防火墙上是否打开就可以了。

# PPTP vs L2TP vs OpenVPN ™ vs Chameleon ™ | VyprVPN  
[VPN Protocol Comparison List - PPTP vs L2TP vs OpenVPN ™ vs Chameleon ™ | VyprVPN](http://www.giganews.com/vyprvpn/compare-vpn-protocols.html)  
![alt tag](https://camo.qiitausercontent.com/5372389fed1a63c0cb3b10e6c73cbe4942da8ecf/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f32353732382f64343832626232382d363066392d383036322d373931662d3434613637623964366665652e706e67)  

# Reference
* [用30天來介紹和使用 Docker 系列 2017-12-04](https://ithelp.ithome.com.tw/users/20103456/ironman/1320?page=1)  
* [docker-pppoe 15 Dec 2017](https://github.com/longwdl/docker-pppoe)  

* [dockerが起動しない（OCI runtime create failed: container_linux.go:344）2019-01-21](https://qiita.com/sakapun/items/750e4e9f40e372aa1e5b)  

* [PPTPサーバをつくる 2018-09-06](https://qiita.com/nanbuwks/items/e95df6f573844419de31)  
[Ubuntu 18.04 からつないでみる](https://qiita.com/nanbuwks/items/e95df6f573844419de31#ubuntu-1804-%E3%81%8B%E3%82%89%E3%81%A4%E3%81%AA%E3%81%84%E3%81%A7%E3%81%BF%E3%82%8B)  
![alt tag](https://camo.qiitausercontent.com/886fd10f5b3bafee7b8ced46ba88f45e4aa2951e/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f3133393532342f32336663633664622d313538372d326665652d346634612d6666356364636634363065362e706e67)

* [Ubuntu 14.04でpptpサーバの構築 2014-08-18](https://qiita.com/Amothic/items/b253bbea78e669a14bac)  
* [pptpd(今のところ接続できない。) 2015-06-19](https://qiita.com/tukiyo3/items/a3088de30d2faa8c1e93#gre%E3%82%AB%E3%83%BC%E3%83%8D%E3%83%AB%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%81%BF)  

```
PPTPはgre+1723に対応。(pptpd)
    gre IPプロトコル番号 :　47
    TCPポート番号 :　1723

IPSecは複数のプロトコルに対応。(strongswan)
    AH IPプロトコル番号　 :　51
    ESP IPプロトコル番号　 :　50
    IKE UDPポート番号　 :　500,4500

l2tp(xl2tpd
    UDPポート番号　 :　1701
```

* [如何在 Windows10 設定 PPTPVPN 客戶端連線 1月 19, 2019](https://blog.tomy168.com/2019/01/windows10-pptpvpn.html)  
* [GCP – 防火牆規則設定 2017-09-28](https://www.kilait.com/2017/09/28/gcp-%E9%98%B2%E7%81%AB%E7%89%86%E8%A6%8F%E5%89%87%E8%A8%AD%E5%AE%9A/)  
* [GCP 不想預設網路怎麼辦？自訂VPC不求人 2018-10-10](https://ithelp.ithome.com.tw/articles/10200670?sc=iThelpR)  
* [Setting up a VPN Server in 5 Minutes with Docker Oct 31, 2016](https://mobilejazz.com/blog/setting-up-a-vpn-server-in-5-minutes-with-docker/)  


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