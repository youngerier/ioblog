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

Gradle在构建的各个阶段都提供了很多回调，我们在添加对应监听时要注意，监听器一定要在回调的生命周期之前添加，比如我们在根项目的build.gradle中添加下面的代码就是错误的：
```groovy
gradle.settingsEvaluated { setting ->
  // do something with setting
}

gradle.projectsLoaded { 
  gradle.rootProject.afterEvaluate {
    println 'rootProject evaluated'
  }
}
```
当构建走到build.gradle时说明初始化过程已经结束了，所以上面的回调都不会执行，把上述代码移动到settings.gradle中就正确了。

通过一些例子来解释如何Hook Gradle的构建过程。
#### 为所有子项目添加公共代码
 在根项目的build.gradle中添加如下代码：

```groovy
 gradle.beforeProject { project ->
  println 'apply plugin java for ' + project
  project.apply plugin: 'java'
}
 ```

 这段代码的作用是为所有子项目应用Java插件，因为代码是在根项目的配置阶段执行的，所以并不会应用到根项目中。
这里说明一下Gradle的beforeProject方法和Project的beforeEvaluate的执行时机是一样的，只是beforeProject应用于所有项目，而beforeEvaluate只应用于调用的Project，上面的代码等价于

```groovy
allprojects {
  beforeEvaluate { project ->
    println 'apply plugin java for ' + project
    project.apply plugin: 'java'
  }
}
```

after***也是同理的，但afterProject还有一点不一样，无论Project的配置过程是否出错，afterProject都会收到回调

#### 为指定Task动态添加Action

```groovy
 gradle.taskGraph.beforeTask { task ->
  task << {
    println '动态添加的Action'
  }
}

task Test {
  doLast {
    println '原始Action'
  }
}
```

##### 获取构建各阶段耗时情况
```groovy
long beginOfSetting = System.currentTimeMillis()

gradle.projectsLoaded {
  println '初始化阶段，耗时：' + (System.currentTimeMillis() - beginOfSetting) + 'ms'
}

def beginOfConfig
def configHasBegin = false
def beginOfProjectConfig = new HashMap()
gradle.beforeProject { project ->
  if (!configHasBegin) {
    configHasBegin = true
    beginOfConfig = System.currentTimeMillis()
  }
  beginOfProjectConfig.put(project, System.currentTimeMillis())
}
gradle.afterProject { project ->
  def begin = beginOfProjectConfig.get(project)
  println '配置阶段，' + project + '耗时：' + (System.currentTimeMillis() - begin) + 'ms'
}
def beginOfProjectExcute
gradle.taskGraph.whenReady {
  println '配置阶段，总共耗时：' + (System.currentTimeMillis() - beginOfConfig) + 'ms'
  beginOfProjectExcute = System.currentTimeMillis()
}
gradle.taskGraph.beforeTask { task ->
  task.doFirst {
    task.ext.beginOfTask = System.currentTimeMillis()
  }
  task.doLast {
    println '执行阶段，' + task + '耗时：' + (System.currentTimeMillis() - task.beginOfTask) + 'ms'
  }
}
gradle.buildFinished {
  println '执行阶段，耗时：' + (System.currentTimeMillis() - beginOfProjectExcute) + 'ms'
}
```
将上述代码段添加到settings.gradle脚本文件的开头，再执行任意构建任务，你就可以看到各阶段、各任务的耗时情况。

#### 动态改变Task依赖关系
有时我们需要在一个已有的构建系统中插入我们自己的构建任务，比如在执行Java构建后我们想要删除构建过程中产生的临时文件，那么我们就可以自定义一个名叫cleanTemp的任务，让其依赖于build任务，然后调用cleanTemp任务即可。
- 寻找插入点
如果你对一个构建的任务依赖关系不熟悉的话，可以使用一个插件来查看，在根项目的build.gradle中添加如下代码:
```
plugins{
    id "com.dorongold.task-tree" version "1.5"
}
```

然后执行`gradle <任务名> taskTree --no-repeat`，即可看到指定Task的依赖关系，比如在Java构建中查看build任务的依赖关系：

- 动态插入自定义任务

我们先定义一个自定的任务cleanTemp，让其依赖于assemble。
```
task cleanTemp(dependsOn: assemble) {
  doLast {
    println '清除所有临时文件'
  }
}

afterEvaluate {
  build.dependsOn cleanTemp
}
```
