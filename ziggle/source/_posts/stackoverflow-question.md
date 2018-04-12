---
title: stackoverflow-question
date: 2018-04-12 15:07:24
tags:
    -stackoverflow questions
---

### 一行初始化ArrayList 

ArrayList<String> places = new ArrayList<String>(){{
    add("A");
    add("B");
    add("C");
}};

List<String> places = Arrays.asList("Buenos Aires", "Córdoba", "La Plata");


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
and run 
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
> mvn clean compile assembly:single


###  判断数组是否包含指定元素

```java
int[] a = [1,2,3,4,5];
boolean contains = IntStream.of(a).anyMatch(x->x==3);
```