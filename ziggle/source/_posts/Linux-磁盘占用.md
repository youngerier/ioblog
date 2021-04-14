---
title: Linux 磁盘占用
date: 2020-01-16 16:27:57
tags:
- linux
---


### 查看文件夹文件大小

```bash
du -h --max-depth=1 /var/log
```

或者

```bash
cd /
du  -sh *
```

- 当前目录的磁盘占用

```bash
du -sh ./*
```

#### 处理文件删除问题

应该是删除了这些文件，但是空间没有释放，当然重启可以解决目的，但是会造成服务器上所有业务中断，可使用下面命令查看删除文件占用情况：

```bash
[root@ziggle]# lsof |grep delete
```

### 磁盘扩容

 @see `https://help.aliyun.com/knowledge_detail/111738.html`

- 运行fdisk -l命令查看现有云盘大小。以下示例返回云盘（/dev/vda）容量是100GiB。

```bash
fdisk -l
```

- 运行df -h命令查看云盘分区大小。以下示例返回分区（/dev/vda1）容量是20GiB。

```bash
df -h
```

- 运行growpart `<DeviceName> <PartionNumber>`命令调用growpart为需要扩容的云盘和对应的第几个分区扩容。示例命令表示为系统盘的第一个分区扩容。 若运行命令后报以下错误，您可以运行LANG=en_US.UTF-8切换ECS实例的字符编码类型。

```bash
growpart /dev/vda 1

---
# LANG=en_US.UTF-8
```

- 运行resize2fs <PartitionName>命令调用resize2fs扩容文件系统。示例命令表示为扩容系统盘的/dev/vda1分区文件系统。

```bash
resize2fs /dev/vda1
```

```

df -h   #整个磁盘空间
du -h --max-depth=1  #看当前目录各子目录占用空间
du -h -d 1 #同上，适用于mac系统
```
