---
title: how-to-publish-jar-lib
date: 2019-01-21 16:18:51
tags:
---
## 使用gradle 发布 java 类库

- 使用 `maven` 插件
 
```
apply plugin: 'maven'
```

- 上传nexus地址
```groovy
uploadArchives {
    repositories {
        mavenDeployer {
            repository(url: "http://{ip:port}/repository/maven-snapshots/") {
                authentication(userName: "user", password: "password")
            }
            pom.version = version
            pom.artifactId = project.name
            pom.groupId = 'com.ziggle.test'
        }
    }
}
```

- 运行 `gradle uploadArchives`

## 注意

jar包的命名影响上传的仓库