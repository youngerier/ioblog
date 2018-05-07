---
title: stackoverflow-question
date: 2018-04-12 15:07:24
tags:
    - stackoverflow-questions
---

### 一行初始化ArrayList 
```java
ArrayList<String> places = new ArrayList<String>(){{
    add("A");
    add("B");
    add("C");
}};

List<String> places = Arrays.asList("Buenos Aires", "Córdoba", "La Plata");
```

### 使用maven创建带依赖的可执行jar 
```xml
<build>
  <plugins>
    <plugin>
      <artifactId>maven-assembly-plugin</artifactId>
      <configuration>
        <archive>
          <manifest>
            <mainClass>fully.qualified.MainClass</mainClass>
          </manifest>
        </archive>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
      </configuration>
    </plugin>
  </plugins>
</build>
<build>
  <plugins>
    <plugin>
      <artifactId>maven-assembly-plugin</artifactId>
      <configuration>
        <archive>
          <manifest>
            <mainClass>fully.qualified.MainClass</mainClass>
          </manifest>
        </archive>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
      </configuration>
    </plugin>
  </plugins>
</build>

```
and run 

> mvn clean compile assembly:single


###  判断数组是否包含指定元素

```java
int[] a = [1,2,3,4,5];
boolean contains = IntStream.of(a).anyMatch(x->x==3);
```
<!-- more -->
### 什么时候使用静态方法

{% blockquote [not-just-yeti[, source]] [https://stackoverflow.com/questions/2671496/java-when-to-use-static-methods] [source_link_title] %}
One rule-of-thumb: ask yourself "does it make sense to call this method, even if no Obj has been constructed yet?" If so, it should definitely be static.

So in a class Car you might have a method double convertMpgToKpl(double mpg) which would be static, because one might want to know what 35mpg converts to, even if nobody has ever built a Car. But void setMileage(double mpg) (which sets the efficiency of one particular Car) can't be static since it's inconceivable to call the method before any Car has been constructed.

(Btw, the converse isn't always true: you might sometimes have a method which involves two Car objects, and still want it to be static. E.g. Car theMoreEfficientOf( Car c1, Car c2 ). Although this could be converted to a non-static version, some would argue that since there isn't a "privileged" choice of which Car is more important, you shouldn't force a caller to choose one Car as the object you'll invoke the method on. This situation accounts for a fairly small fraction of all static methods, though.)
{% endblockquote %}




### 是不是final block 一定会被执行

是的, *final* 一定会被执行 除了 
1 调用 System.exit();
2 JVM 在执行final快前崩溃
3 try 块 又死循环 等
4 JVM 进行被强行终止
5 系统崩溃 ..
### java bean 是什么
JavaBean 是一个标准, 体格惯例
1 所有的属性都是private
2 有一个无参的构造函数
3 实现Serializable

### StringBuffer 与 StringBuilder 的区别
StringBuffer 是同步的 而 StringBuild不是

