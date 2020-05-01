Table of Contents
=================

   * [note_Docker](#note_docker)
   * [Table of Contents](#table-of-contents)
   * [Docker for Ubuntu hosted on WSL of Windows 10 Home](#docker-for-ubuntu-hosted-on-wsl-of-windows-10-home)
      * [Prerequisites (必要なもの)](#prerequisites-必要なもの)
      * [動作時の負荷について](#動作時の負荷について)
      * [完了まで全体像](#完了まで全体像)
      * [Docker Setup of Windows Subsystem for Linux](#docker-setup-of-windows-subsystem-for-linux)
      * [Solution: Cannot connect to the Docker daemon on bash on Ubuntu windows](#solution-cannot-connect-to-the-docker-daemon-on-bash-on-ubuntu-windows)
      * [Install and Excute Re:VIEW image for Docker](#install-and-excute-review-image-for-docker)
      * [普段のReviewコンパイルについて](#普段のreviewコンパイルについて)
         * [起動時にDockerデーモンを起動しておく](#起動時にdockerデーモンを起動しておく)
         * [容易なReviewのコンパイル実行方法](#容易なreviewのコンパイル実行方法)
      * [Select docker.io, not latest docker-ce.](#select-dockerio-not-latest-docker-ce)
      * [Why Docker Desktop is necessary？](#why-docker-desktop-is-necessary)
   * [How To Install and Use Docker on Ubuntu 16.04 | DigitalOcean](#how-to-install-and-use-docker-on-ubuntu-1604--digitalocean)
   * [Docker on WSL2](#docker-on-wsl2)
      * [1. docker Installation](#1-docker-installation)
      * [2. docker-compose  Installation](#2-docker-compose--installation)
      * [3. Portainer Installation](#3-portainer-installation)
      * [4. Launch Docker when Windows Login](#4-launch-docker-when-windows-login)
   * [Reference](#reference)
   * [h1 size](#h1-size)
      * [h2 size](#h2-size)
         * [h3 size](#h3-size)
            * [h4 size](#h4-size)
               * [h5 size](#h5-size)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)


# note_Docker
Take notes of Docker on Ubuntu stuffs


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


# Docker on WSL2  
[WSL2でdocker-composeを使えるようにするまで Aug 25, 2019](https://qiita.com/suaaa7/items/744f58319c04d9b6bfbe)  

## 1. docker Installation  
[6. dockerのインストール](https://qiita.com/suaaa7/items/744f58319c04d9b6bfbe#6-docker%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)  

```
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get install docker-ce
```

起動  
```
$ service docker status
 * Docker is not running
$ sudo service docker start
 * Starting Docker: docker                                                                                       [ OK ]
$ service docker status
 * Docker is running
```

pullできるか確認  
```
$ docker pull alpine:latest
latest: Pulling from library/alpine
9d48c3bd43c5: Pull complete                                                                                             Digest: sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
$ docker images
REPOSITORY                                                       TAG                 IMAGE ID            CREATED             SIZE
alpine                                                           latest              961769676411 
```

## 2. docker-compose  Installation  
[7. docker-composeのインストール](https://qiita.com/suaaa7/items/744f58319c04d9b6bfbe#7-docker-compose%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)  
```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
$ docker-compose --version
docker-compose version 1.24.1, build 4667896b
```

## 3. Portainer Installation  
[最近開始改用 WSL2 跑 docker 當開發環境 Oct 08, 2019](https://www.pigo.idv.tw/archives/3359)  

```
Portainer 是一套很棒的 docker 管理介面，
我也是照著官方的說明文件來安裝的，但我們這邊要依照 Linux 的方式來安裝，
過去若使用 Docker for Windows Desktop則是使用 Windows 方式，
現在 WSL2 模式則完全是採用 Linux 方式，所以安裝方式如下
```

```
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
![alt tag](https://i.imgur.com/tfAuVCf.jpg)  


## 4. Launch Docker when Windows Login  
[WSL Tips: Starting Linux Background Services on Windows Login Jul 14 '18](https://dev.to/ironfroggy/wsl-tips-starting-linux-background-services-on-windows-login-3o98)  
```
這篇主要就是寫一個啟動 docker 的 script，並將 ubuntu 預設使用者設定不用密碼能執行這支 script，
然後利用 Windows 內建的工作排程器設定當第一次登入時，就執行這支 script。
因此我們可以直接就寫一隻 start_services.sh，把我們想要啟動的服務都寫進去，
例如 docker , ssh 有的沒的通通都可以塞進這支內，由於我的 ubuntu 的預設使用者是 pigo，
因此我這隻 script 的完整路徑是 /home/pigo/.local/bin/start_services.sh 
(記得這支要 chmod +x 使其能執行)，而內容我只寫一行，如下 :
```

```
service docker start
```

```
接下來是編輯 /etc/sudoers 要新增一條，讓用戶 pigo 不用密碼就能直接執行 start_services.sh，我的內容如下 :
```

```
pigo ALL=(root) NOPASSWD: /home/pigo/.local/bin/start_services.sh
```

```
最後，Windows 內建排程器設定使用者登入就執行，如下圖是工作排程器打開的畫面。
```

[WSL2 + VScodeでWindowsから一瞬でDockerコンテナ内に引き篭もれる開発環境を整えたかった Aug 25, 2019](https://qiita.com/iridon0920/items/005a9224343413b74f78)  
[Docker Desktop for WSL2 を使い快適にWindowsでサーバ開発をしよう！ Oct 23, 2019](https://qiita.com/YukiMiyatake/items/c7896a0fc5abfa6c2300)  
[Windows 10 HomeのWSL2でdocker-composeを使う Dec 09, 2019](https://qiita.com/sonoha/items/33f1bc3b12f0803ceca7)  


```

```


# Reference
* [Windows10+WSL(Ubuntu)+Docker サーバサイド開発環境 updated at 2019-03-19](https://qiita.com/arai-h/items/70f592f1ba7075727f38)  
[(参考) 各コンテナの起動とコンテナ間通信](https://qiita.com/arai-h/items/70f592f1ba7075727f38#%E5%8F%82%E8%80%83-%E5%90%84%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%81%AE%E8%B5%B7%E5%8B%95%E3%81%A8%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E9%96%93%E9%80%9A%E4%BF%A1)  
[(参考) ホスト(Windows)ドライブをマウント](https://qiita.com/arai-h/items/70f592f1ba7075727f38#%E5%8F%82%E8%80%83-%E3%83%9B%E3%82%B9%E3%83%88windows%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E3%82%92%E3%83%9E%E3%82%A6%E3%83%B3%E3%83%88)  
* [[2019年1月版]WSL + Ubuntu で Docker が動くっ！動くぞコイツッ！ updated at 2019-01-02](https://qiita.com/koinori/items/78a946fc74452af9afba)  

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

