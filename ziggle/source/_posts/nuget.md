---
title: nuget
date: 2019-05-27 10:19:02
tags:
---


## 本地仓库指定路径

%AppData%\NuGet\nuget.config
```xml

<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    <!-- <add key="repo" value="http://192.168.2.85/repository/nuget.org-proxy/" /> -->
    <!-- <add key="cps" value="D:\vcpkg\scripts\buildsystems" /> -->
    <add key="Microsoft Visual Studio Offline Packages" value="C:\Program Files (x86)\Microsoft SDKs\NuGetPackages\" />
  </packageSources>
  <disabledPackageSources>
    <add key="repo" value="true" />
  </disabledPackageSources>
  <packageRestore>
    <add key="enabled" value="True" />
    <add key="automatic" value="True" />
  </packageRestore>
  <bindingRedirects>
    <add key="skip" value="False" />
  </bindingRedirects>
  <packageManagement>
    <add key="format" value="0" />
    <add key="disabled" value="False" />
  </packageManagement>

  <config>
    <add key="repositoryPath" value="E:\nugetpackage\.nuget\packages" />
    <add key="globalPackagesFolder" value="E:\nugetpackage\.nuget\packages" />
  </config>
</configuration>
```
添加 
```xml
    <add key="globalPackagesFolder" value="E:\nugetpackage\.nuget\packages" />
```
