---
title: RedisTemplate
date: 2017-12-15 10:19:56
tags:
---

```java
package com.ziggle.fan.service;

import com.google.common.util.concurrent.RateLimiter;
import io.lettuce.core.RedisCommandTimeoutException;
import io.lettuce.core.RedisConnectionException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.QueryTimeoutException;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * redis 消息订阅
 *
 * @author: wp
 * @date: 2019-03-13 14:31
 */

@Slf4j
@Service
public class RedisMessageSubscriber implements MessageListener {

    private final StringRedisTemplate stringRedisTemplate;
    private final RateLimiter rateLimiter;

    public RedisMessageSubscriber(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
        this.rateLimiter = RateLimiter.create(1);
    }

    @Override
    public void onMessage(Message message, byte[] pattern) {
        log.info("Received >> " + message + ", " + Thread.currentThread().getName());
    }

    private ExecutorService executorService = Executors.newSingleThreadExecutor(r -> {
        Thread thread = new Thread(r);
        thread.setName("insert-contact-th");
        thread.setDaemon(true);
        return thread;
    });
    private AtomicInteger flag = new AtomicInteger(0);

    @PreDestroy
    private void destroy() {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                flag.getAndAdd(1);
            }
        });
        if (!executorService.isShutdown()) {
            executorService.shutdown();
        }
    }

//    @PostConstruct
    public void init() {
        RateLimiter errorRate = RateLimiter.create(1);
        executorService
                .submit(() -> {
                    for (; ; ) {
                        if (flag.get() != 0) {
                            break;
                        }
                        try {
                            // todo bug
                            String key = stringRedisTemplate.opsForList().leftPop("key", 3, TimeUnit.SECONDS);

                            if (key != null) {
                                log.warn(key);
                                rateLimiter.acquire();
                            }
                            log.info("nothing.... ");
                        } catch (Exception e) {
                            errorRate.acquire();
                            if (!(e instanceof RedisCommandTimeoutException || e instanceof QueryTimeoutException)) {
                                log.error(e.getMessage(), e);
                            } else {
                                //ignore
                            }
                        }
                    }
                });
    }
}
```



> How to solve this problem 
`https://jira.spring.io/browse/DATAREDIS-961?focusedCommentId=182689&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-182689`
`https://stackoverflow.com/questions/55476087/stringredistemplate-opsforlist-leftpopkey-3-timeunit-seconds-can-not-clo`