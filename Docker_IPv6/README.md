# note_Docker
Take notes of Docker stuffs

# Table of Contents  

# DockerでIPv6を有効にする
[DockerでIPv6を有効にする 2018-09-10](https://qiita.com/Esfahan/items/4815033dad276f86acde)  
/etc/docker/daemon.jsonをなければ作成して、以下を記述します。  
```
 /etc/docker/daemon.json

{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64"
}
```
dockerをreloadします。  
```
$ sudo systemctl reload docker
```

# Reference
* [DockerとIPv6 2016-02-10](https://qiita.com/_norin_/items/7b9eac9fc31a8b02073f#%E5%85%AC%E5%BC%8F%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88)  
* [Docker and IPv6 Prefix Delegation 10/03/2016](https://blog.widodh.nl/2016/03/docker-and-ipv6-prefix-delegation/)  
* [AnyIP: Bind a whole subnet to your Linux machine 28/04/2016](https://blog.widodh.nl/2016/04/anyip-bind-a-whole-subnet-to-your-linux-machine/)  
* [wido/docker-ipv6 ](https://github.com/wido/docker-ipv6)  


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