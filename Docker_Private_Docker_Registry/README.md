Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Purpose](#purpose)
   * [Private Docker Registry Server Installation](#private-docker-registry-server-installation)
      * [Environment](#environment)
      * [Setup Procedures](#setup-procedures)
         * [1. SANの設定（OpenSSL）](#1-sanの設定openssl)
         * [2. 自己署名証明書の作成](#2-自己署名証明書の作成)
            * [1. 証明書、鍵ファイルの作成 : TLS通信のサーバ (Server)側の作業](#1-証明書鍵ファイルの作成--tls通信のサーバ-server側の作業)
            * [2. 証明書の配置、更新 : TLS通信のクライアント (Client)側の作業](#2-証明書の配置更新--tls通信のクライアント-client側の作業)
            * [3. dockerエンジン再起動](#3-dockerエンジン再起動)
         * [3. Basic認証設定](#3-basic認証設定)
            * [1. htpasswd（を含むパッケージ）インストール](#1-htpasswdを含むパッケージインストール)
            * [2. パスワードファイル作成](#2-パスワードファイル作成)
         * [4. registry起動](#4-registry起動)
            * [1. 起動用スクリプト準備](#1-起動用スクリプト準備)
            * [2. registryコンテナの起動](#2-registryコンテナの起動)
         * [5. 設定ファイルについて](#5-設定ファイルについて)
   * [Push Docker Image to Private Docker Registry Server](#push-docker-image-to-private-docker-registry-server)
   * [Pull Docker Image from Private Docker Registry Server at Another Site](#pull-docker-image-from-private-docker-registry-server-at-another-site)
   * [Query Docker Registry by Command Line Interface(CLI)](#query-docker-registry-by-command-line-interfacecli)
   * [Query Docker Registry by Web GUI](#query-docker-registry-by-web-gui)
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
Take note of Private Docker Registry  

# Private Docker Registry Server Installation  
[Day7：建立 private 的 Docker Registry 2017-12-10](https://ithelp.ithome.com.tw/articles/10191213)  

[Docker Registry v2設定(TLS) updated at 2019-11-22](https://qiita.com/niiku-y/items/df3dbcb3453e6f529e07)  
> registryとdockerホスト間でHTTP通信を使う場合は、docker-engineにinsecure-registry指定をするが、今回は指定せずHTTPS通信とする。 
> なので、TLSで暗号化するための証明書を作成する必要がある。  

## Environment  
* OS : Ubuntu 18.04  
* Docker-ce : 19.03.5  
* OpenSSL : 1.1.1  
   * 自己署名証明書を作成  
   * 通信のサーバ側、クライアント側としての設定作業を実施。OSにより作業ディレクトリやコマンドは変わるので、他OSでは読み替える  
* リバースプロキシ : 使わない構成（v1時のようにHTTPSのためのリバプロを用意したりしない）  

## Setup Procedures  
### 1. SANの設定（OpenSSL） 
```
$ ./add_san.sh

$ ./make_certs.sh

$ sudo diff /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.org
251,255d250
< subjectAltName=@alt_names
< [alt_names]
< DNS.1 = hyperv-ubuntu18.local
< IP.1 = 192.168.1.5
```
![alt tag](https://i.imgur.com/pw8UgFt.png)  

![alt tag](https://i.imgur.com/dJ73eOG.png)  

### 2. 自己署名証明書の作成

#### 1. 証明書、鍵ファイルの作成 : TLS通信のサーバ (Server)側の作業  
```
$ openssl req -newkey rsa:4096 -nodes -keyout certs/hyperv-ubuntu18.local.key \
-x509 -days 365 -out certs/hyperv-ubuntu18.local.crt
-----
Country Name (2 letter code) [AU]: （未入力）
State or Province Name (full name) [Some-State]:（未入力）
Locality Name (eg, city) []:（未入力）
Organization Name (eg, company) [Internet Widgits Pty Ltd]:（未入力）
Organizational Unit Name (eg, section) []:（未入力）
Common Name (e.g. server FQDN or YOUR name) []:<myregistry>（Docker Resistryがあるノードのドメインを入力）
Email Address []:（未入力）
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:（未入力）
An optional company name []:（未入力）
```

```
$ ls -l certs/

$ openssl x509 -text -noout -in certs/hyperv-ubuntu18.local.crt
```
![alt tag](https://i.imgur.com/5rQdFOV.png)  

#### 2. 証明書の配置、更新 : TLS通信のクライアント (Client)側の作業  
```
TLS通信のクライアント側の作業として、証明書を所定の場所（OSごとで違う）に配置し、
証明書を更新するコマンド（これもOSごとで違う）を実行する。

以下は今回のubuntu 18.04の場合。
```

```
$ sudo cp -p certs/hyperv-ubuntu18.local.crt /usr/share/ca-certificates/hyperv-ubuntu18.local.crt

$ sudo cp -p /etc/ca-certificates.conf /etc/ca-certificates.conf.org

$ sudo vi /etc/ca-certificates.conf

$ sudo diff /etc/ca-certificates.conf /etc/ca-certificates.conf.org 
```
![alt tag](https://i.imgur.com/uqJxxr3.png)  

#### 3. dockerエンジン再起動  
```
$ sudo systemctl restart docker 
```

### 3. Basic認証設定  
#### 1. htpasswd（を含むパッケージ）インストール   
```
$ sudo apt install -y apache2-utils
$ sudo dpkg -l apache2-utils
```
![alt tag](https://i.imgur.com/NncuncR.png)  

#### 2. パスワードファイル作成  
* -nで標準出力に出力
* -Bでbcryptによる暗号化
* -bでバッチモード（インタラクティブに対するバッチ）

```
$ mkdir auth
$ htpasswd -Bbn username password > auth/htpasswd

$ ls -l auth/htpasswd
$ cat auth/htpasswd
```
![alt tag](https://i.imgur.com/4loHBux.png)

### 4. registry起動  

#### 1. 起動用スクリプト準備  

* -d：コンテナをバックグラウンドで起動します。
* -p：ホスト側のポートとコンテナ側のポートをマッピングします。<host_port>:<container_port>
* -v：コンテナのボリュームをホストにマウントします。<host_volume>:<container_volume>
* -e：コンテナに環境変数を設定します。

```
$ sudo nano run_registry.sh

$ chmod +x run_registry.sh

$ cat run_registry.sh
#!/bin/bash
# run_registry.sh

#export PROXY_SERVER=proxy_server
#export PROXY_PORT=8080
#export NO_PROXY=127.0.0.1,localhost,192.168.0.1

export REGISTRY_PORT=8443

sudo docker run -d \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/hyperv-ubuntu18.local.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/hyperv-ubuntu18.local.key \
  -p ${REGISTRY_PORT}:443 \
  -v $(pwd)/certs:/certs \
  -v $(pwd)/auth:/auth \
  --restart=always \
  --name registry \
  registry:2.7

#  -e HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT} \
#  -e HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT} \
#  -e NO_PROXY=${NO_PROXY} \
```

#### 2. registryコンテナの起動  
```
$ ./run_registry.sh 
```
![alt tag](https://i.imgur.com/rwrTso4.png)  

```
$ sudo docker ps -a

CONTAINER ID        IMAGE                     COMMAND                  CREATED              STATUS                          PORTS                                            NAMES
f282c5c3a414        registry:2.7              "/entrypoint.sh /etc…"   About a minute ago   Up About a minute               5000/tcp, 0.0.0.0:8443->443/tcp                  registry
```
![alt tag](https://i.imgur.com/3WyM3q0.png)  

```
$ sudo docker login hyperv-ubuntu18.local:8443
```
![alt tag](https://i.imgur.com/MUvDNC3.png)  

### 5. 設定ファイルについて
[設定リファレンス](http://docs.docker.jp/registry/configuration.html)
> 設定リファレンス によると、既に環境変数で設定変更するのは推奨されない手法となっているようだ。 

```
$ cat config.yml
version: 0.1

log:
  level: debug
  formatter: text

storage:
  filesystem:
    rootdirectory: /var/lib/registry

auth:
  htpasswd:
    realm: basic-realm
    path: /auth/htpasswd

http:
  addr: 0.0.0.0:443
  host: https://hyperv-ubuntu18.local
  secret: mysecretstring
  tls:
    certificate: /certs/hyperv-ubuntu18.local.crt
    key: /certs/hyperv-ubuntu18.local.key

#proxy:
#  remoteurl: https://registry-1.docker.io
#  username: username
#  password: password

# end of file
```
![alt tag](https://i.imgur.com/pfbvyHs.png)  

```
#!/bin/bash
# run_registry2.sh

export REGISTRY_PORT=8443

sudo docker run -d \
  -v $(pwd)/config.yml:/etc/docker/registry/config.yml \
  -p ${REGISTRY_PORT}:443 \
  -v $(pwd)/certs:/certs \
  -v $(pwd)/auth:/auth \
  --restart=always \
  --name registry \
  registry:2.7
```
![alt tag](https://i.imgur.com/4iNfXkM.png)  

> 起動スクリプトではホスト側のポート8443を指定していたので、レジストリへのログインのときもこの8443を指定する。

```
sudo docker login hyperv-ubuntu18.local:8443
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/test/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
![alt tag](https://i.imgur.com/puelLJE.png)


[プライベートDocker Registryの構築方法 Dec 03, 2019](https://qiita.com/user_h/items/302b71838aae7085b4e4)  
> 環境 

```
ubuntu 18.04
docker-ce 19.03.4
OpenSSL 1.1.0g
```

> 秘密鍵の作成  
```
秘密鍵の名前をserver.keyとします。
```
```
$ openssl genrsa -aes256 -out <server.key> 2048  
Generating RSA private key, 2048 bit long modulus
....................+++++
...........................+++++
e is 65537 (0x010001)
Enter pass phrase for <server.key>:（任意のパスフレーズ）
Verifying - Enter pass phrase for <server.key>:
```

> 秘密鍵のパスワードを削除  

```
$ openssl rsa -in <server.key> -out <server.key> -passin pass:（秘密鍵のパスワード）
```

> 証明書発行要求の作成 
```
証明書発行要求の名前をserver.csrとします。
```
```
$ openssl req -new -key <server.key> -out <server.csr>

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]: （未入力）
State or Province Name (full name) [Some-State]:（未入力）
Locality Name (eg, city) []:（未入力）
Organization Name (eg, company) [Internet Widgits Pty Ltd]:（未入力）
Organizational Unit Name (eg, section) []:（未入力）
Common Name (e.g. server FQDN or YOUR name) []:<myregistry>（Docker Resistryがあるノードのドメインを入力）
Email Address []:（未入力）
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:（未入力）
An optional company name []:（未入力）
```

> 自己証明書作成  
```
証明書の名前をserver.crtとします。
```
```
$ openssl x509 -days 3650 -in <server.csr> -req -signkey <server.key> -out <server.crt>
Signature ok
subject=C = AU, ST = Some-State, O = Internet Widgits Pty Ltd, CN = <myregistry>
Getting Private key
```

[オレだよオレオレ認証局で証明書つくる updated at 2019-12-18](https://qiita.com/ll_kuma_ll/items/13c962a6a74874af39c6)  

> 鍵の種類 

[鍵の種類](https://qiita.com/ll_kuma_ll/items/13c962a6a74874af39c6#%E9%8D%B5%E3%81%AE%E7%A8%AE%E9%A1%9E)  

拡張子 | ざっくりした内容
------------------------------------ | --------------------------------------------- 
.pem | rsa暗号方式をで暗号化されたファイルを現したもので、鍵の種類を表しているわけではない
.key | もれたら危険が危ない秘密鍵
.csr | 証明書発行要求のファイル
.crt | 認証局が署名した証明書のファイル



# Push Docker Image to Private Docker Registry Server  
[Day7：建立 private 的 Docker Registry 2017-12-10](https://ithelp.ithome.com.tw/articles/10191213)  
```
$ sudo docker tag hello-world hyperv-ubuntu18.local:8443/hello-world
```
![alt tag](https://i.imgur.com/guQrRoq.png)  

```
$ ./run_registry.sh 

$ sudo docker logout hyperv-ubuntu18.local:8443

$ sudo docker login hyperv-ubuntu18.local:8443

$ sudo docker push hyperv-ubuntu18.local:8443/hello-world
```
![alt tag](https://i.imgur.com/Ep0OQm5.png)  


# Pull Docker Image from Private Docker Registry Server at Another Site   
[Day7：建立 private 的 Docker Registry 2017-12-10](https://ithelp.ithome.com.tw/articles/10191213)  
[]()  
[]()  

[Private Docker RegistryからPullできないとき  Apr 09, 2020](https://qiita.com/hakuaneko/items/342d974434a44b8c2797)  
> 会社とかで立ててるプライベートなDocoker RegistryからPullできずこんなメッセージが、、、  

```
unauthorized: authentication required
```

> ログインするには？  

```
docker login -p [ユーザーパスワード] -u [ユーザー名] [サーバ名]
```

> Private Docker Registryからログアウトするときは 

```
docker logout [サーバ名]
```

# Query Docker Registry by Command Line Interface(CLI)  
[Day8：查詢 Docker Registry 的資訊 2017-12-11](https://ithelp.ithome.com.tw/articles/10191285)  
[]()  

```
https://hyperv-ubuntu18.local:8443/v2/_catalog
```
![alt tag](https://i.imgur.com/7HW1Tvx.png)  

![alt tag](https://i.imgur.com/1NnkLDt.png)  

```
https://hyperv-ubuntu18.local:8443/v2/hello-world/tags/list
```
```
https://hyperv-ubuntu18.local:8443/v2/hello-world/manifests/lastest
```
![alt tag](https://i.imgur.com/wPKBKI4.png)  

# Query Docker Registry by Web GUI   
[Day8：查詢 Docker Registry 的資訊 2017-12-11](https://ithelp.ithome.com.tw/articles/10191285)  
使用 hyper/docker-registry-web 所提供的 Docker Web UI 工具來顯示 Docker Registry 放了哪些Docker Image  

[Docker プライベートレジストリのWebUI調査 (1)](https://qiita.com/rururu_kenken/items/4ab319877dcdd750b2ab)  
hyper/docker-registry-web

[Docker プライベートレジストリのWebUI調査 (2)](https://qiita.com/rururu_kenken/items/ff9b5b755d7c5735065e)  
klausmeyer/docker-registry-browser  

[Docker プライベートレジストリのWebUI調査 (3)](https://qiita.com/rururu_kenken/items/996076daaea11e657995)  
jc21/registry-ui  

[Docker プライベートレジストリのWebUI調査 (4) updated at 2020-03-29](https://qiita.com/rururu_kenken/items/fb7e6758a3fa60a83314)  
joxit/docker-registry-ui

[Docker プライベートレジストリのWebUI調査 (5) updated at 2020-03-29](https://qiita.com/rururu_kenken/items/b5b6b754774d76b08c53)
parabuzzle/craneoperator  

[Docker プライベートレジストリのWebUI調査 (6) updated at 2020-03-29](https://qiita.com/rururu_kenken/items/530ef38fe0342d6e2bfa)  
konradkleine/docker-registry-frontend


[]()  
[]()  

# Troubleshooting


# Reference
[Docker Registry 2使ってみた updated at 2015-11-08](https://qiita.com/tukiyo3/items/2ca5b1eddd455e333016)  


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



