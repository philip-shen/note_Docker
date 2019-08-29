# note_Docker
Take notes of Docker stuffs

# Table of Contents  
[Docker network](#docker-network)  
[Container's IP Subnet is the same as Host PC](#containers-ip-subnet-is-the-same-as-host-pc)  

[Reference](#reference)  

# Docker network  
* docker network create
* docker network connect
* docker network ls
* docker network rm
* docker network disconnect
* docker network inspect

# Container's IP Subnet is the same as Host PC 
* [ホストPCと同じセグメントのIPアドレスをDockerコンテナに割り当てる 2019-05-15](https://qiita.com/Meganezaru@github/items/69f406844532d731d370)  
```
macvlanドライバを利用するNetworkを作成して、docker run時に利用することで、ホストPCと同セグメントのIPアドレスを割り当てて、
コンテナを動作させることができます。

Ubuntu 18.04で動作を確認
```
* Networkの作成  
```
$ docker network create -d macvlan --subnet=192.168.1.0/24　--gateway=192.168.1.254 -o parent=enp4s0 mynet
```
```
上記の例では、mynetという名称でアダプタが作成されます。
--subnet、--gatewayには、ホストと同じネットワークの値を指定。
-o parentには、ホストのアダプタID(ifconfig参照)を指定します。
```
```
$ ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500

enp4s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.10  netmask 255.255.255.0  broadcast 192.168.1.255
```
* コンテナ起動  
```
$ docker run -d --name nginx20 --network mynet --ip 192.168.1.20 -p 80:80 nginx
```

* [Networking using a macvlan network](https://docs.docker.com/network/network-tutorial-macvlan/)  


* [docker でMACVLANを使い、ホストと同じIP空間のIPを割り当てる 2016-12-07](https://qiita.com/manabuishiirb/items/a3f32215e1f42535fa8d)  
```
オプションのparentについては、下の参考情報の中に、見つける方法があったと思うので、それを参照してください。

docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 mcv
```

# Reference
* [DockerとIPv6 2016-02-10](https://qiita.com/_norin_/items/7b9eac9fc31a8b02073f#%E5%85%AC%E5%BC%8F%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88)  
* [[翻訳] Work with network commands 2015-11-05](https://qiita.com/muddydixon/items/e69279d332f77fc00c3e)  

* [Docker 1.10 container's IP in LAN Jun 2 '16](https://stackoverflow.com/questions/35742807/docker-1-10-containers-ip-in-lan/36470828#36470828)  
```
After looking for people who have the same problem, we went to a workaround :
Sum up :

    (V)LAN is 192.168.1.0/24
    Default Gateway (= router) is 192.168.1.1
    Multiple Docker Hosts
    Note : We have two NIC : eth0 and eth1 (which is dedicated to Docker)

What do we want :

We want to have containers with ip in the 192.168.1.0/24 network (like computers) without any NAT/PAT/translation/port-forwarding/etc...
Problem

When doing this :

network create --subnet 192.168.1.0/24 --gateway 192.168.1.1 homenet

we are able to give containers the IP we want to, but the bridge created by docker (br-[a-z0-9]+) will have the IP 192.168.1.1, which is our router.
```
```
Solution
1. Setup the Docker Network

Use the DefaultGatewayIPv4 parameter :

docker network create --subnet 192.168.1.0/24 --aux-address "DefaultGatewayIPv4=192.168.1.1" homenet

By default, Docker will give to the bridge interface (br-[a-z0-9]+) the first IP, which might be already taken by another machine. The solution is to use the --gateway parameter to tell docker to assign a arbitrary IP (which is available) :

docker network create --subnet 192.168.1.0/24 --aux-address "DefaultGatewayIPv4=192.168.1.1" --gateway=192.168.1.200 homenet

We can specify the bridge name by adding -o com.docker.network.bridge.name=br-home-net to the previous command.
2. Bridge the bridge !

Now we have a bridge (br-[a-z0-9]+) created by Docker. We need to bridge it to a physical interface (in my case I have to NIC, so I'm using eth1 for that):

brctl addif br-home-net eth1

3. Delete the bridge IP

We can now delete the IP address from the bridge, since we don't need one :

ip a del 192.168.1.200/24 dev br-home-net

The IP 192.168.1.200 can be used as bridge on multiple docker host, since we don't use it, and we remove it.
```

```
Docker now supports Macvlan and IPvlan network drivers. The Docker documentation for both network drivers can be found here.

With both drivers you can implement your desired scenario (configure a container to behave like a virtual machine in bridge mode):

    Macvlan: Allows a single physical network interface (master device) to have an arbitrary number of slave devices, each with it's own MAC adresses.

    Requires Linux kernel v3.9–3.19 or 4.0+.

    IPvlan: Allows you to create an arbitrary number of slave devices for your master device which all share the same MAC address.

    Requires Linux kernel v4.2+ (support for earlier kernels exists but is buggy).

    See the kernel.org IPVLAN Driver HOWTO for further information.

```


* [How to configure a Docker container for acquiring DHCP IP/s from dhcp server running on ESX](https://stackoverflow.com/questions/43394826/how-to-configure-a-docker-container-for-acquiring-dhcp-ip-s-from-dhcp-server-run)  
```
In my docker container (docker image: opensuse) I am running a NFS server and hence need external access. I want the container to acquire dhcp IP from the dhcp server running on ESX (just like my Host VM gets).

I have tried pipework but could not get it working. Here is what I did:
```
```
You will need to create a docker network with the macvlan or ipvlan driver. Then you will need to use the DHCP IPAM driver (IPAM stands for IP Address Management).

Here is a gist with some explanations of how to do something similar: https://gist.github.com/nerdalert/3d2b891d41e0fa8d688c
```
* [Macvlan Global Driver](https://gist.github.com/nerdalert/847d7dba1699956bc700543f6f754c6b)  


* [ Container Networking: A Breakdown, Explanation and Analysis	14 Sep 2016](https://thenewstack.io/container-networking-breakdown-explanation-analysis/)  
```
Underlays

Underlay network drivers expose host interfaces (i.e., the physical network interface at eth0) directly to containers or VMs running on the host. Two such underlay drivers are media access control virtual local area network (MACvlan) and internet protocol VLAN (IPvlan). The operation of and the behavior of MACvlan and IPvlan drivers are very familiar to network engineers. Both network drivers are conceptually simpler than bridge networking, remove the need for port-mapping and are more efficient. Moreover, IPvlan has an L3 mode that resonates well with many network engineers. Given the restrictions — or lack of capabilities — in most public clouds, underlays are particularly useful when you have on-premises workloads, security concerns, traffic priorities or compliance to deal with, making them ideal for brownfield use. Instead of needing one bridge per VLAN, underlay networking allows for one VLAN per subinterface.
```

* [外部ネットワーク側からDockerコンテナに通信できる環境を作成する 2018-10-15](https://qiita.com/ttsubo/items/40162f5001a8c95040d9#1-ubuntuos%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E7%A2%BA%E8%AA%8D)  
![alt tag](https://camo.qiitausercontent.com/fba1a183c846ab0339656fe6eb60f5e1cc7b3ee0/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f3130333539352f30633863633233312d353261322d636364642d353662382d3037643665393464343631332e706e67)


* [jpetazzo/pipework](https://github.com/jpetazzo/pipework)  
```
Software-Defined Networking tools for LXC (LinuX Containers) 
```

* [dockerコンテナの中でホストマシンのIPアドレスを取り出す 2019-03-09](https://qiita.com/johejo/items/83cb83a885b8ac996ec9)   
```
結論
cat /etc/hosts | awk 'END{print $1}' | sed -r -e 's/[0-9]+$/1/g'
```

* [Docker + Linuxでいい感じに自宅・小規模オフィス用ルータを作る 2018-05-11](https://qiita.com/m_mizutani/items/d41b9c97b37535b2708c)  

* [jpetazzo/container.training](https://github.com/jpetazzo/container.training)  
```
Slides and code samples for training, tutorials, and workshops about containers.
```
http://container.training/  


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