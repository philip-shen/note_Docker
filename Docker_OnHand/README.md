Table of Contents
=================

   * [note_Docker](#note_docker)
   * [Docker ABC](#docker-abc)
      * [Docker Command](#docker-command)
      * [Docker defalut:Socket then TCP](#docker-defalutsocket-then-tcp)
   * [Reference](#reference)
   * [h1 size](#h1-size)
      * [h2 size](#h2-size)
         * [h3 size](#h3-size)
            * [h4 size](#h4-size)
               * [h5 size](#h5-size)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)


# note_Docker
Take notes of Docker on hand stuffs

# Docker ABC  
[docker ABC  2019-09-23](https://ithelp.ithome.com.tw/articles/10214587)  

## Docker Command  
```
# starts or stop a container
docker start $container
docker stop $container
docker restart $container
# 把USB裝置帶入 $container
docker run -it --device=/dev/ttyUSB0 $container /bin/bash
# 察看containers
docker ps -a
# 從registry取出image
docker pull $image
# 送image回去registry
docker push $image
# Prune清除系統
docker system prune
docker container prune
docker image prune
# 刪除停止的containers
docker rm -v $(docker ps -a -q -f status=exited)
```

## Docker defalut:Socket then TCP  
> 編輯/etc/systemd/system/docker.service.d/startup_options.conf  
```
# /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
```

```
root@Kris:~ # systemctl daemon-reload
root@Kris:~ # systemctl restart docker.service
root@Kris:~ # nmap -p 2375 localhost

Starting Nmap 7.60 ( https://nmap.org ) at 2019-09-24 23:26 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000084s latency).

PORT     STATE SERVICE
2375/tcp open  docker

Nmap done: 1 IP address (1 host up) scanned in 0.29 seconds
root@Kris:~ #
```


# Reference
* [Lin Nick‎ 發文到 Python Taiwan]()  
```
一個關於在 Docker 裡面執行的問題

locale.setlocale(locale.LC_ALL, 'en_us')

在 mac 電腦上面跑 locale.currency 顯示貨幣金額 會正常運作
可是放在 Docker 去跑的時候, 會發生 Currency formatting is not possible using the 'C' locale.

試過了網路很多文章的解法,  都還是一樣有問題
測試專案裡面有包含試過方法

附上測試專案
https://github.com/nick6969/currency-question

謝謝
------------------
從 locale 關鍵字猜測，應該是編碼語系檔的問題。

docker image 以輕量快速為前提，
預設會移除許多不必要的內建功能、指令與設定檔來達到輕量化，
因此你需要自行在 alpine image 裡面安裝 locale or locale-gen 指令並產生你所需要的語系檔。

例如以 alpine image + locale-gen 為方向
可以查到類似這樣的參考：

https://gist.github.com/alextanhongpin/aa55c082a47b9a1b0060a12d85ae7923
```
```
篤誠 從 locale 關鍵字猜測，應該是編碼語系檔的問題。

docker image 以輕量快速為前提，
預設會移除許多不必要的內建功能、指令與設定檔來達到輕量化，
因此你需要自行在 alpine image 裡面安裝 locale or locale-gen 指令並產生你所需要的語系檔。

例如以 alpine image + locale-gen 為方向
可以查到類似這樣的參考：
https://gist.github.com/alextanhongpin/aa55c082a47b9a1b0060a12d85ae7923?fbclid=IwAR056spg_XZDQ8H7mQbR2VLzfTZADPByPz_hvlCHV1l5Pd0R6kGDW-aD_N0
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
