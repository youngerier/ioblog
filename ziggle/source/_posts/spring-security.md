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
要想实现短信验证码登录流程，我们可以借鉴已有的用户名密码登录流程，分析有哪些组件是需要我们自己来实现的：

首先我们需要一个`SmsAuthenticationFilter`拦截短信登录请求进行认证，
期间它会将登录信息封装成一个`Authentication`请求`AuthenticationManager`  进行认证`AuthenticationManager`会遍历所有的`AuthenticationProvider`
找到其中支持认证该`Authentication`  并调用`authenticate`进行实际的认证，

因此我们需要实现自己的`Authentication`(SmsAuthenticationToken)和认证该`Authentication`的`AuthenticationProvider`（SmsAuthenticationProvider），并将`SmsAuthenticationProvider`添加到SpringSecurty的`AuthenticationProvider`集合中，以使`AuthenticationManager` 遍历该集合时能找到我们自定义的`SmsAuthenticationProvider``SmsAuthenticationProvider`在进行认证时，需要调用`UserDetailsService`根据手机号查询存储的用户信息`loadUserByUsername`，

因此我们还需要自定义的`SmsUserDetailsService`
下面我们来一一实现下(其实就是依葫芦画瓢，把对应用户名密码登录流程对应组件的代码COPY过来改一改)


`UsernamePasswordAuthenticationFilter` 从请求中拿到 username password 
生成`UsernamePasswordAuthenticationToken` (未认证) AuthenticationManager 用token 
从众多 DaoAuthenticationProvider 
 选择合适的 `org.springframework.security.authentication.AuthenticationProvider`
 (根据 `org.springframework.security.authentication.AuthenticationProvider#supports` )
