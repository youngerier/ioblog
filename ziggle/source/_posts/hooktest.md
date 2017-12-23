---
title: hooktest
date: 2017-12-15 19:22:36
tags:
    - autodeploy
---

# deploy

> node webhook script 
通过GitHub webhook 同步博客


```javascript
var http = require('http');
var exec = require('child_process').exec;



var server = http.createClient((req,res)=>{
    if(req.url==='webhooks/push'){
        exec("")
        console.log(123);
    }
});
server.listen(4000)
```
