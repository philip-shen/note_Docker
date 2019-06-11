# note_Docker
Take notes of Docker stuffs

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