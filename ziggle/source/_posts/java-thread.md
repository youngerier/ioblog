---
title: java-thread
date: 2019-07-10 18:37:00
tags:
- thread
---

### 终止线程的方法
#### 使用退出标志退出线程
#### Interrupt 方法结束线程
```java
 public class ThreadSafe extends Thread {
    public void run() {
        while (!isInterrupted()){ //非阻塞过程中通过判断中断标志来退出
            try{
                Thread.sleep(5*1000);//阻塞过程捕获中断异常来退出
            }catch(InterruptedException e){
                e.printStackTrace();
                break;//捕获到异常之后，执行 break 跳出循环
            }
        }
    }
}
```
#### sleep 与 wait 区别
1. 对于 sleep()方法，我们首先要知道该方法是属于 Thread 类中的。而 wait()方法，则是属于
Object 类中的。
2. sleep()方法导致了程序暂停执行指定的时间，让出 cpu 该其他线程，但是他的监控状态依然
保持者，当指定的时间到了又会自动恢复运行状态。
3. 在调用 sleep()方法的过程中，线程不会释放对象锁。
4. 而当调用 wait()方法的时候，线程会放弃对象锁，进入等待此对象的等待锁定池，只有针对此
对象调用 notify()方法后本线程才进入对象锁定池准备获取对象锁进入运行状态

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
##### volatail

比 sychronized 更轻量级的同步锁
在访问 volatile 变量时不会执行加锁操作，因此也就不会使执行线程阻塞，因此 volatile 变量是一
种比 sychronized 关键字更轻量级的同步机制。volatile 适合这种场景：一个变量被多个线程共
享，线程直接给这个变量赋值。

当对非 volatile 变量进行读写的时候，每个线程先从内存拷贝变量到 CPU 缓存中。如果计算机有
多个 CPU，每个线程可能在不同的 CPU 上被处理，这意味着每个线程可以拷贝到不同的 CPU
cache 中。而声明变量是 volatile 的，JVM 保证了每次读变量都从内存中读，跳过 CPU cache
这一步。

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

#### Java 锁

##### 乐观锁
乐观锁是一种乐观思想，即认为读多写少，遇到并发写的可能性低，每次去拿数据的时候都认为
别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数
据，采取在写时先读出当前版本号，然后加锁操作（比较跟上一次的版本号，如果一样则更新），
如果失败则要重复读-比较-写的操作。
java 中的乐观锁基本都是通过 CAS 操作实现的，CAS 是一种更新的原子操作，比较当前值跟传入
值是否一样，一样则更新，否则失败。

##### 悲观锁
悲观锁是就是悲观思想，即认为写多，遇到并发写的可能性高，每次去拿数据的时候都认为别人
会修改，所以每次在读写数据的时候都会上锁，这样别人想读写这个数据就会 block 直到拿到锁。
java中的悲观锁就是Synchronized,AQS框架下的锁则是先尝试cas乐观锁去获取锁，获取不到，
才会转换为悲观锁，如 RetreenLock

##### 自旋锁
自旋锁原理非常简单，如果持有锁的线程能在很短时间内释放锁资源，那么那些等待竞争锁
的线程就不需要做内核态和用户态之间的切换进入阻塞挂起状态，它们只需要等一等（自旋），
等持有锁的线程释放锁后即可立即获取锁，这样就避免用户线程和内核的切换的消耗。
线程自旋是需要消耗 cup 的，说白了就是让 cup 在做无用功，如果一直获取不到锁，那线程
也不能一直占用 cup 自旋做无用功，所以需要设定一个自旋等待的最大时间。
如果持有锁的线程执行的时间超过自旋等待的最大时间扔没有释放锁，就会导致其它争用锁
的线程在最大等待时间内还是获取不到锁，这时争用线程会停止自旋进入阻塞状态。

自旋锁的优缺点
自旋锁尽可能的减少线程的阻塞，这对于锁的竞争不激烈，且占用锁时间非常短的代码块来
说性能能大幅度的提升，因为自旋的消耗会小于线程`阻塞挂起再唤醒`的操作的消耗，这些操作会
导致线程发生`两次上下文切换`！
但是如果锁的竞争激烈，或者持有锁的线程需要长时间占用锁执行同步块，这时候就不适合
使用自旋锁了，因为自旋锁在获取锁前一直都是占用 cpu 做无用功，占着 XX 不 XX，同时有大量
线程在竞争一个锁，会导致获取锁的时间很长，线程自旋的消耗大于线程阻塞挂起操作的消耗，
其它需要 cup 的线程又不能获取到 cpu，造成 cpu 的浪费。所以这种情况下我们要关闭自旋锁