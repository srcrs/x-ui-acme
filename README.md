大家注意下不要再使用了，x-ui被莫名创建代理节点，具体用途不知道，现已不再使用了，有图为证，其中有台服务器创建了三个节点，每个都跑了150m流量，这是其中一台服务器的
![截屏2022-06-03 下午3 15 07](https://user-images.githubusercontent.com/49332985/171807171-2bf5ac01-9fb3-4b33-ac28-9591285471fb.png)


## 介绍

该项目依托于[docker](https://www.docker.com/)、[docker-compose](https://github.com/docker/awesome-compose)、[x-ui](https://github.com/vaxilu/x-ui)、[acme.sh](https://github.com/acmesh-official/acme.sh)，能够快速搭建出跳跃节点。

## 使用docker-compose示例

### docker-compose配置文件说明

```yml
version: '3'
services:
    acme.sh:
        image: neilpang/acme.sh
        restart: always
        volumes:
            - "$PWD/out:/acme.sh:z"
        environment:
            - CF_Key="xxxxxxxxxxxxxxxxxxxx"
            - CF_Email="xxxxxxxx@gmail.com"
        command: daemon
    x-ui:
        image: srcrs/x-ui
        restart: always
        network_mode: "host"
        volumes:
            - "$PWD/out:/root/out"
        command:
            - /bin/bash
            - -c
            - |
                x-ui start
                sleep infinity
```

CF_Key位于[api-tokens](https://dash.cloudflare.com/profile/api-tokens)页，Global API Key。

CF_Email是cloudflare登陆的邮箱。

out文件夹用于存储acme生成的证书。

### 生成域名证书

```sh
#注册邮箱
docker-compose run acme.sh --register-account -m xxxxxx@gmail.com --debug
#以下二选一
#泛域名证书
docker-compose run acme.sh --issue --dns dns_cf -d mytest.com -d *.mytest.com --debug
#单独域名证书
docker-compose run acme.sh --issue --dns dns_cf -d proxy.mytest.com --debug
```

## 使用docker示例

### 运行x-ui

```sh
docker run -itd --name x-ui --privileged --restart always -v $PWD/out:/root/out --network host srcrs/x-ui bash -c "x-ui start && sleep infinity"
```

### 运行acme.sh

```sh
docker run -itd --name acme.sh --privileged --restart always -v $PWD/out:/root/out neilpang/acme.sh daemon
```

### 生成域名证书

```sh
#注册邮箱
docker exec acme.sh --register-account -m xxxxxx@gmail.com --debug
#以下二选一
#泛域名证书
docker exec acme.sh --issue --dns dns_cf -d mytest.com -d *.mytest.com --debug
#单独域名证书
docker exec acme.sh --issue --dns dns_cf -d proxy.mytest.com --debug
```

## 登陆x-ui面板

默认使用端口为54321，用户名和密码都为admin。

登陆地址: ip:54321

## 添加tls节点证书路径

添加节点为tls或者tls+cdn模式时，需要在x-ui面板填写对应的证书路径，使用时mytest.com换成对应的代理域名即可。

公钥文件路径 /root/out/mytest.com/mytest.com.cer

密钥文件路径 /root/out/mytest.com/mytest.com.key

使用docker只需要找到对应的镜像，取执行命令效果一样。

需要注意的是，域名要被cloudfale代理，参考文章[CloudFlare免费CDN加速使用方法](https://zhuanlan.zhihu.com/p/29891330)。

## 致谢

- [docker](https://www.docker.com/)
- [docker-compose](https://github.com/docker/awesome-compose)
- [x-ui](https://github.com/vaxilu/x-ui)
- [acme.sh](https://github.com/acmesh-official/acme.sh)
