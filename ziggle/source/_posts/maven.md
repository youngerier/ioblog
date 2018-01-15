---
title: maven
date: 2018-01-15 12:44:29
tags:
    - maven
---

### 依赖scope

- compile：编译依赖范围，在编译，测试，运行时都需要，依赖范围默认值
- test：测试依赖范围，测试时需要。编译和运行不需要，如junit
- provided：已提供依赖范围，编译和测试时需要。运行时不需要,如servlet-api
- runtime：运行时依赖范围，测试和运行时需要。编译不需要,例如面向接口编程，JDBC驱动实现jar
- system：系统依赖范围。本地依赖，不在maven中央仓库，结合systemPath标签使用

### 依赖排除
使用<exclusions>标签下的<exclusion>标签指定GA信息来排除，例如：排除xxx.jar传递依赖过来的yyy.jar

```xml
<dependency>
  <groupId>com.xxx</groupId>
  <artifactId>xxx</artifactId>
  <version>x.version</version>
  <exclusions>
    <exclusion>
      <groupId>com.xxx</groupId>
      <artifactId>yyy</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

### maven 依赖包-SNAPSHOT / release
如果在一个项目中，我们依赖了模块A的快照版，还依赖了模块B的正式版本，那么在不更改依赖模块版本号的情况下，我们在进行直接编译打包该项目时：即使本地仓库中已经存在对应版本的依赖模块A，maven还是会自动从镜像服务器上下载最新的依赖模块A的快照版本。而依赖正式版本的模块B，如果本地仓库已经存在该版本的模块B, maven则不会主动去镜像服务器上下载。这也是为什么我们会在本地仓库中快照版本的依赖的目录下会看到带有时间戳的jar包
> 解决方法

```
mvn clean install -U
```
或者修改本地mvn配置文件的私服配置

```xml
    <profile>
        <id>nexus</id>
        <repositories>
            <repository>
                <id>nexus</id>
                <name>Nexus</name>
                <url>http://localhost:8087/nexus/content/groups/public/</url>
                <releases>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </snapshots>
            </repository>
        </repositories>
        <pluginRepositories>
            <pluginRepository>
                <id>nexus</id>
                <name>Nexus</name>
                <url>http://localhost:8087/nexus/content/groups/public/</url>
                <releases>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </snapshots>
            </pluginRepository>
        </pluginRepositories>
    </profile>
```