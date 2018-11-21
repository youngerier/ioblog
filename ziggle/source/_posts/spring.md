---
title: spring
date: 2018-11-21 10:38:01
tags:
---


# spring 实现拦截的五种姿势


## 使用 Filter 接口

Filter 接口由 J2EE 定义，在Servlet执行之前由容器进行调用。
而SpringBoot中声明 Filter 又有两种方式：

1. 注册 FilterRegistrationBean
声明一个FilterRegistrationBean 实例，对Filter 做一系列定义，如下：
```java
    @Bean
    public FilterRegistrationBean customerFilter() {
        FilterRegistrationBean registration = new FilterRegistrationBean();

        // 设置过滤器
        registration.setFilter(new CustomerFilter());

        // 拦截路由规则
        registration.addUrlPatterns("/intercept/*");

        // 设置初始化参数
        registration.addInitParameter("name", "customFilter");

        registration.setName("CustomerFilter");
        registration.setOrder(1);
        return registration;
    }
```

其中 CustomerFilter 实现了Filter接口，如下：

```java

public class CustomerFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(CustomerFilter.class);
    private String name;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        name = filterConfig.getInitParameter("name");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        logger.info("Filter {} handle before", name);
        chain.doFilter(request, response);
        logger.info("Filter {} handle after", name);
    }
}
```

2. @WebFilter 注解
为Filter的实现类添加 @WebFilter注解，由SpringBoot 框架扫描后注入

@WebFilter的启用需要配合@ServletComponentScan才能生效

```java
@Component
@ServletComponentScan
@WebFilter(urlPatterns = "/intercept/*", filterName = "annotateFilter")
public class AnnotateFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(AnnotateFilter.class);
    private final String name = "annotateFilter";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        logger.info("Filter {} handle before", name);
        chain.doFilter(request, response);
        logger.info("Filter {} handle after", name);
    }
}
```

使用注解是最简单的，但其缺点是仍然无法支持 order属性(用于控制Filter的排序)。
而通常的@Order注解只能用于定义Bean的加载顺序，却真正无法控制Filter排序。
这是一个已知问题，[参考这里](https://github.com/spring-projects/spring-boot/issues/8276?spm=a2c4e.11153940.blogcont626131.9.ab192f15q5eCfw)


## HanlderInterceptor

HandlerInterceptor 用于拦截 Controller 方法的执行，其声明了几个方法：

方法	说明
preHandle	Controller方法执行前调用
preHandle	Controller方法后，视图渲染前调用
afterCompletion	整个方法执行后(包括异常抛出捕获)
基于 HandlerInterceptor接口 实现的样例：

``` java
public class CustomHandlerInterceptor implements HandlerInterceptor {

    private static final Logger logger = LoggerFactory.getLogger(CustomHandlerInterceptor.class);

    /*
     * Controller方法调用前，返回true表示继续处理
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        HandlerMethod method = (HandlerMethod) handler;
        logger.info("CustomerHandlerInterceptor preHandle, {}", method.getMethod().getName());

        return true;
    }

    /*
     * Controller方法调用后，视图渲染前
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {

        HandlerMethod method = (HandlerMethod) handler;
        logger.info("CustomerHandlerInterceptor postHandle, {}", method.getMethod().getName());

        response.getOutputStream().write("append content".getBytes());
    }

    /*
     * 整个请求处理完，视图已渲染。如果存在异常则Exception不为空
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {

        HandlerMethod method = (HandlerMethod) handler;
        logger.info("CustomerHandlerInterceptor afterCompletion, {}", method.getMethod().getName());
    }

}
```
除了上面的代码实现，还不要忘了将 Interceptor 实现进行注册：
```java
@Configuration
public class InterceptConfig extends WebMvcConfigurerAdapter {

    // 注册拦截器
    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new CustomHandlerInterceptor()).addPathPatterns("/intercept/**");
        super.addInterceptors(registry);
    }
```

HandlerInterceptor 来自SpringMVC框架，基本可代替 Filter 接口使用；
除了可以方便的进行异常处理之外，通过接口参数能获得Controller方法实例，还可以实现更灵活的定制。

## @ExceptionHandler 注解

@ExceptionHandler 的用途是捕获方法执行时抛出的异常，
通常可用于捕获全局异常，并输出自定义的结果。

如下面的实例：
```java
@ControllerAdvice(assignableTypes = InterceptController.class)
public class CustomInterceptAdvice {

    private static final Logger logger = LoggerFactory.getLogger(CustomInterceptAdvice.class);

    /**
     * 拦截异常
     * 
     * @param e
     * @param m
     * @return
     */
    @ExceptionHandler(value = { Exception.class })
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    public String handle(Exception e, HandlerMethod m) {

        logger.info("CustomInterceptAdvice handle exception {}, method: {}", e.getMessage(), m.getMethod().getName());

        return e.getMessage();
    }
}
```

需要注意的是，@ExceptionHandler 需要与 @ControllerAdvice配合使用
其中 @ControllerAdvice的 assignableTypes 属性指定了所拦截类的名称。
除此之外，该注解还支持指定包扫描范围、注解范围等等。


## RequestBodyAdvice/ResponseBodyAdvice

RequestBodyAdvice、ResponseBodyAdvice 相对于读者可能比较陌生，
而这俩接口也是 Spring 4.x 才开始出现的。

RequestBodyAdvice 的用法
我们都知道，SpringBoot 中可以利用@RequestBody这样的注解完成请求内容体与对象的转换。
而RequestBodyAdvice 则可用于在请求内容对象转换的前后时刻进行拦截处理，其定义了几个方法：

方法	说明
supports	判断是否支持
handleEmptyBody	当请求体为空时调用
beforeBodyRead	在请求体未读取(转换)时调用
afterBodyRead	在请求体完成读取后调用
实现代码如下：
```java
@ControllerAdvice(assignableTypes = InterceptController.class)
public class CustomRequestAdvice extends RequestBodyAdviceAdapter {

    private static final Logger logger = LoggerFactory.getLogger(CustomRequestAdvice.class);

    @Override
    public boolean supports(MethodParameter methodParameter, Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType) {
        // 返回true，表示启动拦截
        return MsgBody.class.getTypeName().equals(targetType.getTypeName());
    }

    @Override
    public Object handleEmptyBody(Object body, HttpInputMessage inputMessage, MethodParameter parameter,
            Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        logger.info("CustomRequestAdvice handleEmptyBody");

        // 对于空请求体，返回对象
        return body;
    }

    @Override
    public HttpInputMessage beforeBodyRead(HttpInputMessage inputMessage, MethodParameter parameter, Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType) throws IOException {
        logger.info("CustomRequestAdvice beforeBodyRead");

        // 可定制消息序列化
        return new BodyInputMessage(inputMessage);
    }

    @Override
    public Object afterBodyRead(Object body, HttpInputMessage inputMessage, MethodParameter parameter, Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType) {
        logger.info("CustomRequestAdvice afterBodyRead");

        // 可针对读取后的对象做转换，此处不做处理
        return body;
    }
```

上述代码实现中，针对前面提到的 MsgBody对象类型进行了拦截处理。
在beforeBodyRead 中，返回一个BodyInputMessage对象，而这个对象便负责源数据流解析转换

```java
   public static class BodyInputMessage implements HttpInputMessage {
        private HttpHeaders headers;
        private InputStream body;

        public BodyInputMessage(HttpInputMessage inputMessage) throws IOException {
            this.headers = inputMessage.getHeaders();

            // 读取原字符串
            String content = IOUtils.toString(inputMessage.getBody(), "UTF-8");
            MsgBody msg = new MsgBody();
            msg.setContent(content);

            this.body = new ByteArrayInputStream(JsonUtil.toJson(msg).getBytes());
        }

        @Override
        public InputStream getBody() throws IOException {
            return body;
        }

        @Override
        public HttpHeaders getHeaders() {
            return headers;
        }
    }
```

代码说明
完成数据流的转换，包括以下步骤：

获取请求内容字符串；
构建 MsgBody 对象，将内容字符串作为其 content 字段；
将 MsgBody 对象 Json 序列化，再次转成字节流供后续环节使用。
ResponseBodyAdvice 用法
ResponseBodyAdvice 的用途在于对返回内容做拦截处理，如下面的示例：
```java
 @ControllerAdvice(assignableTypes = InterceptController.class)
    public static class CustomResponseAdvice implements ResponseBodyAdvice<String> {

        private static final Logger logger = LoggerFactory.getLogger(CustomRequestAdvice.class);

        @Override
        public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
            // 返回true，表示启动拦截
            return true;
        }

        @Override
        public String beforeBodyWrite(String body, MethodParameter returnType, MediaType selectedContentType,
                Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request,
                ServerHttpResponse response) {

            logger.info("CustomResponseAdvice beforeBodyWrite");

            // 添加前缀
            String raw = String.valueOf(body);
            return "PREFIX:" + raw;
        }

    }
```

一般在需要对输入输出流进行特殊处理(比如加解密)的场景下使用。

## @Aspect 注解

这是目前最灵活的做法，直接利用注解可实现任意对象、方法的拦截。
在某个Bean的类上面 @Aspect 注解便可以将一个Bean 声明为具有AOP能力的对象。
```java
@Aspect
@Component
public class InterceptControllerAspect {

    private static final Logger logger = LoggerFactory.getLogger(InterceptControllerAspect.class);

    @Pointcut("target(org.zales.dmo.boot.controllers.InterceptController)")
    public void interceptController() {

    }

    @Around("interceptController()")
    public Object handle(ProceedingJoinPoint joinPoint) throws Throwable {

        logger.info("aspect before.");

        try {
            return joinPoint.proceed();
        } finally {
            logger.info("aspect after.");
        }
    }
}
```
简单说明

@Pointcut 用于定义切面点，而使用target关键字可以定位到具体的类。
@Around 定义了一个切面处理方法，通过注入ProceedingJoinPoint对象达到控制的目的。

一些常用的切面注解：

注解	说明
@Before	方法执行之前
@After	方法执行之后
@Around	方法执行前后
@AfterThrowing	抛出异常后
@AfterReturing	正常返回后
深入一点
aop的能力来自于spring-boot-starter-aop，进一步依赖于aspectjweaver组件。
有兴趣可以进一步了解。

推荐指数
5颗星，aspectj 与 SpringBoot 可以无缝集成，这是一个经典的AOP框架，
可以实现任何你想要的功能，笔者之前曾在多个项目中使用，效果是十分不错的。
注解的支持及自动包扫描大大简化了开发，然而，你仍然需要先对 Pointcut 的定义有充分的了解。

```
 - Filter customFilter handle before
 - Filter annotateFilter handle before
 - CustomerHandlerInterceptor preHandle, body
 - CustomRequestAdvice beforeBodyRead
 - CustomRequestAdvice afterBodyRead
 - aspect before.
 - aspect after.
 - CustomResponseAdvice beforeBodyWrite
 - CustomerHandlerInterceptor postHandle, body
 - CustomerHandlerInterceptor afterCompletion, body
 - Filter annotateFilter handle after
 - Filter customFilter handle after
```

{% asset_img interceptor-order.png interceptor-order.png %} 
