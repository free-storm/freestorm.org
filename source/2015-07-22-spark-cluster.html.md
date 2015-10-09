---
title: Spark 集群概述
date: 2015-07-22
author: Michael Ding
tags:
- Spark
- 数据挖掘
---

本篇博客简述 Spark 集群相关的概念。

Spark 的"集群"不是提供运算服务的，而是一种资源分配的调度器。
执行任务的 Spark 进程作为客户端向"集群"申请资源(运算节点), "集群"分配资源以后，
这个 Spark 进程会分解一些计算工作，并把他们放到这些申请来的资源中运行。

要执行的 Spark 任务称做 application(应用)，发起 application 的程序称作 driver program。
driver program 向"集群"申请到得运算节点称作 worker node。一旦申请到 worker node,
driver program 会连接这些 worker node, 并在 worker node 上取得(acquire)执行计算的进程(executor)。
driver program 通过 SparkContext 对象来协调
接下来 driver program 将计算需要的代码和数据发给 executor 并
过程如下图所示：

![Spark Cluster Overview](spark-cluster-overview.png)
