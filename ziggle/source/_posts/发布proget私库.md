---
title: 发布proget私库
date: 2017-11-29 18:25:15
tags: nuget ,netcore
---
------------

# 发布proget私库

## 1. 生成 .nupkg 文件

项目根目录运行

```nil
 nuget pack .\[library-project.csproj] -Build -Properties owners=ziggle;version="1.0.0"
```

## 2. push包到proget

```nil
nuget push  .\[library-project.1.0.0.nupkg]  -source https://api.nuget.org/v3/index.json -apikey [your-secoret-key]
```

> netcore 使用

```nil
dotnet pack  -c Release
``` 
> push 

```nil
dotnet nuget push  .\[library-project.1.0.0.nupkg]  -source https://api.nuget.org/v3/index.json -apikey [your-secoret-key]
```

------------

> [参考](http://www.cnblogs.com/lovecsharp094/p/5527204.html "参考")


> [nuget](https://docs.microsoft.com/en-us/nuget/tools/nuget-exe-cli-reference "使用 nuget ")

> [netcore](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-pack?tabs=netcore2x "使用 netcore")

