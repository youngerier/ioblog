---
title: iis express custom hostname
date: 2017-11-28 21:41:44
tags:
---
## 使用vs 2017 iisexpress 调试web项目是如果项目绑定某个域名 
### 这时候就需要编辑
```
$(solutionDir)\.vs\config\applicationhost.config
```
### 找到文件中site 节点
```xml
<site name=”MyWebApp” id=”2”>
    <application path=”/“ applicationPool=”Clr4IntegratedAppPool”>
        <virtualDirectory path="/" physicalPath="rpoject root path" />
    </application>
    <bindings>
        <binding protocol="http" bindingInformation="*:12345:customerhostname" />
    </bindings>
</site>
```
### 然后配置项目属性 更改project url .