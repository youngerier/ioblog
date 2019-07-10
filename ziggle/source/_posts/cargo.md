---
title: cargo
date: 2019-05-27 11:23:49
tags:
---


## Cargo 代理配置

conf
```conf
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

```