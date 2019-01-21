---
title: how-to-create-spring-boot-starter
date: 2019-01-21 11:31:50
tags:
---


## 创建spring.factories
`resources/META-INF/spring.factories`
```text
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.oucloud.web.starter.ZiggleWebAutoConfigure
```

##  自动配置入口

```java
@Configuration
@ConditionalOnClass(EnableStarterConfig.class)
@EnableConfigurationProperties({ZiggleStatProperties.class})
@Import({JacksonConfiguration.class, SecurityConfiguration.class})
public class ZiggleWebAutoConfigure {
}
```
- `@Import` 导入配置类 
- 有`EnableStartConfig.class` 条件导入


## 自动配置注解

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@EnableWebSecurity
@AutoConfigureBefore(SecurityAutoConfiguration.class)
@EnableGlobalMethodSecurity(prePostEnabled = true)
@AutoConfigurationPackage
@Import({ZiggleConfigurationSelector.class})
public @interface EnableStarterConfig {
}
```
- 使用这个注解后会启用`EnableWebSecurity`
- 最重要的是 `@Import({ZiggleConfigurationSelector.class})` 导入配置类
  
## 配置类selector

```java
public class ZiggleConfigurationSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{
                JacksonConfiguration.class.getName(),
                SecurityConfiguration.class.getName()};
    }
}
```


## 具体配置类

```java
public class SecurityConfiguration {

    private static final String[] AUTH_WHITE_LIST = {
            // -- swagger ui
            "/swagger-resources/**",
            "/v2/api-docs",
            "/swagger-ui.html",
            "/**/*.css",
            "/**/*.js",
            "/**/*.png",
            "/**/*.jpg",
            "/webjars/**",
            "/druid/**"
    };

    @Bean
    @ConditionalOnClass(EnableWebSecurity.class)
    public WebSecurityConfigurerAdapter webSecurityConfigurerAdapter(AuthenticationProvider authenticationProvider,
                                                                     ZiggleStatProperties statProperties,
                                                                     IJwtTokenDecoder decoder
    ) {

        return new WebSecurityConfigurerAdapter() {

            @Bean(BeanIds.AUTHENTICATION_MANAGER)
            @Override
            public AuthenticationManager authenticationManagerBean() throws Exception {
                return super.authenticationManagerBean();
            }

            @Override
            protected void configure(AuthenticationManagerBuilder auth) throws Exception {
                //自定义身份验证组件
                auth.authenticationProvider(authenticationProvider);
                super.configure(auth);
            }

            @Override
            protected void configure(HttpSecurity http) throws Exception {
                http
                        .cors()
                        .and().csrf().disable()
                        .sessionManagement()
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                        .and()
                        .authorizeRequests()
                        .antMatchers(HttpMethod.POST, statProperties.getRoutingPrefixV1() + "/login").permitAll()
                        .antMatchers(HttpMethod.POST, statProperties.getRoutingPrefixV1() + "/user/").permitAll()
                        .antMatchers(AUTH_WHITE_LIST).permitAll()
                        .anyRequest().authenticated()
                        .and()
                        .addFilterBefore(new JwtExceptionHandlerFilter(), ChannelProcessingFilter.class)
                        .addFilterBefore(new JwtAuthenticationFilter(authenticationManager(), decoder), UsernamePasswordAuthenticationFilter.class)
                ;
            }
        };
    }

}
```
