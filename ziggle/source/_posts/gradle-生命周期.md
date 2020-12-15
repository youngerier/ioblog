---
title: gradle-生命周期
date: 2020-12-15 09:35:52
tags:
---

### 构建的生命周期

任何Gradle的构建过程都分为三部分：初始化阶段、配置阶段和执行阶段。

通过如下代码向Gradle的构建过程添加监听：
```groovy
gradle.addBuildListener(new BuildListener() {
  void buildStarted(Gradle var1) {
    println '开始构建'
  }
  void settingsEvaluated(Settings var1) {
    println 'settings评估完成（settins.gradle中代码执行完毕）'
    // var1.gradle.rootProject 这里访问Project对象时会报错，还未完成Project的初始化
  }
  void projectsLoaded(Gradle var1) {
    println '项目结构加载完成（初始化阶段结束）'
    println '初始化结束，可访问根项目：' + var1.gradle.rootProject
  }
  void projectsEvaluated(Gradle var1) {
    println '所有项目评估完成（配置阶段结束）'
  }
  void buildFinished(BuildResult var1) {
    println '构建结束 '
  }
})
```

hook 点

{% asset_img gradle-hook.png Gradle构建周期中的Hook点%}