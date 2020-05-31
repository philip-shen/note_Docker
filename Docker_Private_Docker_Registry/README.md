Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Purpose](#purpose)
   * [Private Docker Registry Server Installation](#private-docker-registry-server-installation)
      * [Environment](#environment)
      * [Setup Procedures](#setup-procedures)
         * [1. SANの設定（OpenSSL）](#1-sanの設定openssl)
         * [2. 自己署名証明書の作成](#2-自己署名証明書の作成)
            * [1. 証明書、鍵ファイルの作成 : TLS通信のサーバ側の作業](#1-証明書鍵ファイルの作成--tls通信のサーバ側の作業)
            * [2. 証明書の配置、更新 : TLS通信のクライアント側の作業](#2-証明書の配置更新--tls通信のクライアント側の作業)
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
$ ./make_certs.sh

$ ./add_san.sh

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

#### 1. 証明書、鍵ファイルの作成 : TLS通信のサーバ側の作業  
```
$ openssl req -newkey rsa:4096 -nodes -keyout certs/hyperv-ubuntu18.local.key -x509 -days 365 -out certs/hyperv-ubuntu18.local.crt

```

```
$ ls -l certs/

$ openssl x509 -text -noout -in certs/hyperv-ubuntu18.local.crt
```
![alt tag](https://i.imgur.com/5rQdFOV.png)  

#### 2. 証明書の配置、更新 : TLS通信のクライアント側の作業  
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
#### 2. パスワードファイル作成 

### 4. registry起動 
#### 1. 起動用スクリプト準備  
#### 2. registryコンテナの起動  

### 5. 設定ファイルについて

```

```


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
[]()  

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

