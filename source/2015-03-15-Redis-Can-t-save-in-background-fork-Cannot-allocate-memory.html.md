---
title: Redis 相关的 Linux 内核参数
date: 2015-03-15
author: Michael Ding
tags:
- 数据库
- Redis
---

## 问题 1

默认情况下，redis 的持久化方案是 RDB，对于数据丢失的风险相对较高。
如果对于持久化要求较高，一般会使用 AOF。

不过使用 AOF 后，正常情况下，总会碰到 `Can’t save in background: fork: Cannot allocate memory` 这样的错误。

这个错误会出现的原因如下：

Redis 的后台持久化基于操作系统 `fork` 的 `copy-on-write`特性。redis 会 fork 一个子进程，这个子进程是
父进程的完整拷贝。然后这个子进程将数据库中的数据报存到磁盘上，完成后销毁。所以，理论上子进程需要消耗和父进程同样多的内存。
然而，由于 `copy-on-write`，父子进程其实会共享内存区块。只有父进程中发生了变化的内存区块才会被真正拷贝。
由于理论上，所有的内存区块的数据都是有可能变化的，所以 Linux 并不能事先知道子进程到底真正要消耗多少内存。
所以如果 Linux 的内核参数 `overcommit_memory` 设置成 `0` 的话，除非空闲内存比父进程占用的内存还要多，
否则 `fork` 就会失败。只有当 `overcommit_memory` 被设置成 `1`，Linux 才会尝试去 `fork`。

## 方案 1

思路：将 `overcommit_memory` 设置成 `1`

#### 方法 1.1

```
echo 1 > /proc/sys/vm/overcommit_memory
```

#### 方法 1.2

```
sysctl vm.overcommit_memory=1
```

#### 方法 1.3

```
echo 'vm.overcommit_memory=1' > /etc/sysctl.d/60-vm-memory.conf
service procps start
```

**注意** 60开头的文件中的设置会最晚被执行


## 问题 2

可能导致 Redis 意外崩溃的 Redis 参数设置

## 方案 2

### net.core.somaxconn
```
you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
```

```
echo 'net.core.somaxconn=256' > /etc/sysctl.d/60-net.conf
service procps start
```

### transparent huge page
```
you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
```

```
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```
