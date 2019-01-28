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
## 全局配置
~/.gitconfig
```ini
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
[user]
	name = ziggle
	email = muyue1125@gmail.com
# [https]
# 	proxy = https://127.0.0.1:8087
# [http]
# 	proxy = http://127.0.0.1:8087
[merge]
	tool = vimdiff
[credential]
	helper = wincred


[alias]
	tree = log --oneline --decorate --all --graph

# [include]
#     path = 

```

### 别名 

```
git config --global alias.tree "log --oneline --decorate --all --graph"
```



### 代理



### 
```sh
$ git rm -r -n --cached "bin/"   ，此命令是展示要删除的文件表预览
```

## Unstaging a Staged File

```git
git reset HEAD benchmarks.rb
```

## Unmodifying a Modified File

```git
git checkout --benchmarks.rb
```
## 怎样在一个分支拉去另一个分支的远程代码

```sh
git fetch <remote> <sourceBranch>:<destinationBranch>
git fetch origin master:master
```