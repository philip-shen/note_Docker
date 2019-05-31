# note_Docker
Take notes of Docker on Ubuntu stuffs

# Table of Contents  

[]()  

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

##   
  


# 


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