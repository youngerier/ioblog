---
title: how-to-enable-spring-security
date: 2019-01-21 15:21:31
tags:
---

## 启用spring security
- 需要一个`AuthenticationProvider`
```java
@Service
public class CustomerAuthenticationManager implements AuthenticationProvider {

    private final SysUserDetailService sysUserDetailService;

    public CustomerAuthenticationManager(SysUserDetailService sysUserDetailService) {
        this.sysUserDetailService = sysUserDetailService;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        // 获取认证的用户名 & 密码
        String name = authentication.getName();
        String password = authentication.getCredentials().toString();
        // 认证逻辑
        SysUserDetail userDetails = (SysUserDetail) sysUserDetailService.loadUserByUsername(name);
        String pwd = DigestUtils.md5DigestAsHex(password.getBytes());
        if (userDetails != null) {
            // 密码MD5 加密 or BCryptPasswordEncoder <--- use this one
//            if (encoder.matches(password, userDetails.getPassword())) {
            if (pwd.equalsIgnoreCase(userDetails.getPassword())) {
                // 这里设置权限和角色
                Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();
                // 生成令牌 这里令牌里面存入了:name,password,authorities, 当然你也可以放其他内容
                Authentication auth = new UsernamePasswordAuthenticationToken(name, password, authorities);
                return auth;
            } else {
                throw new BadCredentialsException("密码错误");
            }
        } else {
            throw new UsernameNotFoundException("用户不存在");
        }
    }

    @Override
    public boolean supports(Class<?> auth) {
        return auth.equals(UsernamePasswordAuthenticationToken.class);
    }
}
```

## 需要获取用户信息的`service`

- 示例方法从数据库中获取用户信息

```java
@Service
public class SysUserDetailService implements UserDetailsService {

    private SysUserMapper sysUserMapper;
    private SysUserRoleMapper sysUserRoleMapper;

    public SysUserDetailService(SysUserMapper sysUserMapper,
                                SysUserRoleMapper sysUserRoleMapper) {
        this.sysUserMapper = sysUserMapper;
        this.sysUserRoleMapper = sysUserRoleMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
        SysUserDetail sysUserDetail = sysUserMapper.getSysUserDetail(s);
        if (sysUserDetail == null) {
            throw new AuthenticationCredentialsNotFoundException("账号不存在");
        }
        List<Role> userRole = sysUserRoleMapper.getUserRole(sysUserDetail.getId());
        List<SimpleGrantedAuthority> authorities = getAuthorities(userRole);
        sysUserDetail.setAuthorities(authorities);

        return sysUserDetail;
    }


    private List<SimpleGrantedAuthority> getAuthorities(List<Role> roles) {
        return roles
                .stream()
                .map(role -> new SimpleGrantedAuthority(role.getRole()))
                .collect(Collectors.toList());
    }
}
```

## 一些帮助类

- `SysUserDetail` 这个类继承自 `org.springframework.security.core.userdetails.UserDetails`

```java
public class SysUserDetail implements UserDetails {
    private static final long serialVersionUID = -2184425668041155384L;
    private Long id;
    private String username;
    @JsonIgnore
    private String password;
    private boolean disabled;
    private String token;
    private Collection<? extends GrantedAuthority> authorities;

    public SysUserDetail() {
    }

    public SysUserDetail(Long id, String username, String password, boolean disabled, Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.disabled = disabled;
        this.authorities = authorities;
    }

 ...... ignore getter setter hashcode.

```

- 基于`jwt`的帮助类

```java
public interface IJwtTokenDecoder {
    SysUserDetail getCurrentUserFromToken(String var1);
}

/**
 * 生成token
 */
String generateToken(SysUserDetail sysUserDetail);

/**
 * 解析token
 */
SysUserDetail getCurrentUserFromToken(String token)
```


## 添加过滤器对请求进行拦截

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
            "/druid/**",
      
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


## 添加登陆授权接口

```java
 // ignore
```