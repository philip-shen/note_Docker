Table of Contents
=================

   * [note_Docker](#note_docker)
   * [Docker Tutorial](#docker-tutorial)
      * [仮想化概要](#仮想化概要)
         * [ホスト型仮想化](#ホスト型仮想化)
         * [ハイパーバイザ型仮想化(hypervisor)](#ハイパーバイザ型仮想化hypervisor)
         * [コンテナ型仮想化](#コンテナ型仮想化)
      * [Docker内部の仕組み](#docker内部の仕組み)
         * [namespace](#namespace)
         * [cgroup(control group)](#cgroupcontrol-group)
         * [Network](#network)
            * [Link Function](#link-function)
            * [Interface](#interface)
      * [Command Overview](#command-overview)
         * [イメージ管理用(image)](#イメージ管理用image)
         * [コンテナ管理用(container)](#コンテナ管理用container)
         * [その他](#その他)
   * [Reference](#reference)
   * [h1 size](#h1-size)
      * [h2 size](#h2-size)
         * [h3 size](#h3-size)
            * [h4 size](#h4-size)
               * [h5 size](#h5-size)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)


# note_Docker
Take notes of Docker stuffs

# Docker Tutorial  
[いまさらだけどDockerに入門したので分かりやすくまとめてみた updated at 2019-12-17](https://qiita.com/gold-kou/items/44860fbda1a34a001fc1#docker%E4%B8%BB%E8%A6%81%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89)  

## 仮想化概要  
### ホスト型仮想化  
> VirtualBox、VMWare Player。  

![alt tag](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F221948%2F8e77ad87-b140-173d-554d-0db84161bda2.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&s=81555d811e7e6f0a22fa95bd51a4e668)

### ハイパーバイザ型仮想化(hypervisor)     
![alt tag](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F221948%2Ff011b839-94bb-86aa-0309-3a2759a6749b.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&s=bd833a4fdf84946e7aaa7d8315250e33)  

### コンテナ型仮想化  
![alt tag](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F221948%2F2b62e1e8-8e7b-7959-6b39-d91c37373cbc.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&w=1400&fit=max&s=37c422c09f036e77daa82d8d5abf909e)  

## Docker内部の仕組み  
### namespace  
[namespace](https://qiita.com/gold-kou/items/44860fbda1a34a001fc1#namespace)  
```
DockerはLinuxカーネルのnamespaceの機能を使ってコンテナ毎の区画化を実現している。
namespace毎に下記を管理している。

    PID：プロセスに関して
    Network：IPアドレス、ポート番号、ルーティング、フィルタリングなどのネットワークに関して
    UID/GID：ユーザIDとグループIDに関して
    MOUNT：マウントに関して
    UTS：ホスト名やドメイン名に関して
    IPC：メッセージキューなどのプロセス間通信に関して
```

### cgroup(control group)  
[cgroup(control group)](https://qiita.com/gold-kou/items/44860fbda1a34a001fc1#cgroupcontrol-group)  
```
DockerはLinuxカーネルのcgroupの機能を使ってコンテナが利用する物理マシンリソース(CPUやメモリなど)の割り当ての管理を実現している。
プロセスをグループ化して、グループごとにリソース使用量制限をかけている。
```

### Network  
#### Link Function  
[リンク機能](https://qiita.com/gold-kou/items/44860fbda1a34a001fc1#%E3%83%AA%E3%83%B3%E3%82%AF%E6%A9%9F%E8%83%BD)  
```
コンテナにはそれぞれ仮想NIC(eth0)が割り当てられ、172.17.0.0/16のセグメントのIPがDHCPで割り当てられる。
コンテナの仮想NICはホストOS上の1つのブリッジ(docker0)に接続されているためコンテナ同士で通信することが可能。
（リンク機能）
ただし、複数物理サーバが存在するマルチホスト環境において、異なる物理サーバへのリンク機能を使った通信は不可。
```
![alt tag](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.amazonaws.com%2F0%2F221948%2F9d4604b1-2d84-89ad-9dae-33cc2816e8fe.png?ixlib=rb-1.2.2&auto=format&gif-q=60&q=75&w=1400&fit=max&s=f2f5042c7b6c49a5428aad36df4eca13)  

#### Interface  
> コンテナ内で確認したインターフェース情報は以下。 コンテナ側から見るとまるで物理NIC(eth0)のように見える。
```
# ip a
(省略)
34: eth0@if35: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```

> しかし、ホストOS側から見ると実体はvethであることが以下から分かる。
> vethは、L2の仮想NICであり、コンテナのNIC(eth0)とホストOSのブリッジ(docker0)間でトンネリングをしている。
```
# ip a
(省略)
35: vethd48920c@if34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether 9e:bd:4d:63:ed:38 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::9cbd:4dff:fe63:ed38/64 scope link
       valid_lft forever preferred_lft forever
```

> また、ホストOS上で以下の通り、docker0ブリッジを確認できる。 
```
# ip a
(省略)
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:bd:f7:d8:19 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```

## Command Overview  
### イメージ管理用(image)  

* pull：Dockerイメージをレジストリから取得
* ls：Dockerイメージの一覧を表示
* inspect：Dockerイメージの詳細を表示
* tag：Dockerイメージにタグをつける
* push：Dockerイメージをレジストリへアップロード
* rm：Dockerイメージの削除
* save：Dockerイメージをtarファイルに保存
* load：saveで固めたtarからDockerイメージを作成
* import：exportで固めたtarファイルからDockerイメージを作成

### コンテナ管理用(container)  

* ls：コンテナの一覧を表示
* run：Dockerイメージからコンテナを生成
* stats：コンテナのリソース使用状況を表示
* logs：コンテナ内の実行ログ確認
* create：Dockerイメージからコンテナの生成
* start：コンテナの起動
* stop：コンテナの停止
* restart：コンテナの再起動
* pause：コンテナの一時停止
* unpause：一時停止中コンテナの起動
* rm：停止中コンテナの削除
* attach：稼働中コンテナに接続
* exec：稼働中コンテナに接続
* top：稼働中コンテナ内のプロセス一覧表示
* port：コンテナの公開ポート番号表示
* rename：コンテナの名前変更
* cp：コンテナとホストOS間でファイルとディレクトリのコピー
* diff：Dockerイメージが生成されてからの変更情報を表示
* commit：変更があったコンテナからイメージを作成
* export：コンテナをtarファイルに保存

### その他  

* version：Dockerのバージョンを表示
* info：Dockerの実行環境情報を表示
* search：Docekrイメージの検索
* login：Docker Hubへログイン
* logout：Docker Hubからログアウト

![alt tag]()  
![alt tag]()  
![alt tag]()  
![alt tag]()  
![alt tag]()  
![alt tag]()  
![alt tag]()  
![alt tag]()  

# Reference
* [Docker 初心者 — ssh で接続できるサーバーを立てる 2018-09-11](https://qiita.com/YumaInaura/items/adb20c8083fce2da86e1)  
```
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```
* [Dockerize an SSH service | Docker Documentation](https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image)  

* [【Python3】ブラウザを経由したスクレイピング(動的なページなど)【Selenium】2018-02-19](https://qiita.com/shunyooo/items/09cc636344212112a6fc)  
* [撰寫 Dockerfile 時遇到的怪問題 , 使用 rm 指令無法移除某些檔案 2016-09-26](https://blog.haostudio.net/hwp/%E6%92%B0%E5%AF%AB-dockerfile-%E6%99%82%E9%81%87%E5%88%B0%E7%9A%84%E6%80%AA%E5%95%8F%E9%A1%8C-%E4%BD%BF%E7%94%A8-rm-%E6%8C%87%E4%BB%A4%E7%84%A1%E6%B3%95%E7%A7%BB%E9%99%A4%E6%9F%90%E4%BA%9B%E6%AA%94/)  
```
搞了好久, 才發現問題出現在 RUN rm -rf /var/lib/mysql/* 這行, 當我建立出一個container後, 進去裡面看, /var/lib/mysql/ 竟然還有殘留兩個空目錄. 以至於造成entrypoint.sh 執行失敗. 至於為何 rm 指令無法刪除, 我做了許多實驗, 包括 added delay, sync, mv then delete, delete twice…..etc 某些組合會成功,某些組合會失敗. 搞得我好亂啊!! 乾脆先去睡一覺. 隔天起床後去問google 大神.

找的可能的原因了如下:

    Cannot (force) remove directory in Docker build
    unexpected file permission error in container

根據上面的討論, 懷疑是AUFS filesystem, 或者是有可能是linux kernel 的bug (或許在 4.4.6 版已經解決). 但是我的linux kernel 還太舊, 而且又不是x86 系統. 根本無法更新啊.

突然想到, 既然懷疑是AUFS 在存取 lower layer 和 upper layer 所造成的問題. 那就把它做在同一個 layer 就好了啊. 於是改寫dockerfile 如下:
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

