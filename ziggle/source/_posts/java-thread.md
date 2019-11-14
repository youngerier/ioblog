---
title: java-thread
date: 2019-07-10 18:37:00
tags:
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