# note_Docker
Take notes of Docker on Ubuntu stuffs

# Table of Contents  
[LinuxにDockerをインストールする](#linux%E3%81%ABdocker%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)  
[Ubuntu Server 16.04でDockerを動かす](#ubuntu-server-1604%E3%81%A7docker%E3%82%92%E5%8B%95%E3%81%8B%E3%81%99)  

[Ubuntu16.04にDocker CEをインストール](#ubuntu1604%E3%81%ABdocker-ce%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)  
[Prerequirement](#prerequirement)  
[Installation](#installation)  
[Attention](#attention)  
[Troubleshooting](#troubleshooting)  

[How do I install Docker on Ubuntu 16.04 LTS?](#how-do-i-install-docker-on-ubuntu-1604-lts)  

[How to Install and Use Docker Compose on Ubuntu 16.04 /18.04](#how-to-install-and-use-docker-compose-on-ubuntu-1604-1804)  
[Dockerでpython3 and iperf3環境を準備する](#docker%E3%81%A7python3-and-iperf3%E7%92%B0%E5%A2%83%E3%82%92%E6%BA%96%E5%82%99%E3%81%99%E3%82%8B)  

[Reference](#reference)  

# LinuxにDockerをインストールする  
[LinuxにDockerをインストールする updated at 2019-02-12](https://qiita.com/yoshiyasu1111/items/f2cab116d68ed1a0ce13)  
## Prerequisites (環境)  
  Ubuntu 18.04 and lubuntu 18.04 and CentOS 7.5
  Docker 18.06.1、18.09.2

## 古いバージョンの削除  
```
apt-get remove docker docker-engine docker.io
```

## dockerリポジトリの設定
必要なパッケージをインストールします。  
```
# apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
GPG鍵の入手  
```
~$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key  add -
```

## リポジトリの登録  
リポジトリを登録した後、リポジトリの設定ファイルが作成されたことを確認しています。  
```
~# add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

~$ cat /etc/apt/sources.list | grep docker
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
# deb-src [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
```

## Dockerのインストール  
docker-ceパッケージをインストールすればよいのですが、インストールするバージョンを指定できるらしいので、寄り道してやってみました。  

### インストール可能なdocker-ceのバージョンを調べる。  
```
$ apt-cache madison docker-ce
docker-ce | 18.06.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
docker-ce | 18.06.0~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
docker-ce | 18.03.1~ce~3-0~ubuntu | https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
```

## Dockerのインストール  
バージョンを指定してインストールしています。インストール後dockerコマンドを実行してインストールできたか確認をしています。
```
~# apt install docker-ce=18.06.1~ce~3-0~ubuntu

~$ docker --version
Docker version 18.06.1-ce, build e68fc7a
```
インストール途中で、リポジトリの鍵をインポートするか聞かれるのでyと答えてインポートする。  
## Dockerの実行  

### Dockerデーモンの起動  
```
~$ systemctl status docker
● docker.service - Docker Application Container Engine
Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: e
Active: active (running) since Mon 2018-09-17 11:54:00 JST; 3min 40s ago
    Docs: https://docs.docker.com
Main PID: 17466 (dockerd)
```

### 一般ユーザでDockerを実行できるようにする  
Dockerを実行するたびにsudoをしなくて済むように一般ユーザをdockerグループに所属させます。  

  Ubuntu、lubuntu、CentOS共通  

  初期状態ではdockerグループには誰も所属していません。usermodコマンドでユーザyoshiをdockerグループに所属させると、dockerグループにyoshiが追加されたことが確認できます。一度ログアウトしなければ設定が反映されないためログアウトします。  
```
~$ getent group | grep docker # dockerグループに所属するユーザを確認する
docker:x:994:

~# usermod -aG docker yoshi # dockerグループにユーザyoshiを追加する

~$ getent group | grep docker # dockerグループに所属するユーザを確認する
docker:x:994:yoshi

~$ exit
```


## Dockerの実行  
再ログイン後にdocker runコマンドで動作確認を行います。"Hello from Docker!"が表示されていればOK  
```
$ docker run hello-world
```
# Ubuntu Server 16.04でDockerを動かす  
[Ubuntu Server 16.04でDockerを動かす 2016-07-16-sat](https://blog.onodai.com/posts/2016-07-16-sat)  
## 前提  
## リポジトリの追加  

* 1 必要なパッケージをインストールする。
```
   $ sudo apt-get install apt-transport-https ca-certificates
```

* 2 GPG鍵を追加する。
```
    $ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:8 0 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
```

* 3 /etc/apt/sources.list.d/docker.listを新規作成、編集し、Dockerのオフィシャルリポジトリを追加する。
```
    $ sudo vi /etc/apt/sources.list.d/docker.list

    [/etc/apt/sources.list.d/docker.list]

    deb https://apt.dockerproject.org/repo ubuntu-xenial main
```

* 4 パッケージインデックスを更新する。
```

    $ sudo apt-get update
```

* 5  古いパッケージをアンインストールする。
```
    $ sudo apt-get purge lxc-docker
```

* 6  Dockerのパッケージを取得できるか確認する。
```
    $ apt-cache policy docker-engine
```

## Dockerのインストール  

* 1 パッケージインデックスを更新する。
```
    $ sudo apt-get update
```

* 2 Dockerをインストールする。
```
    $ sudo apt-get install docker-engine
```

* 3 Dockerを起動する。
```
    $ sudo systemctl start docker.service
```

* 4 OS起動時に自動起動するようにする。
```
    $ sudo systemctl enable docker.service
```

## 動作確認  
```
$ sudo docker run hello-world
```

## おまけ:一般ユーザでもDockerのコマンドを扱えるように  
このままではroot以外のユーザがDockerのコマンドを扱えないため、dockerグループに普段使っているユーザを追加する。  
```
$ sudo usermod -aG docker onodai
```

# Ubuntu16.04にDocker CEをインストール  
[Ubuntu16.04にDocker CEをインストール updated at 2018-10-18](https://qiita.com/uutarou10/items/f9483aad5153957fc6dc)  

## Prerequirement    
古いDockerを消す  
dockerまたはdocker-engineコマンドが存在する場合は  
```
$ sudo apt remove docker docker-engine docker.io
```

## Installation  
```
$ sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```

```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
OKと表示されれば成功です。  

keyのfingerprintは9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88だそうで、以下のコマンドでfingerprintの下8文字を入力することで検証することができます。  
```
$ sudo apt-key fingerprint 0EBFCD88
pub   4096R/0EBFCD88 2017-02-22
      フィンガー・プリント = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
```

```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Dockerを入れる  

```
$ sudo apt-get update
```
```
$ sudo apt-get install docker-ce
```
```
$ sudo docker run hello-world
```
## Attention  
この説明で作るdockerグループはrootなユーザーと同等の権限を持っているのに等しいので、誰でもばかばかdockerグループに放り込むのはやめましょう。  

```
$ sudo groupadd docker
```
でdockerグループを作成します、と書いてはいるんですが私の場合はすでに存在していたので、おそらくdocker本体を入れると自動で作成されるのだろうと思います。

```
$ sudo usermod -aG docker $USER
```
これで現在のユーザーがdockerグループに追加されます。他のユーザーを突っ込みたいときは$USERのところをユーザー名に。

これが終わったら、一度ログアウトして入り直すことでsudoなしでdockerを使えるようになっているはずです。

## Troubleshooting  
[ModuleNotFoundError: No module named 'CommandNotFound'](https://blog.csdn.net/jaket5219999/article/details/81083124)  
```
解决方案：

找到lsb_release.py文件和CommandNotFound目录，把它们拷贝到报的错误中subprocess.py所在文件夹

命令如下：

    sudo find / -name 'lsb_release.py'
    # result:
    # /usr/share/pyshared/lsb_release.py
    # /usr/lib/python2.7/dist-packages/lsb_release.py
    # /usr/lib/python3/dist-packages/lsb_release.py
    python -V
    # Python 3.6.6
    sudo cp  /usr/lib/python3/dist-packages/lsb_release.py /usr/local/lib/python3.6/ 
```

```
~$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
Traceback (most recent call last):
  File "/usr/lib/command-not-found", line 27, in <module>
    from CommandNotFound.util import crash_guard
ModuleNotFoundError: No module named 'CommandNotFound'
```
```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
Traceback (most recent call last):
  File "/usr/lib/command-not-found", line 27, in <module>
    from CommandNotFound.util import crash_guard
ModuleNotFoundError: No module named 'CommandNotFound'
test@ubuntu:~$ sudo nano /usr/lib/command-not-found (change to python3.5)

test@ubuntu:~$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
The program 'lsb_release' is currently not installed. You can install it by typing:
sudo apt install lsb-release
```
```
$ sudo find / -name 'lsb_release.py'
/usr/share/pyshared/lsb_release.py
/usr/lib/python2.7/dist-packages/lsb_release.py
/usr/lib/python3/dist-packages/lsb_release.py
```


[python ModuleNotFoundError : 'CommandNotFound' Sep 3, 2017](https://askubuntu.com/questions/952302/python-modulenotfounderror-commandnotfound/952308)  
```

```


[/usr/bin/add-apt-repository ModuleNotFoundError: No module named 'softwareproperties'](https://blog.csdn.net/yangguangqizhi/article/details/81276075)  
```
安装了 Anaconda 之后，进行 sudo add-apt-repository 报错：

File "/usr/bin/add-apt-repository", line 11,

ImportError: No module named softwareproperties.SoftwareProperties

原因： 系统上同时存在多个版本的 python, /usr/bin/add-apt-repository 的第一行是：
#! /usr/bin/python3
/usr/bin/python3 链接到 python3.6

解决方案：
/usr/bin/add-apt-repository 的第一行改为：

#! /usr/bin/python3.4
Success !
```


[E: Problem executing scripts APT Update::Post-Invoke-Success error during apt-get update Aug 7, 2017](https://askubuntu.com/questions/943463/e-problem-executing-scripts-apt-updatepost-invoke-success-error-during-apt-ge)  
```
$ sudo apt-get update
Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [102 kB]     
Hit:2 http://ve.archive.ubuntu.com/ubuntu xenial InRelease                     
Hit:3 http://ve.archive.ubuntu.com/ubuntu xenial-updates InRelease             
Hit:4 http://ve.archive.ubuntu.com/ubuntu xenial-backports InRelease           
Fetched 102 kB in 23s (4337 B/s)                                               
*** Error in `appstreamcli': double free or corruption (fasttop): 0x000000000210f4b0 ***
======= Backtrace: =========
```
1. 
```
$ sudo apt install --reinstall libappstream3
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  libappstream3
1 upgraded, 0 newly installed, 0 to remove and 490 not upgraded.
Need to get 110 kB of archives.
After this operation, 4,096 B of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu xenial-updates/main i386 libappstream3 i386 0.9.4-1ubuntu4 [110 kB]
Fetched 110 kB in 1s (68.2 kB/s)
(Reading database ... 178833 files and directories currently installed.)
Preparing to unpack .../libappstream3_0.9.4-1ubuntu4_i386.deb ...
Unpacking libappstream3:i386 (0.9.4-1ubuntu4) over (0.9.4-1) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
Setting up libappstream3:i386 (0.9.4-1ubuntu4) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
```
2. (From here, https://forum.siduction.org/index.php?topic=6174.0):
```
sudo apt-get purge libappstream3
```

```
$ sudo apt-get update
Hit:1 http://us.archive.ubuntu.com/ubuntu xenial InRelease
Hit:2 http://security.ubuntu.com/ubuntu xenial-security InRelease
Hit:3 http://us.archive.ubuntu.com/ubuntu xenial-updates InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu xenial-backports InRelease
Hit:5 https://apt.dockerproject.org/repo ubuntu-xenial InRelease
Hit:6 https://download.docker.com/linux/ubuntu xenial InRelease
AppStream cache update completed, but some metadata was ignored due to errors.
Reading package lists... Done
```

```
$ sudo apt-get remove docker docker-engine docker.io
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package 'docker-engine' is not installed, so not removed
Package 'docker' is not installed, so not removed
Package 'docker.io' is not installed, so not removed
You might want to run 'apt-get -f install' to correct these:
The following packages have unmet dependencies:
 linux-headers-gcp : Depends: linux-headers-4.15.0-1029-gcp but it is not going to be installed
E: Unmet dependencies. Try 'apt-get -f install' with no packages (or specify a solution).
```

```
$ sudo apt-get install linux-headers-4.15.0-1029-gcp
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  linux-gcp-headers-4.15.0-1026 linux-headers-4.15.0-1026-gcp linux-image-4.15.0-1026-gcp linux-modules-4.15.0-1026-gcp
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  linux-headers-4.15.0-1029-gcp
0 upgraded, 1 newly installed, 0 to remove and 166 not upgraded.
```

```
$ sudo apt-get remove docker docker-engine docker.io
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package 'docker-engine' is not installed, so not removed
Package 'docker' is not installed, so not removed
Package 'docker.io' is not installed, so not removed
The following packages were automatically installed and are no longer required:
  linux-gcp-headers-4.15.0-1026 linux-gcp-headers-4.15.0-1027 linux-headers-4.15.0-1026-gcp linux-headers-4.15.0-1027-gcp
  linux-image-4.15.0-1026-gcp linux-image-4.15.0-1027-gcp linux-modules-4.15.0-1026-gcp linux-modules-4.15.0-1027-gcp
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 166 not upgraded.
```

```
$ sudo apt autoremove
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be REMOVED:
  linux-gcp-headers-4.15.0-1026 linux-gcp-headers-4.15.0-1027 linux-headers-4.15.0-1026-gcp linux-headers-4.15.0-1027-gcp
  linux-image-4.15.0-1026-gcp linux-image-4.15.0-1027-gcp linux-modules-4.15.0-1026-gcp linux-modules-4.15.0-1027-gcp
0 upgraded, 0 newly installed, 8 to remove and 166 not upgraded.
After this operation, 324 MB disk space will be freed.
Do you want to continue? [Y/n] y
```

```
$ sudo apt-get remove docker docker-engine docker.io
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package 'docker-engine' is not installed, so not removed
Package 'docker' is not installed, so not removed
Package 'docker.io' is not installed, so not removed
0 upgraded, 0 newly installed, 0 to remove and 166 not upgraded.
```

# How do I install Docker on Ubuntu 16.04 LTS? 
[How do I install Docker on Ubuntu 16.04 LTS? Jul 22, 2017](https://askubuntu.com/questions/938700/how-do-i-install-docker-on-ubuntu-16-04-lts)  

## (A) Official Ubuntu Repositories  
```
$ sudo apt-get install docker.io
```
## (B) Official Docker Way  
* (1) Set up the docker repository
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

* (2) Install Docker CE
```
sudo apt-get update
sudo apt-get install docker-ce
```

* (3) Verify the installation  
```
sudo docker run hello-world
```

[Ubuntu 16.04 安裝 Docker engine 2017-02-05](https://shazi.info/ubuntu-16-04-%E5%AE%89%E8%A3%9D-docker-engine/)  

* Step.1 先 update 你的 package  
> $ sudo apt-get update 

* Step.2 加入 Docker 的官方 repository 金鑰  
> $ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

* Step.3 加入 Docker 官方 repository  
> $ sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

* Step.4 更新 repository  
> $ sudo apt-get update  

* Step.5 用 apt-cache 搜尋一下 docker-engine，確保你是從 Docker 官方 repository 安裝的，而不是 Ubuntu repository  
> $ apt-cache policy docker-engine

來源必須是 https://apt.dockerproject.org。

* Step.6 安裝 Docker  
> $ sudo apt-get install -y docker-engine

* Step.7 Docker 會自動將服務啟動，並且寫入 boot  
> $ sudo systemctl status docker

* Step.8 由於這樣裝起來如果你要使用 docker command line 的話都必須使用 sudo 執行，如果不想要再用 sudo 的話可以將使用者加入 docker group  
> $ sudo usermod -aG docker $(whoami)

如果要馬上生效，請重新登入。 

# How to Install and Use Docker Compose on Ubuntu 16.04 /18.04  
[How to Install and Use Docker Compose on Ubuntu 16.04 /18.04 Apr 9, 2019](https://www.osetc.com/en/how-to-install-and-use-docker-compose-on-ubuntu-16-04-18-04.html)  

## Installing Docker Compose from Docker’s GitHub Repository  

You can install the Docker Compose from the official Ubuntu repositories, but it is not the latest version. So you can install the latest version of Docker Compose from the Docker’s GitHub repository.
```
$ curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
```
$ docker-compose --version
docker-compose version 1.24.0, build 0aa59064
```

# Dockerでpython3 and iperf3環境を準備する  
[dockerで簡易にpython3の環境を作ってみる 2018-10-17](https://qiita.com/reflet/items/4b3f91661a54ec70a7dc)  
[Measuring Network Bandwidth using Iperf and Docker Jan 2, 2018](http://networkstatic.net/measuring-network-bandwidth-using-iperf-and-docker/)  

## ファイル構成    
```

├ Dockerfile
├ docker-compose.yml
└ opt

```
## Dockerfile  
```
FROM python:3
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install -y vim less
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install atomicwrites
RUN pip install attrs
RUN pip install certifi
RUN pip install chardet
RUN pip install idna
RUN pip install importlib-metadata
RUN pip install iperf3
RUN pip install more-itertools
RUN pip install packaging
RUN pip install pluggy
RUN pip install py
RUN pip install pyparsing
RUN pip install pytest
RUN pip install requests
RUN pip install six
RUN pip install urllib3
RUN pip install wcwidth
RUN pip install zipp

# install binary and remove cache
RUN apt-get update \
    && apt-get install -y iperf3 \
    && rm -rf /var/lib/apt/lists/*
```
## docker-compose.yml  
```
version: '3'
services:
  python3:
    restart: always
    build: .
    container_name: 'python3'
    working_dir: '/root/'
    tty: true
    volumes:
      - /home/test/note_python/iperf:/root/opt
```
## コンテナ起動  
```
$ docker-compose up -d --build
```

```
~/docker_python3$ docker build -t python3 -f Dockerfile_python3 .
```
```
Sending build context to Docker daemon   7.68kB
Step 1/31 : FROM python:3
 ---> 60e318e4984a
Step 2/31 : USER root
 ---> Running in b58c8f06cd7b
Removing intermediate container b58c8f06cd7b
 ---> 9b13bea264fd
Step 3/31 : RUN apt-get update
 ---> Running in ad586c6ee542
```
.
.
.
```
Step 31/31 : RUN apt-get update     && apt-get install -y iperf3     && rm -rf /var/lib/apt/lists/*
 ---> Running in 5fb18f6afc2f
ヒット:1 http://security.debian.org/debian-security buster/updates InRelease
ヒット:2 http://deb.debian.org/debian buster InRelease
ヒット:3 http://deb.debian.org/debian buster-updates InRelease
パッケージリストを読み込んでいます...
パッケージリストを読み込んでいます...
依存関係ツリーを作成しています...
状態情報を読み取っています...
以下の追加パッケージがインストールされます:
  libiperf0 libsctp1
提案パッケージ:
  lksctp-tools
以下のパッケージが新たにインストールされます:
  iperf3 libiperf0 libsctp1
アップグレード: 0 個、新規インストール: 3 個、削除: 0 個、保留: 1 個。
131 kB のアーカイブを取得する必要があります。
この操作後に追加で 328 kB のディスク容量が消費されます。
取得:1 http://deb.debian.org/debian buster/main amd64 libsctp1 amd64 1.0.18+dfsg-1 [28.3 kB]
取得:2 http://deb.debian.org/debian buster/main amd64 libiperf0 amd64 3.6-2 [77.3 kB]
取得:3 http://deb.debian.org/debian buster/main amd64 iperf3 amd64 3.6-2 [25.9 kB]
debconf: delaying package configuration, since apt-utils is not installed
131 kB を 1秒 で取得しました (169 kB/s)
以前に未選択のパッケージ libsctp1:amd64 を選択しています。
(データベースを読み込んでいます ... 現在 27102 個のファイルとディレクトリがインストールされています。)
.../libsctp1_1.0.18+dfsg-1_amd64.deb を展開する準備をしています ...
libsctp1:amd64 (1.0.18+dfsg-1) を展開しています...
以前に未選択のパッケージ libiperf0:amd64 を選択しています。
.../libiperf0_3.6-2_amd64.deb を展開する準備をしています ...
libiperf0:amd64 (3.6-2) を展開しています...
以前に未選択のパッケージ iperf3 を選択しています。
.../iperf3_3.6-2_amd64.deb を展開する準備をしています ...
iperf3 (3.6-2) を展開しています...
libsctp1:amd64 (1.0.18+dfsg-1) を設定しています ...
libiperf0:amd64 (3.6-2) を設定しています ...
iperf3 (3.6-2) を設定しています ...
libc-bin (2.28-10) のトリガを処理しています ...
Removing intermediate container 5fb18f6afc2f
 ---> 6a3ed23d7e87
Successfully built 6a3ed23d7e87
Successfully tagged python3:latest
```

## コンテナへ接続  
```
~/docker_python3$ docker-compose up -d
Creating python3 ... done
```

```
~/docker_python3$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
python3             latest              9f129d917be2        3 minutes ago       1.01GB
python              3                   60e318e4984a        30 hours ago        918MB
hello-world         latest              fce289e99eb9        7 months ago        1.84kB
```

```
~/docker_python3$ docker run -v /home/test/note_python/iperf:/root/opt -it python3 bash
root@d264c66e2d7d:/# ls /root/opt/
README.md  lib  logs  main  test
root@d264c66e2d7d:/# python -V
Python 3.7.4
```

```
root@d264c66e2d7d:/# pip list -l
Package            Version
------------------ ---------
atomicwrites       1.3.0
attrs              19.1.0
certifi            2019.6.16
chardet            3.0.4
idna               2.8
importlib-metadata 0.19
iperf3             0.1.11
more-itertools     7.2.0
packaging          19.1
pip                19.2.3
pluggy             0.12.0
py                 1.8.0
pyparsing          2.4.2
pytest             5.1.1
requests           2.22.0
setuptools         41.2.0
six                1.12.0
urllib3            1.25.3
wcwidth            0.1.7
wheel              0.33.6
zipp               0.6.0
```

```
root@d264c66e2d7d:/# iperf3 -v
iperf 3.6 (cJSON 1.5.2)
Linux 945da946fa6c 4.15.0-58-generic #64~16.04.1-Ubuntu SMP Wed Aug 7 14:10:35 UTC 2019 x86_64
Optional features available: CPU affinity setting, IPv6 flow label, SCTP, TCP congestion algorithm setting, sendfile / zerocopy, socket pacing, authentication
```

## インストールしたライブラリの確認  
```
$ python -m pip list
Package         Version
--------------- -------
cycler          0.10.0 
decorator       4.3.0  
kiwisolver      1.0.1  
matplotlib      2.2.2  
networkx        2.1    
numpy           1.14.3 
pandas          0.22.0 
pip             10.0.1 
pyparsing       2.2.0  
python-dateutil 2.7.2  
pytz            2018.4 
PyYAML          3.12   
setuptools      39.1.0 
six             1.11.0 
tornado         5.0.2  
wheel           0.31.0 
XlsxWriter      1.0.4  
```
## 要らなくなったら...  
```
$ docker-compose down
```

## iperf3 Server and Client  
```
$  docker run  -it --rm --name=iperf3-server -p 5201:5201 iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

![alt tag](https://i.imgur.com/sNbT2mJ.jpg)  

```
docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iperf3-server
 
(Returned) 172.17.0.3
```

```
docker run  -it --rm networkstatic/iperf3 -c 172.17.0.3
```
![alt tag](https://i.imgur.com/xd4lL8g.jpg)  

[Dockerでpython3環境を準備する updated at 2017-09-05](https://qiita.com/RyoMa_0923/items/7c0b22dd3f284472e18d)  
## python3コンテナの準備  
```
sudo docker pull python:3.6
```
## python3コンテナの起動  
```
sudo docker run -d --name hoge python:3.6 /bin/bash -c 'tail -f /dev/null'
```
## 軽い動作確認
今後いろいろやっていくのでpipなどを使えるかを確認。

```
sudo docker exec -it hoge /bin/bash
# pip --version
pip 9.0.1 from /usr/local/lib/python3.6/site-packages (python 3.6)
```



# Troubleshooting


# Reference  
* [Measuring Network Bandwidth using Iperf and Docker Jan 2, 2018](http://networkstatic.net/measuring-network-bandwidth-using-iperf-and-docker/)  
```
Run the Iperf Server Side Docker Container

Start a listener service on port 5201 and name the container “iperf3-server” 
(if the image is not yet downloaded, the run command will pull it down for you). 
This is bound to the host machine/node IP address via NAT thanks to the -p 5201:5201 mapping. 
This means there is a container with a private IP address, along with the host machine’s IP listening on 5201. 
```

```
$  docker run  -it --rm --name=iperf3-server -p 5201:5201 networkstatic/iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```
```
$ docker ps
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS                    NAMES
43c6f69371ce        networkstatic/iperf3   "iperf3 -s"         2 minutes ago       Up 2 minutes        0.0.0.0:5201->5201/tcp   iperf3-server
```
```
$ docker image ls
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
networkstatic/iperf3   latest              6ea158fee1a7        22 months ago       126MB
```

```
 Run the Iperf Client Side Docker Container

Since we started the server, we now want to a client from another host/node at the server 
to measure the bandwidth between the two endpoints. This can be the same host you are on it you are First, 
get the IP address of the new Iperf3 server container you just started. 
If you are testing in the real world against two seperate machines, 
you would point at the host’s IP that is reachable between the two endpoints

The following will run the client side command from the same host, the server container is running on:
```


* [How to get a Docker container's IP address from the host? ](https://stackoverflow.com/questions/17157721/how-to-get-a-docker-containers-ip-address-from-the-host/17158003#17158003)  
```
Modern Docker client syntax:
```
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```
```
Old Docker client syntax:
```
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' container_name_or_id
```


* [Run container on specific IP with docker python API Apr 26, 2018](https://stackoverflow.com/questions/50028131/run-container-on-specific-ip-with-docker-python-api)  

* [[Docker] ubuntu 14.04/16.04にDockerをインストール updated at 2017-06-23](https://qiita.com/koara-local/items/ee887bab8c7186d00a88)  
* [Ubuntu 16.04 LTS Dockerをインストール posted at 2016-10-28](https://qiita.com/mtsu724/items/4c1e3a909a71fc4e5956)  
* [dockerコンテナ上で利用しているLet's Encryptを自動更新する 2019-05-07](https://qiita.com/bachinyan/items/122430c081b9836cbc54)  
* [Dockerの使い方メモ updated at 2018-07-15](https://qiita.com/__init__/items/1d04a3bdb43e982c6345)  


* [Ubuntu 16.04 Mastodon Docker安裝教學 Mar 22, 2018](https://blog.sardo.work/ubuntu-16-04-mastdon-docker/)  
* [Ubuntu Linux 安裝 Docker 步驟與使用教學 2016/11/17](https://blog.gtwang.org/virtualization/ubuntu-linux-install-docker-tutorial/)
```
接著將自己的使用者帳號加入至 docker 群組：
sudo usermod -aG docker gtwang

正常來說輸出會類似這樣：

如果出現這樣的訊息，就表示有問題，通常是因為帳號沒有加入 docker 群組，權限不足的因素，只要按照上述的方式將帳號加入 docker 群組即可解決。
```
* [安裝 Docker 容器環境 - ubuntu ](http://www.weithenn.org/2017/02/docker-install-ubuntu.html)  
```
首先，透過「uname -a」指令確認目前採用的 Linux 版本為 64 位元，接著執行「lsb_release -a」 可以看到為 Ubuntu 16.04.1 LTS 符合 Docker 容器環境運作要求。
```
* [深層学習用のUbuntuサーバーのDocker初期設定メモ updated at 2018-10-28](https://qiita.com/miyamotok0105/items/f9f7aa912485b7a7388b)  

* [Travis CI: E: Package 'docker-engine' has no installation candidate #873](https://github.com/ansible/molecule/issues/873)  


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