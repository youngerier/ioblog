---
title: cargo
date: 2019-05-27 11:23:49
tags:
---

conf
```conf
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

[target.x86_64-pc-windows-gnu]
linker = "E:\\MinGw\\bin\\gcc.exe"
```