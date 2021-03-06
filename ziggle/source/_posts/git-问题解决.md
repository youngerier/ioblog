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

### Unstaging a Staged File

```git
git reset HEAD benchmarks.rb
```

### Unmodifying a Modified File

```git
git checkout --benchmarks.rb
```
### 怎样在一个分支拉去另一个分支的远程代码

```sh
git fetch <remote> <sourceBranch>:<destinationBranch>
git fetch origin master:master
```



### 找到一个被删除的文件并恢复

- Use git log --diff-filter=D --summary to get all the commits which have deleted files and the files deleted;
- Use git checkout $commit~1 path/to/file.ext to restore the deleted file.


linux /windows git status 显示不同

git config --global core.autocrlf true


### 
在默认设置下，中文文件名在工作区状态输出，查看历史更改概要，以及在补丁文件中，文件名的中文不能正确地显示，而是显示为八进制的字符编码，示例如下：
  $ git status -s
  ?? "\350\257\264\346\230\216.txt\n
   $ printf "\350\257\264\346\230\216.txt\n"

```
git config --global core.quotepath false
```