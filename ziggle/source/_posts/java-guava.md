---
title: java-guava
date: 2019-07-10 19:33:38
tags:
---


### `RateLimiter`

#### 基本使用

```java
public class RateLimiterTest {
    // 1秒钟产生0.5张令牌
    private final static RateLimiter limiter = RateLimiter.create(0.5);

    public static void main(String[] args) {
        ExecutorService service = Executors.newFixedThreadPool(5);
        IntStream.range(0, 5).forEach(i -> service.submit(RateLimiterTest::testLimiter));
        service.shutdown();
    }

    private static void testLimiter() {
        System.out.println(Thread.currentThread() + " waiting " + limiter.acquire());
    }
}
```
#### 设置超时时间

```java
public class RateLimiterTest {
    public static void main(String[] args) {
        RateLimiter limiter = RateLimiter.create(1);
        System.out.println(limiter.acquire(3));
        System.out.println(limiter.tryAcquire(1, 2, TimeUnit.SECONDS));
    }
}
```

上面例子limiter.tryAcquire设置了超时时间为2秒，由于第一次请求一次性获取了3张令牌，所以这里需要等待大约3秒钟，超出了2秒的超时时间，所以limiter.tryAcquire不会等待3秒，而是直接返回false。