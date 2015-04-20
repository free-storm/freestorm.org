---
title: 配置自己的 docker-registry 服务
date: 2015-04-20
author: Michael Ding
tags:
- 开发
- 效率
- 运维
---

鉴于 docker 官网在国内的访问速度，在我们(暴走漫画)大量地将开发/部署环境迁移到 docker 以后，我们考虑自建 docker registry 服务。

docker registry 的 github 地址是 [https://github.com/docker/docker-registry](https://github.com/docker/docker-registry)。是一个基于 python 写的 web service.

docker registry 最新的安装方式非常简单：`docker run -p 5000:5000 registry
`。
其实也就是：docker registry 被制作成了 docker image，在要跑 docker registry 的服务器上装好 docker，
用 docker 去跑 docker registry 服务。

因此我们可以利用 docker 的启动命令来启动符合自己需求的 registry 服务。

主要有：

### 1. 利用环境变量修改配置

例如，你需要设置 search_backend，可以为 `docker run` 增加参数：`-e SEARCH_BACKEND=sqlalchemy`

完整的环境变量对应的参数设置，可参见 [配置文件](https://github.com/docker/docker-registry/blob/master/config/config_sample.yml)

另外，docker 的配置还有一个 [Configuration flavors](https://github.com/docker/docker-registry#configuration-flavors)的概念。

这个概念允许你定义一些"运行模式"，不同的模式采用不同的配置。例如"development", "production"等等。

### 2. 利用自己的配置文件修改配置

你也可以编写自己的配置文件(参考 [默认配置文件](https://github.com/docker/docker-registry/blob/master/config/config_sample.yml)),
然后利用 `docker run` 的 `-v` 参数，将自己的配置文件映射到 container 里面去，并设置相应的环境变量(`DOCKER_REGISTRY_CONFIG`)，从而覆盖默认的配置。

```
sudo docker run -p 5000:5000 -v /home/me/myfolder:/registry-conf -e DOCKER_REGISTRY_CONFIG=/registry-conf/mysuperconfig.yml registry
```

### 3. 挂载数据卷

将 docker registry 存储 images 的路径映射出来是个明智的做法，这样即使重新创建 registry 的 container，也可以共用之前的 images

可以利用 `docker run` 的 `-v` 参数，将一个宿主系统的配置文件映射到 container 里面，并设置响应的环境变量(`STORAGE_PATH`)来实现。

```
sudo docker run -p 5000:5000 -e STORAGE_PATH=/registry -v /data/docker-registry:/registry registry
```
