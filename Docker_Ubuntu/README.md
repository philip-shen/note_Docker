# note_Docker
Take notes of Docker on Ubuntu stuffs

# Table of Contents  
[Docker for Ubuntu hosted on WSL of Windows 10 Home](#docker-for-ubuntu-hosted-on-wsl-of-windows-10-home)  
[Prerequisites (必要なもの)](#prerequisites-%E5%BF%85%E8%A6%81%E3%81%AA%E3%82%82%E3%81%AE)  
[Docker Setup of Windows Subsystem for Linux](#docker-setup-of-windows-subsystem-for-linux)  
[Solution: Cannot connect to the Docker daemon on bash on Ubuntu windows](#solution-cannot-connect-to-the-docker-daemon-on-bash-on-ubuntu-windows)  
[Select docker.io, not latest docker-ce](#select-dockerio-not-latest-docker-ce)  
[Why Docker Desktop is necessary？](#why-docker-desktop-is-necessary)  

[How To Install and Use Docker on Ubuntu 16.04 | DigitalOcean](#how-to-install-and-use-docker-on-ubuntu-1604--digitalocean)  

# Docker for Ubuntu hosted on WSL of Windows 10 Home  
[Windows 10 HomeでWSL越しにDocker for Ubuntu+Re:VIEWを使う（VM不要）updated at 2019-05-07](https://qiita.com/hoshimado/items/78cccdaffd41dc47837e#%E5%8B%95%E4%BD%9C%E6%A4%9C%E8%A8%BC%E3%81%97%E3%81%9F%E7%92%B0%E5%A2%8320190722)  

## Prerequisites (必要なもの)  
* 2018年4月以降のアップデートを適用したMicrosoft Windows 10環境。
  - Windows 10 Homeエディション（Hyper-V無し）の環境で動作確認しました。
  - Windows 10 April Update 2018（10.0.17134）以降の環境と対象とします。
* ストレージ内に最低でも3.2GB以上の空き領域。
  - Windows Subsystem for Linuxをインストールすると1.10GB使用します。
  - Re:VIEW image for Dockerをインストールすると2.03GBを使用します(Re:VIEW 2.5)。
  - このほかにドキュメント自体などを収納するための空き領域も必要です。  

## 動作時の負荷について  
* WSL利用時のメモリ利用量は0.1GB程度です。  

## 完了まで全体像  
> 以下の操作を行います。ネットワーク回線の速度に依存しますが、10～30Mbpsの下り速度の環境で「1.」を30分くらい、「2.」と「3.」を30分くらい、合計１ｈと少しで完了できます。

* 1 Windows Subsystem for Linux (Ubuntu)のセットアップ
* 2 Docker のセットアップ
* 3 Re:VIEW image for Dockerの取得

## Docker Setup of Windows Subsystem for Linux
```
sudo apt update
sudo apt upgrade
sudo apt install docker.io
sudo cgroupfs-mount
sudo usermod -aG docker $USER
sudo service docker start
```

dockerがインストールされ、デーモン (daemon)が起動します。本設定は初回のみ実施し、2回目以降は必要ありません。2回目以降の動作に準拠するため、一旦「exit」でUbuntu on WSLを終了します。  

2回目以降は、以下の操作でDockerデーモンを起動します。  
1. Ubuntu on WSLを管理者権限で起動する。  
2. Ubuntuのコマンドライン（ターミナル）上で、以下のコマンド実行する。  
```
sudo cgroupfs-mount && sudo service docker start
```

dockder が正しくセットアップされたの確認のため、Hello Worldのイメージを起動してみます。以降のdockerコマンドではsudoは不要です。  
```
docker run hello-world
```

## Solution: Cannot connect to the Docker daemon on bash on Ubuntu windows
[Cannot connect to the Docker daemon on bash on Ubuntu windows](https://stackoverflow.com/questions/48047810/cannot-connect-to-the-docker-daemon-on-bash-on-ubuntu-windows)
```
# docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```
>Found the solution on this post: https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/  
>Running docker against an engine on a different machine is actually quite easy, as Docker can expose a TCP endpoint which the CLI can attach to.  
> This TCP endpoint is turned off by default; to activate it, right-click the Docker icon in your taskbar and choose Settings, and tick the box next to “Expose daemon on tcp://localhost:2375 without TLS”.  
> With that done, all we need to do is instruct the CLI under Bash to connect to the engine running under Windows instead of to the non-existing engine running under Bash, like this:  

![alt tag](https://images2018.cnblogs.com/blog/578477/201806/578477-20180604160519171-1306541136.png)

```
$ docker -H tcp://localhost:2375 images
```

> There are two ways to make this permanent – either add an alias for the above command or export an environment variable which instructs Docker where to find the host engine (NOTE: make sure to use single apostrophe's below):  

```
$ echo "export DOCKER_HOST='tcp://localhost:2375'" >> ~/.bashrc
$ source ~/.bashrc
```

>Now, running docker commands from Bash works just like they’re supposed to.  

```
$ docker run hello-world
```
![alt tag](https://i.imgur.com/9wEPTGt.png)  

## Install and Excute Re:VIEW image for Docker  
続いて、Re:VIEW image for Dockerの取得します。  
以下のリポジトリで公開されているので、こちらを利用します。  
https://github.com/vvakame/docker-review  
```
docker pull vvakame/review:3.0
```
![alt tag](https://i.imgur.com/Okfh0dF.jpg)  

```
$ mkdir /mnt/d/repo-doc
$ docker run -v /mnt/d/repo-doc:/work -it vvakame/review:3.0 /bin/sh
# cd /work
# review-init review-sample
# cd review-sample
# review-pdfmaker config.yml
# exit
$ exit
```
![alt tag](https://i.imgur.com/iPLDgO3.jpg)  

```
docker run -v /mnt/d/repo-doc:/work -it vvakame/review:3.0 /bin/sh
```

1. 「Re:VIEW image for Docker」を起動する。
2. Windows側のDドライブのルートの「repo-doc」フォルダを、docker側のルートの「work」フォルダとしてマウントする。
3. Dockerのコマンドラインに入る。

## 普段のReviewコンパイルについて  

### 起動時にDockerデーモンを起動しておく  
```
sudo cgroupfs-mount && sudo service docker start
```
「Dockerデーモン」の起動方法は先ほどと同様です。起動したら、WSLの画面は閉じてしまって構いません。  
1. Ubuntu on WSLを管理者権限で起動する。  
2. Ubuntuのコマンドライン（ターミナル）上で、以下のコマンド実行する。  

### 容易なReviewのコンパイル実行方法  
実際のWindows上での利用方法としては、以下のようになると思います。

1. 任意のエディタ（Visual Studio Codeとか）でReviewファイルを作成する。
2. 作成したReviewファイルを、reviewコマンドでpdfへコンパイルする。

一般的なreviewファイルは、以下の様なフォルダ構造で作成すると思います。
```
ドキュメントのフォルダ
　＋articles
　　＋実際のreview.reファイル
    ＋config.yml
    ＋catalog.yml
```

```
docker run --rm -v `pwd`/articles:/work vvakame/review:3.0 /bin/sh -c "cd /work && review-pdfmaker config.yml"
```
上記のコマンドは、以下を纏めて実行しています。  

1. dockerイメージを起動（生成）：run  
2. カレントフォルダの直下にあるarticlesフォルダを、docker上のルートのworkフォルダとしてマウント：-v  
3. docker起動後に、「workフォルダへ移動、reviewコンパイル」を実行：/bin/sh -c  
4. dockerイメージを終了（破棄）：-rm  

## Select docker.io, not latest docker-ce.  

docker-cd が最新版(18.xx)で、docker.io は旧版（17.xx）らしい。  
https://stackoverflow.com/questions/45023363/what-is-docker-io-in-relation-to-docker-ce-and-docker-ee

    What is docker.io in relation to docker-ce and docker-ee?

  Older versions of Docker were called docker or docker-engine or docker.io

ただし、現時点のWSL上では「docker-ceは動かない（docker.ioは動く）」とのこと。なので、現時点のWSLでは「docker.io」を入れる必要がある。  
https://www.reddit.com/r/bashonubuntuonwindows/comments/8cvr27/docker_is_running_natively_on_wsl/

  when I install the docker-ce and run it, it gave me: docker: failed to register layer: Error processing tar file(exit status 1): invalid argument.

https://github.com/Microsoft/WSL/issues/2291#issuecomment-383698720

  The last docker-ce version that works right now on WSL is 17.09.0. Anything after that fails on extracting the docker images.

## Why Docker Desktop is necessary？  
[なぜDocker Desktopなのか？](https://qiita.com/arai-h/items/70f592f1ba7075727f38#%E3%81%AA%E3%81%9Cdocker-desktop%E3%81%AA%E3%81%AE%E3%81%8B)  

WSL(Ubuntu)にDockerを入れても動作しません。  
WSLが提供してないカーネルサービスを要求するためです。  
WindowsでDockerを使うためにはDocker Desktopが必要です。  
※2019年2月時点。WSL＋Ubuntu16.04＋Docker(17系)ならば動くようですが古いのでオススメしません。  

Dockerのほか、NGINX Unitもmemfd_create()未対応で動作しません。  
参考: [WSLのシステムコール実装/未実装を確認する](https://xdigit.hatenablog.com/entry/2018/11/21/164559)  

# How To Install and Use Docker on Ubuntu 16.04 | DigitalOcean
[How To Install and Use Docker on Ubuntu 16.04 Oct 19, 2018](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)  

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

[ Ubuntu 16.04 安裝 Docker engine 2017-02-05](https://shazi.info/ubuntu-16-04-%E5%AE%89%E8%A3%9D-docker-engine/)  

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

# 


# Reference
* [Windows10+WSL(Ubuntu)+Docker サーバサイド開発環境 updated at 2019-03-19](https://qiita.com/arai-h/items/70f592f1ba7075727f38)  


* [Setting Up Docker for Windows and WSL to Work Flawlessly Apr 19, 2019](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)  

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