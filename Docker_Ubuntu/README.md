# note_Docker
Take notes of Docker on Ubuntu stuffs

# Table of Contents  
[LinuxにDockerをインストールする](#linux%E3%81%ABdocker%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)  
[Ubuntu Server 16.04でDockerを動かす](#ubuntu-server-1604%E3%81%A7docker%E3%82%92%E5%8B%95%E3%81%8B%E3%81%99)  
[Ubuntu16.04にDocker CEをインストール]()
[How do I install Docker on Ubuntu 16.04 LTS?](#how-do-i-install-docker-on-ubuntu-1604-lts)  

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

```
$ sudo apt-get update
```

```
$ sudo apt-get install docker-ce
```

```
$ sudo docker run hello-world
```
## 注意  
この説明で作るdockerグループはrootなユーザーと同等の権限を持っているのに等しいので、誰でもばかばかdockerグループに放り込むのはやめましょう。  

## 手順  
```
$ sudo groupadd docker
```
でdockerグループを作成します、と書いてはいるんですが私の場合はすでに存在していたので、おそらくdocker本体を入れると自動で作成されるのだろうと思います。

```
$ sudo usermod -aG docker $USER
```
これで現在のユーザーがdockerグループに追加されます。他のユーザーを突っ込みたいときは$USERのところをユーザー名に。

これが終わったら、一度ログアウトして入り直すことでsudoなしでdockerを使えるようになっているはずです。

## troubleshooting  
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


# Troubleshooting


# Reference  
* [[Docker] ubuntu 14.04/16.04にDockerをインストール updated at 2017-06-23](https://qiita.com/koara-local/items/ee887bab8c7186d00a88)  
* [Ubuntu 16.04 LTS Dockerをインストール posted at 2016-10-28](https://qiita.com/mtsu724/items/4c1e3a909a71fc4e5956)  

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