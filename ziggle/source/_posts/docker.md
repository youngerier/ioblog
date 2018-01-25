---
title: docker
date: 2018-01-25 20:38:52
tags:
    - docker 
---


```javascript
    const port = 9999;
    let http = require('http');
    let server = http.createServer((req, res) => {
        res.end("hail hydra\n");
    })
    server.listen(port,()=>{
        console.log(`listen at ${port}`)
    })
```


```Dockerfile
FROM  node
RUN mkdir -p /home/app
WORKDIR /home/app

COPY . /home/app
EXPOSE 9999
CMD ["node","./server.js"]
```

```bash 
# build 
docker build -t appname .
# run 
docker run -d -p 9999:9999 appname  
```
