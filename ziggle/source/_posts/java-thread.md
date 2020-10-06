---
title: java-thread
date: 2019-07-10 18:37:00
tags:
- thread
---

ref = `https://mrbird.cc/JUC-CyclicBarrier.html`
### JUC之CyclicBarrier

CyclicBarrier的字面意思是可循环使用（Cyclic）的屏障（Barrier）。它要做的事情是，让一组线程到达一个屏障（也可以叫同步点）时被阻塞，直到最后一个线程到达屏障时，屏障才会开门，所有被屏障拦截的线程才会继续运行。CyclicBarrier默认的构造方法是CyclicBarrier(int parties)，其参数表示屏障拦截的线程数量，每个线程调用await方法告诉CyclicBarrier我已经到达了屏障，然后当前线程被阻塞。

#### CyclicBarrier的构造函数支持传入一个回调方法：

```java
CyclicBarrier barrier = new CyclicBarrier(n, () -> {
    System.out.println("当所有线程到达屏障时，执行该回调");
});
```

####  设置超时时间

await的重载方法：await(long timeout, TimeUnit unit)可以设置最大等待时长，超出这个时间屏障还没有开启的话则抛出TimeoutException：

#### BrokenBarrierException

抛出BrokenBarrierException异常时表示屏障破损，此时标志位broken=true。抛出BrokenBarrierException异常的情况主要有：

- 其他等待的线程被中断，则当前线程抛出BrokenBarrierException异常；
- 其他等待的线程超时，则当前线程抛出BrokenBarrierException异常；
- 当前线程在等待时，其他线程调用CyclicBarrier.reset()方法，则当前线程抛出BrokenBarrierException异常。


#### 和CountDownLatch区别
- CountDownLatch：一个线程(或者多个)，等待另外N个线程完成某个事情之后才能执行；CyclicBarrier：N个线程相互等待，任何一个线程完成之前，所有的线程都必须等待。

- CountDownLatch：一次性的；CyclicBarrier：可以重复使用。


### JUC之CountDownLatch
`CountDownLatch`允许一个或多个线程等待其他线程完成操作。定义`CountDownLatch`的时候，需要传入一个正数来初始化计数器（虽然传入0也可以，但这样的话CountDownLatch没什么实际意义）。其countDown方法用于递减计数器，await方法会使当前线程阻塞，直到计数器递减为0。所以`CountDownLatch`常用于多个线程之间的协调工作。


#### threadpool 关闭方法
```java
    threadPool.shutdown(); // Disable new tasks from being submitted
        // 设定最大重试次数
        try {
            // 等待 60 s
            if (!threadPool.awaitTermination(60, TimeUnit.SECONDS)) {
                // 调用 shutdownNow 取消正在执行的任务
                threadPool.shutdownNow();
                // 再次等待 60 s，如果还未结束，可以再次尝试，或则直接放弃
                if (!threadPool.awaitTermination(60, TimeUnit.SECONDS))
                    System.err.println("线程池任务未正常执行结束");
            }
        } catch (InterruptedException ie) {
            // 重新调用 shutdownNow
            threadPool.shutdownNow();
        }
```


### 线程池 
调用 Executor 的 shutdown() 方法会等待线程都执行完毕之后再关闭，但是如果调用的是 shutdownNow() 方法，则相当于调用每个线程的 interrupt() 方法。
以下使用 Lambda 创建线程，相当于创建了一个匿名内部线程。

```java
public static void main(String[] args) {
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.execute(() -> {
        try {
            Thread.sleep(2000);
            System.out.println("Thread run");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });
    executorService.shutdownNow();
    System.out.println("Main run");
}
```
```java
Main run
java.lang.InterruptedException: sleep interrupted
    at java.lang.Thread.sleep(Native Method)
    at ExecutorInterruptExample.lambda$main$0(ExecutorInterruptExample.java:9)
    at ExecutorInterruptExample$$Lambda$1/1160460865.run(Unknown Source)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
    at java.lang.Thread.run(Thread.java:745)
```
如果只想中断 Executor 中的一个线程，可以通过使用 submit() 方法来提交一个线程，它会返回一个 Future<?> 对象，通过调用该对象的 cancel(true) 方法就可以中断线程。

```java
Future<?> future = executorService.submit(() -> {
    // ..
});
future.cancel(true);
```


### Java并发之线程中断

线程在不同状态下对于中断所产生的反应
     线程一共6种状态，分别是NEW，RUNNABLE，BLOCKED，WAITING，TIMED_WAITING，TERMINATED（Thread类中有一个State枚举类型列举了线程的所有状态）。下面我们就将把线程分别置于上述的不同种状态，然后看看我们的中断操作对它们的影响。

1、NEW和TERMINATED
     线程的new状态表示还未调用start方法，还未真正启动。线程的terminated状态表示线程已经运行终止。这两个状态下调用中断方法来中断线程的时候，Java认为毫无意义，所以并不会设置线程的中断标识位，什么事也不会发生。例如：
```java
public static void main(String[] args) throws InterruptedException {

    Thread thread = new MyThread();
    System.out.println(thread.getState());

    thread.interrupt();

    System.out.println(thread.isInterrupted());
}
```

#### 什么是上下文切换

多线程编程中线程数一般大于cpu的个数, 而一个cpu在任意时刻只能被一个线程使用,为了让这些线程都可以有效执行, cpu采用的是为每个线程分配时间片并轮转的形式, 当一个线程的时间片用完的时候就会重新处于就绪状态让其他线程使用,这个过程就是一次上下文切换

当cpu切换到另一个任务之前会先保存自己的状态, 以便于切换回这个任务, 任务从保存到在加载的过程就是一次上下文切换


#### synchronized
使用方式
1 修饰实例方法, 
```java

public class Singleton{
 // 禁止指令重排
 private volatile static Singleton instance;

 private Singletion(){}

 public static Signleton getInstance(){
    // 没有初始化才进行下面逻辑
     if(instance !=null ){
         synchronized(Singleton.class){
             if(instance  == null){
                 instance = new Singleton
             }
         }
     }
     return instance;
 }   
}
```
字节码
使用monitorenter monitorexit 指令, 


synchronized /ReentrantLock
- 都是可重入锁, 自己可以再次获取自己的内部锁, 比如一个线程获取某个对象的锁, 这个对象的锁还没有释放, 当再次获取这个锁的时候还是可以获取的
- sync.. 依赖于jvm ReentrantLock java实现(lock(),unlock() ,try/finally 实现)
- ReentrantLock 添加了一些高级功能, 等待可中断, 可以实现公平锁, 可以实现选择性通知
- ReentrantLock 可以指定是公平锁还是非公平锁 默认非公平锁, synchronized 只能是非公平锁
- 性能已经不是主要选择项


#### ThreadPoolExecutor 饱和策略定义

AbortPolicy
CallerRunsPolicy
DiscardPolicy
DiscardOldPolicy