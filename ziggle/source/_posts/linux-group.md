---
title: 'linux group '
date: 2018-05-07 16:57:56
tags:
    - linux
---

```sh
root@ziggle:~# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
....

```
/etc/passwd 中各个字段表示的信息 用:分割
- 通过用户类型分组，我们可以把用户分为：
    - `管理员`
    - `普通用户`
- 通过用户组类型分组，我们可以把用户组分为：
    - `管理员组`
    - `普通用户组`
- 从用户的角度，我们可以把用户组分为：
    - `基本组（默认组）`
    - `额外组（附加组）`
- 对于普通用户，我们还可以分为:
    - `系统用户`
    - `普通用户`
- 因此，对于普通用户组，我们也可以分为：
    - `系统用户组`
    - `普通用户组`
### /etc/passwd 中各字段含义
account  : 用户名
password :密码占位符 [(x)](#passwd)
uid      : 用户ID
gid      : 用户组ID
command  : 注释信息
home dir : 用户家目录
shell    : 用户默认shell

#### 密码 /etc/shadow
<a href="#passwd"></a>

### useradd

- useradd -u UID：指定 UID，这个 UID 必须是大于等于500，并没有其他用户占用的 UID
- useradd -g GID/GROUPNAME：指定默认组，可以是 GID 或者 GROUPNAME，同样也必须真实存在
- useradd -G GROUPS：指定额外组
- useradd -c COMMENT：指定用户的注释信息
- useradd -d PATH：指定用户的家目录
- useradd -s SHELL：指定用户的默认 shell，最好是在 /etc/shells 中存在的路径
- useradd -s /sbin/nologin：该用户不能登录，还记得我们上面说到的系统用户不能登录吧？我们可以看到系统用户的 shell 字段也是 /sbin/nologin
- echo $SHELL ：查看当前用户的 shell 类型
- useradd -M USERNAME：创建用户但不创建家目录
- useradd -mk USERNAME：创建用户的同时创建家目录，并复制 /etc/skel 中的内容到家目录中。关于 /etc/skel 目录会在下一篇 Linux 权限管理中再次讲解。
如果用户没有家目录，那么不能切换到该用户

### userdel

- userdel [username]  :  删除用户
- userdel -r [username] : 删除用户同时删除用户家目录