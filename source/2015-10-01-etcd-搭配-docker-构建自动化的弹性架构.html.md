---
title: etcd 搭配 docker 构建自动化的弹性架构 - 暴走漫画容器实践系列 Part2
date: 2015-10-01
author: Michael Ding
tags:
- 分布式
- 运维
- 容器
- 暴走漫画容器实践系列
---

`etcd` 是一个高可用的分布式 key-value(键值) 存储系统。在暴漫我们用他用来做配置管理和服务发现。

这一次我们主要介绍我们是如何利用 `etcd` 和 `docker` 构建自动化的弹性架构的。
