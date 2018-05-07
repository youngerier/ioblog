---
title: git 问题解决
date: 2018-05-07 09:35:07
tags:
    -git
---

### git unable pull from remote 
```sh
muyue@wp-desk MINGW64 /d/code/LearnOnlineAPI (dev)
$ git pull
error: cannot lock ref 'refs/remotes/origin/feature/zbf': 'refs/remotes/origin/feature/zbf/Notice' exists; cannot create 'refs/remotes/origin/feature/zbf'
From http://git.xueanquan.cc/dotnet/live/LearnOnlineAPI
 ! [new branch]        feature/zbf -> origin/feature/zbf  (unable to update local ref)
```

- solution
```sh
$ git gc --prune=now
git remote prune origin
```
