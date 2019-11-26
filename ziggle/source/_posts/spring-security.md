---
title: spring-security
date: 2019-11-26 17:32:23
tags:
---

org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter

```java
     * spring security filter chain
     *
     * (1)//    UsernamePasswordAuthenticationFilter
     *
     * @link {org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter}
     * 登陆请求 检查参数
     * (2) //    BasicAuthenticationFilter
     * @link {org.springframework.security.web.authentication.www.BasicAuthenticationFilter}
     * 检查请求头Basic
     *  ... ....
     * (3) org.springframework.security.web.access.ExceptionTranslationFilter
     *  异常转换 (必定会有 位置在FilterSecurityInterceptor)
     *
     * (4) @link {org.springframework.security.web.access.intercept.FilterSecurityInterceptor}
     *  // 最终决定是否通过
     */

     @Override
    protected void configure(HttpSecurity http) throws Exception {
        // http.formLogin()
        http.httpBasic()
                .and()
                .authorizeRequests()
                .anyRequest()
                .authenticated();
    }

```