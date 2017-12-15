---
title: java-basic
date: 2017-12-15 10:19:56
tags:
---

Class.forName() 返回一个类JVM会加载制定的类,并执行类的静态代码段

A a = (A)Class.forName(“pacage.A”).newInstance();
通过包名和类名,实例对象


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