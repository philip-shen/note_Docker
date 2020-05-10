Table of Contents
=================

   * [Table of Contents](#table-of-contents)
   * [Purpose](#purpose)
   * [Portainer.io](#portainerio)
      * [Deploy Portainer Server](#deploy-portainer-server)
      * [PORTAINER AGENT DEPLOYMENTS ONLY](#portainer-agent-deployments-only)
      * [Login and Account Creatrion](#login-and-account-creatrion)
   * [Private docker registry](#private-docker-registry)
      * [Setup Procedures](#setup-procedures)
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
Take note of Portainer.io  

# Portainer.io   
[Portainer.io  2019-09-24](https://ithelp.ithome.com.tw/articles/10214585)  

## Deploy Portainer Server  
```
$ docker volume create portainer_data
$ docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```

## PORTAINER AGENT DEPLOYMENTS ONLY  
```
docker service create --name portainer_agent --network portainer_agent_network --publish mode=host,target=9001,published=9001 -e AGENT_CLUSTER_ADDR=tasks.portainer_agent --mode global --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes –-mount type=bind,src=/,dst=/host portainer/agent
```

## Login and Account Creatrion   
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403Ja1FgmCc71.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403Ia08RIMAo4.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403rmboOoIUVb.png)  

# Private docker registry  
[Private docker registry 2019-09-25](https://ithelp.ithome.com.tw/articles/10217364)  

## Setup Procedures  
> 放在ssd  

```
icekimo@Kris:~$ sudo mkdir /media/nvme0n1p1/registry
icekimo@Kris:~$ sudo docker run -d -p 5000:5000 -v /media/nvme0n1p1/storage:/var/lib/registry --name registry registry:2

Unable to find image 'registry:2' locally
2: Pulling from library/registry
c87736221ed0: Pull complete
1cc8e0bb44df: Pull complete
54d33bcb37f5: Pull complete
e8afc091c171: Pull complete
b4541f6d3db6: Pull complete
Digest: sha256:8004747f1e8cd820a148fb7499d71a76d45ff66bac6a29129bfdbfdc0154d146
Status: Downloaded newer image for registry:2
e5d39198730e7a93cd7f41f7626338505d4c1e9449a1098aede5048947668e4b
icekimo@Kris:~$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                                            NAMES
e5d39198730e        registry:2            "/entrypoint.sh /etc…"   4 seconds ago       Up 3 seconds        0.0.0.0:5000->5000/tcp                           registry
255531a6efde        portainer/portainer   "/portainer"             4 hours ago         Up 4 hours          0.0.0.0:8000->8000/tcp, 0.0.0.0:9000->9000/tcp   boring_poincare
```
> Find out IP
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403TwaAcGSN2m.png)  

> Regist registry
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403MtJpiqKxXI.png)  

![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403ip9R01WUfb.png)  

> --restart=always  
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403hMDLRoaHya.png)  

> Private registry
![alt tag](https://d1dwq032kyr03c.cloudfront.net/upload/images/20190920/20094403jrRNAL1vjw.png)  


# Troubleshooting


# Reference


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


