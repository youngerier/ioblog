---
title: spring自动配置
date: 2019-08-06 17:35:34
tags:
---

#### 自动配置是如何实现
1、Spring Boot 的自动配置是如何实现的？
Spring Boot 项目的启动注解是：@SpringBootApplication，其实它就是由下面三个注解组成的：


@Configuration


@ComponentScan


@EnableAutoConfiguration


其中 @EnableAutoConfiguration 是实现自动配置的入口，该注解又通过 @Import 注解导入了AutoConfigurationImportSelector，在该类中加载 META-INF/spring.factories 的配置信息。然后筛选出以 EnableAutoConfiguration 为 key 的数据，加载到 IOC 容器中，实现自动配置功能！