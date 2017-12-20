---
title: java-basic
date: 2017-12-15 10:19:56
tags:
---

Class.forName() 返回一个类JVM会加载制定的类,并执行类的静态代码段

A a = (A)Class.forName(“pacage.A”).newInstance();
A a = new A()
通过包名和类名,实例对象

String className = readfromXMLConfig;
class c = Class.forName(className);
factory = (Exampleinterface)c.newInstence();
> 使用newInstance() 要保证:
* 类已经加载
* 类已经连接

使用Class类的静态方法forName 完成这两步
- newInstance(): 弱类型,低效率,只能调用无参构造。
- new: 强类型,相对高效,能调用任何public构造。
- Class.forName(“”)返回的是类。
- Class.forName(“”).newInstance()返回的是object 。
## ReentrantLock
ReentrantLock是一个基于AQS的可重入的互斥锁，
公平锁将确保等待时间最长的线程优先获取锁，将会使整体的吞吐量下降
非公平锁将不能确定哪一个线程将获取锁，可能会导致某些线程饥饿。

```java
public class ReentrantLockTest {
    private final ReentrantLock lock = new ReentrantLock();
    // ...

    public void doSomething() {
        lock.lock();  // block until condition holds
        try {
            // ... method body
        } finally {
            lock.unlock();
        }
    }
}
```

<!-- more -->