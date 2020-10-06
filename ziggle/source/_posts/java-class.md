---
title: java-class
date: 2018-01-19 12:56:29
tags:
    - class 
---

Static：

加载：java虚拟机在加载类的过程中为静态变量分配内存。
类变量：static变量在内存中只有一个，存放在方法区，属于类变量，被所有实例所共享
销毁：类被卸载时，静态变量被销毁，并释放内存空间。static变量的生命周期取决于类的生命周期
类初始化顺序：

静态变量、静态代码块初始化
构造函数
自定义构造函数
结论：想要用static存一个变量，使得下次程序运行时还能使用上次的值是不可行的。因为静态变量生命周期虽然长（就是类的生命周期），但是当程序执行完，也就是该类的所有对象都已经被回收，或者加载类的ClassLoader已经被回收，那么该类就会从jvm的方法区卸载，即生命期终止。

更进一步来说，static变量终究是存在jvm的内存中的，jvm下次重新运行时，肯定会清空里边上次运行的内容，包括方法区、常量区的内容。

要实现某些变量在程序多次运行时都可以读取，那么必须要将变量存下来，即存到本地文件中。常用的数据存取格式：XML、JSON、Propertities类（类似map的键值对）等


碰到一个类需要加载时，它们之间是如何协调工作的，即java是如何区分一个类该由哪个类加载器来完成呢。 在这里java采用了委托模型机制，这个机制简单来讲，就是“类装载器有载入类的需求时，会先请示其Parent使用其搜索路径帮忙载入，如果Parent 找不到,那么才由自己依照自己的搜索路径搜索类”

```java
public class Test{

    public static void main(String[] arg){

      ClassLoader c  = Test.class.getClassLoader();  //获取Test类的类加载器

        System.out.println(c); 

      ClassLoader c1 = c.getParent();  //获取c这个类加载器的父类加载器

        System.out.println(c1);

      ClassLoader c2 = c1.getParent();//获取c1这个类加载器的父类加载器

        System.out.println(c2);

  }

}

/**
sun.misc.Launcher$AppClassLoader@73d16e93
sun.misc.Launcher$ExtClassLoader@15db9742
null
 */
```

|          | 成员变量       | 局部变量                  | 静态变量           |
| :------- | :------------- | ------------------------: | :----------------: |
| 定义位置 | 在类中,方法外  | 方法中,或者方法的形式参数 | 在类中,方法外      |
| 初始化值 | 有默认初始化值 | 无,先定义,赋值后才能使用  | 有默认初始化值     |
| 调用方式 | 对象调用       | -----                     | 对象调用，类名调用 |
| 存储位置 | 堆中           | 栈中                      | 方法区             |
| 生命周期 | 与对象共存亡   | 与方法共存亡              | 与类共存亡         |
| 别名     | 实例变量       | ------                    | 类变量             |


## 枚举实现的单例类

```java
public enum Singleton{
  Instance;
  private String name;
  Singleton(){
    this.name="name";
  }
  public static Singleton getInstance(){
    return Instance;
  }

  public String getName(){
    return this.name;
  }
}
```

### java 对象的创建过程

加载 分配内存 初始化零值 设置对象头 执行`<init>`方法

- 类加载检查 执行new指令时, 先去检查这个指令是否能在常量池中定位到这个类的符号引用,并且检查这个符号引用是否已经被加载,解析 初始化过, 如果没有就先执行
- 分配内存,
- 初始化零值
- 设置对象头 类的元数据信息引用, 对象hashcode ,GC分代,锁的级别
- 执行`<init>`方法


