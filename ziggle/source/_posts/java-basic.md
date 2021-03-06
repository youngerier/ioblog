---
title: java-basic
date: 2017-12-15 10:19:56
tags:
---

Class.forName() 返回一个类JVM会加载制定的类,并执行类的静态代码段

A a = (A)Class.forName(“pacage.A”).newInstance();
A a = new A()
通过包名和类名,实例对象

String className = readfromXMLConfig;
class c = Class.forName(className);
factory = (Exampleinterface)c.newInstence();
> 使用newInstance() 要保证:
* 类已经加载
* 类已经连接

使用Class类的静态方法forName 完成这两步
- newInstance(): 弱类型,低效率,只能调用无参构造。
- new: 强类型,相对高效,能调用任何public构造。
- Class.forName(“”)返回的是类。
- Class.forName(“”).newInstance()返回的是object 。
## ReentrantLock
ReentrantLock是一个基于AQS的可重入的互斥锁，
公平锁将确保等待时间最长的线程优先获取锁，将会使整体的吞吐量下降
非公平锁将不能确定哪一个线程将获取锁，可能会导致某些线程饥饿。

```java
public class ReentrantLockTest {
    private final ReentrantLock lock = new ReentrantLock();
    // ...

    public void doSomething() {
        lock.lock();  // block until condition holds
        try {
            // ... method body
        } finally {
            lock.unlock();
        }
    }
}
```

## java 静态代理

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class ProxyDemo {
    public static void main(String[] args) {

        //1.创建委托对象
        AbsSubject real = new RealSub();
        
        //2.创建调用处理器对象
        ProxyHandler handler = new ProxyHandler(real);
        
        //3.动态生成代理对象
        AbsSubject proxySub = (AbsSubject)Proxy.newProxyInstance(real.getClass().getClassLoader(),
                real.getClass().getInterfaces(), handler);
        
        //4.通过代理对象调用方法
        proxySub.doJob();
        proxySub.sum(3,  9);
        int m = proxySub.multiply(3, 7);
        System.out.println("multiply result is:"+m);
    }
}

//被代理类的接口
interface AbsSubject {
    void doJob();
    void sum(int a, int b);
    int multiply(int a, int b);
}

//实际的被代理类
class RealSub implements AbsSubject {

    @Override
    public void doJob() {
        // TODO Auto-generated method stub
        System.out.println("i am doing something");
    }

    @Override
    public void sum(int a, int b) {
        System.out.println(a+" + "+b+" = "+(a+b));
    }

    @Override
    public int multiply(int a, int b) {
        // TODO Auto-generated method stub
        System.out.println(a+" * "+ b);
        return a*b;
    }
    
}

//动态代理的内部实现,调用处理器类，即实现 InvocationHandler 接口
//这个类的目的是指定运行时将生成的代理类需要完成的具体任务（包括Preprocess和Postprocess）
//即代理类调用任何方法都会经过这个调用处理器类
class ProxyHandler implements InvocationHandler {
    private Object realSub;
    
    public ProxyHandler(Object object) {
        realSub = object;
    }
    
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("before");
        Object res = method.invoke(realSub, args);
        System.out.println("after");
        return res;
    }   
}
```
<!-- more -->

### Stream(Java 8)

```java
List<String> lists =Arrays.asList("a","b","c");
Stream<String> streamList  = lists.stream();
lists = streamList.distinct().finter(str->!str.equals("a").sorted(String::CompareTo).collect(ollectors.toList());
lists.forEach(System.out::println);
```

> 创建Stream
- 集合 Stream: stream()
- 数组

```java
        //lambda
        Collections.sort(strList, (s1, s2)->s1.compareTo(s2));
        //方法引用
        Collections.sort(strList, String::compareTo);
        //lambda
        strList.forEach(x->System.out.println(x));
        //方法引用
        strList.forEach(System.out::println);
```
* 方法引用的语法
    - 对象::实例方法=>等价于"提供方法参数的lambda表达式"
    - 类::静态方法=>等价于"提供方法参数的lambda表达式"
        - eg. System.out::println等价于x->System.out.println(x)
    - 类::实例方法=>第一个参数是执行方法的对象
        - eg. String::compareTo等价于(s1, s2)->s1.compareTo(s2)


### aop 
> 使用场景 
Authentication 权限

Caching 缓存

Context passing 内容传递

Error handling 错误处理

Lazy loading　懒加载

Debugging　　调试

logging, tracing, profiling and monitoring　记录跟踪　优化　校准

Performance optimization　性能优化

Persistence　　持久化

Resource pooling　资源池

Synchronization　同步

Transactions 事务

> AOP相关概念
方面（Aspect）：一个关注点的模块化，这个关注点实现可能另外横切多个对象。事务管理是J2EE应用中一个很好的横切关注点例子。方面用spring的 Advisor或拦截器实现。

连接点（Joinpoint）: 程序执行过程中明确的点，如方法的调用或特定的异常被抛出。

通知（Advice）: 在特定的连接点，AOP框架执行的动作。各种类型的通知包括“around”、“before”和“throws”通知。通知类型将在下面讨论。许多AOP框架包括Spring都是以拦截器做通知模型，维护一个“围绕”连接点的拦截器链。Spring中定义了四个advice: BeforeAdvice, AfterAdvice, ThrowAdvice和DynamicIntroductionAdvice

切入点（Pointcut）: 指定一个通知将被引发的一系列连接点的集合。AOP框架必须允许开发者指定切入点：例如，使用正则表达式。 Spring定义了Pointcut接口，用来组合MethodMatcher和ClassFilter，可以通过名字很清楚的理解， MethodMatcher是用来检查目标类的方法是否可以被应用此通知，而ClassFilter是用来检查Pointcut是否应该应用到目标类上

引入（Introduction）: 添加方法或字段到被通知的类。 Spring允许引入新的接口到任何被通知的对象。例如，你可以使用一个引入使任何对象实现 IsModified接口，来简化缓存。Spring中要使用Introduction, 可有通过DelegatingIntroductionInterceptor来实现通知，通过DefaultIntroductionAdvisor来配置Advice和代理类要实现的接口

目标对象（Target Object）: 包含连接点的对象。也被称作被通知或被代理对象。POJO

AOP代理（AOP Proxy）: AOP框架创建的对象，包含通知。 在Spring中，AOP代理可以是JDK动态代理或者CGLIB代理。

织入（Weaving）: 组装方面来创建一个被通知对象。这可以在编译时完成（例如使用AspectJ编译器），也可以在运行时完成。Spring和其他纯Java AOP框架一样，在运行时完成织入。


Spring提供了两种方式来生成代理对象: JDKProxy和Cglib，具体使用哪种方式生成由AopProxyFactory根据AdvisedSupport对象的配置来决定。默认的策略是如果目标类是接口，则使用JDK动态代理技术，否则使用Cglib来生成代理。下面我们来研究一下Spring如何使用JDK来生成代理对象，具体的生成代码放在JdkDynamicAopProxy这个类中

```
修饰符介绍
Java修饰符主要分为两类:

访问修饰符
非访问修饰符
其中访问修饰符主要包括 private、default、protected、public。
非访问修饰符主要包括 static、final、abstract、synchronized。

访问修饰符
访问修饰符可以使用下图这张表来说明访问权限:

修饰符	当前类	同一包内	子类	其它包
public	Y	Y	Y	Y
protected	Y	Y	Y	N
default	Y	Y	N	N
private	Y	N	N	N
简单点查看访问级别的话，级别是由低到高。

 private＜default＜protected＜public
```
---
title: java-basic
date: 2017-12-15 10:19:56
tags:
---

Class.forName() 返回一个类JVM会加载制定的类,并执行类的静态代码段

A a = (A)Class.forName(“pacage.A”).newInstance();
A a = new A()
通过包名和类名,实例对象

String className = readfromXMLConfig;
class c = Class.forName(className);
factory = (Exampleinterface)c.newInstence();
> 使用newInstance() 要保证:
* 类已经加载
* 类已经连接

使用Class类的静态方法forName 完成这两步
- newInstance(): 弱类型,低效率,只能调用无参构造。
- new: 强类型,相对高效,能调用任何public构造。
- Class.forName(“”)返回的是类。
- Class.forName(“”).newInstance()返回的是object 。
### ReentrantLock
ReentrantLock是一个基于AQS的可重入的互斥锁，
公平锁将确保等待时间最长的线程优先获取锁，将会使整体的吞吐量下降
非公平锁将不能确定哪一个线程将获取锁，可能会导致某些线程饥饿。

```java
public class ReentrantLockTest {
    private final ReentrantLock lock = new ReentrantLock();
    // ...

    public void doSomething() {
        lock.lock();  // block until condition holds
        try {
            // ... method body
        } finally {
            lock.unlock();
        }
    }
}
```

### java 静态代理

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class ProxyDemo {
    public static void main(String[] args) {

        //1.创建委托对象
        AbsSubject real = new RealSub();
        
        //2.创建调用处理器对象
        ProxyHandler handler = new ProxyHandler(real);
        
        //3.动态生成代理对象
        AbsSubject proxySub = (AbsSubject)Proxy.newProxyInstance(real.getClass().getClassLoader(),
                real.getClass().getInterfaces(), handler);
        
        //4.通过代理对象调用方法
        proxySub.doJob();
        proxySub.sum(3,  9);
        int m = proxySub.multiply(3, 7);
        System.out.println("multiply result is:"+m);
    }
}

//被代理类的接口
interface AbsSubject {
    void doJob();
    void sum(int a, int b);
    int multiply(int a, int b);
}

//实际的被代理类
class RealSub implements AbsSubject {

    @Override
    public void doJob() {
        // TODO Auto-generated method stub
        System.out.println("i am doing something");
    }

    @Override
    public void sum(int a, int b) {
        System.out.println(a+" + "+b+" = "+(a+b));
    }

    @Override
    public int multiply(int a, int b) {
        // TODO Auto-generated method stub
        System.out.println(a+" * "+ b);
        return a*b;
    }
    
}

//动态代理的内部实现,调用处理器类，即实现 InvocationHandler 接口
//这个类的目的是指定运行时将生成的代理类需要完成的具体任务（包括Preprocess和Postprocess）
//即代理类调用任何方法都会经过这个调用处理器类
class ProxyHandler implements InvocationHandler {
    private Object realSub;
    
    public ProxyHandler(Object object) {
        realSub = object;
    }
    
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("before");
        Object res = method.invoke(realSub, args);
        System.out.println("after");
        return res;
    }   
}
```
### Stream(Java 8)

```java
List<String> lists =Arrays.asList("a","b","c");
Stream<String> streamList  = lists.stream();
lists = streamList.distinct().finter(str->!str.equals("a").sorted(String::CompareTo).collect(ollectors.toList());
lists.forEach(System.out::println);
```

> 创建Stream
- 集合 Stream: stream()
- 数组

```java
        //lambda
        Collections.sort(strList, (s1, s2)->s1.compareTo(s2));
        //方法引用
        Collections.sort(strList, String::compareTo);
        //lambda
        strList.forEach(x->System.out.println(x));
        //方法引用
        strList.forEach(System.out::println);
```
* 方法引用的语法
    - 对象::实例方法=>等价于"提供方法参数的lambda表达式"
    - 类::静态方法=>等价于"提供方法参数的lambda表达式"
        - eg. System.out::println等价于x->System.out.println(x)
    - 类::实例方法=>第一个参数是执行方法的对象
        - eg. String::compareTo等价于(s1, s2)->s1.compareTo(s2)


### aop 
> 使用场景 
Authentication 权限
Caching 缓存
Context passing 内容传递
Error handling 错误处理
Lazy loading　懒加载
Debugging　　调试
logging, tracing, profiling and monitoring　记录跟踪　优化　校准
Performance optimization　性能优化
Persistence　　持久化
Resource pooling　资源池
Synchronization　同步
Transactions 事务

> AOP相关概念
方面（Aspect）：一个关注点的模块化，这个关注点实现可能另外横切多个对象。事务管理是J2EE应用中一个很好的横切关注点例子。方面用spring的 Advisor或拦截器实现。

连接点（Joinpoint）: 程序执行过程中明确的点，如方法的调用或特定的异常被抛出。

通知（Advice）: 在特定的连接点，AOP框架执行的动作。各种类型的通知包括“around”、“before”和“throws”通知。通知类型将在下面讨论。许多AOP框架包括Spring都是以拦截器做通知模型，维护一个“围绕”连接点的拦截器链。Spring中定义了四个advice: BeforeAdvice, AfterAdvice, ThrowAdvice和DynamicIntroductionAdvice

切入点（Pointcut）: 指定一个通知将被引发的一系列连接点的集合。AOP框架必须允许开发者指定切入点：例如，使用正则表达式。 Spring定义了Pointcut接口，用来组合MethodMatcher和ClassFilter，可以通过名字很清楚的理解， MethodMatcher是用来检查目标类的方法是否可以被应用此通知，而ClassFilter是用来检查Pointcut是否应该应用到目标类上

引入（Introduction）: 添加方法或字段到被通知的类。 Spring允许引入新的接口到任何被通知的对象。例如，你可以使用一个引入使任何对象实现 IsModified接口，来简化缓存。Spring中要使用Introduction, 可有通过DelegatingIntroductionInterceptor来实现通知，通过DefaultIntroductionAdvisor来配置Advice和代理类要实现的接口

目标对象（Target Object）: 包含连接点的对象。也被称作被通知或被代理对象。POJO

AOP代理（AOP Proxy）: AOP框架创建的对象，包含通知。 在Spring中，AOP代理可以是JDK动态代理或者CGLIB代理。

织入（Weaving）: 组装方面来创建一个被通知对象。这可以在编译时完成（例如使用AspectJ编译器），也可以在运行时完成。Spring和其他纯Java AOP框架一样，在运行时完成织入。

Spring提供了两种方式来生成代理对象: JDKProxy和Cglib，具体使用哪种方式生成由AopProxyFactory根据AdvisedSupport对象的配置来决定。默认的策略是如果目标类是接口，则使用JDK动态代理技术，否则使用Cglib来生成代理。下面我们来研究一下Spring如何使用JDK来生成代理对象，具体的生成代码放在JdkDynamicAopProxy这个类中

private static void demo2() {
    Thread A = new Thread(new Runnable() {
        @Override
        public void run() {
            printNumber("A");
        }
    });
    Thread B = new Thread(new Runnable() {
        @Override
        public void run() {
            System.out.println("B 开始等待 A");
            try {
                A.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            printNumber("B");
        }
    });
    B.start();
    A.start();
}
得到的结果如下：

B 开始等待 A
A print: 1
A print: 2
A print: 3
 
B print: 1
B print: 2
B print: 3
所以我们能看到 A.join() 方法会让 B 一直等待直到 A 运行完毕。




### 为什么hashmap中数组的长的是16 或2的n次幂


我们假设HaspMap的初始长度为10，重复前面的运算步骤：

{% asset_img hash1.png hash1%}
单独看这个结果，表面上并没有问题。我们再来尝试一个新的HashCode 101110001110101110 1011 ：
{% asset_img hash2.png hash2%}
然后我们再换一个HashCode 101110001110101110 1111 试试 ：
{% asset_img hash3.png hash3%}

这样我们可以看到，虽然HashCode的倒数第二第三位从0变成了1，但是运算的结果都是1001。也就是说，当HashMap长度为10的时候，有些index结果的出现几率会更大，而有些index结果永远不会出现（比如0111）！

所以这样显然不符合Hash算法均匀分布的原则。

而长度是16或者其他2的次幂，Length - 1的值的所有二进制位全为1（如15的二进制是1111，31的二进制为11111），这种情况下，index的结果就等同于HashCode后几位的值。只要输入的HashCode本身分布均匀，Hash算法的结果就是均匀的。这也是HashMap设计的玄妙之处。


### HashMap的死锁
我们知道HashMap是非线程安全的，那么原因是什么呢？

由于HashMap的容量是有限的，如果HashMap中的数组的容量很小，假如只有2个，那么如果要放进10个keys的话，碰撞就会非常频繁，此时一个O(1)的查找算法，就变成了链表遍历，性能变成了O(n)，这是Hash表的缺陷。

为了解决这个问题,HashMap设计了一个阈值，其值为容量的0.75，当HashMap所用容量超过了阈值后，就会自动扩充其容量。

在多线程的情况下，当重新调整HashMap大小的时候，就会存在条件竞争，因为如果两个线程都发现HashMap需要重新调整大小了，它们会同时试着调整大小。在调整大小的过程中，存储在链表中的元素的次序会反过来，因为移动到新的bucket位置的时候，HashMap并不会将元素放在链表的尾部，而是放在头部，这是为了避免尾部遍历。如果条件竞争发生了，那么就会产生死循环了。



### java 编译参数

```sh
 javac -encoding utf-8 ./a.java
```

### Arthas 

 原文连接 `https://alibaba.github.io/arthas/arthas-tutorials?language=cn&id=arthas-advanced `

```
watch com.example.demo.arthas.user.UserController * '{params, throwExp}' -x 2
```
- 第一个参数是类名，支持通配
- 第二个参数是函数名，支持通配
- 第三个参数是 返回值 ognl 
- 第四个参数是 命令支持在第4个参数里写条件表达式 `watch com.example.demo.arthas.user.UserController * returnObj 'params[0] > 100'`

``` 
`loader`
`clazz`
`method`
`target`
`params`
`returnObj`
`throwExp`
`isBefore`
`isThrow`
`isReturn`
```

####   热更新代码
下面介绍通过jad/mc/redefine 命令实现动态更新代码的功能。

目前，访问 `http://localhost/user/0` ，会返回`500`异常：

```curl
curl http://localhost/user/0
```
```json
{"timestamp":1550223186170,"status":500,"error":"Internal Server Error","exception":"java.lang.IllegalArgumentException","message":"id < 1","path":"/user/0"}
```
下面通过热更新代码，修改这个逻辑。

jad反编译UserController
```
jad --source-only com.example.demo.arthas.user.UserController > /tmp/UserController.java
```
jad反编译的结果保存在 /tmp/UserController.java文件里了。

再打开一个Terminal 3，然后用vim来编辑/tmp/UserController.java：
```
vim /tmp/UserController.java
```
比如当 user id 小于1时，也正常返回，不抛出异常：
```java
    @GetMapping(value={"/user/{id}"})
    public User findUserById(@PathVariable Integer id) {
        logger.info("id: {}", (Object)id);
        if (id != null && id < 1) {
            return new User(id, "name" + id);
            // throw new IllegalArgumentException("id < 1");
        }
        return new User(id.intValue(), "name" + id);
    }
```

sc查找加载UserController的ClassLoader

```
sc -d *UserController | grep classLoaderHash
```
```
$ sc -d *UserController | grep classLoaderHash
```
 classLoaderHash   1be6f5c3
可以发现是 spring boot LaunchedURLClassLoader@1be6f5c3 加载的。

- mc

保存好/tmp/UserController.java之后，使用mc(Memory Compiler)命令来编译，并且通过-c参数指定ClassLoader：

```sh
mc -c 1be6f5c3 /tmp/UserController.java -d /tmp
```
$ mc -c 1be6f5c3 /tmp/UserController.java -d /tmp

Memory compiler output:
/tmp/com/example/demo/arthas/user/UserController.class
Affect(row-cnt:1) cost in 346 ms

- redefine


再使用redefine命令重新加载新编译好的UserController.class：

redefine /tmp/com/example/demo/arthas/user/UserController.class

$ redefine /tmp/com/example/demo/arthas/user/UserController.class
redefine success, size: 1

热修改代码结果
redefine成功之后，再次访问 `curl http://localhost/user/0` ，结果是：
``` json
{
  "id": 0,
  "name": "name0"
}
```


```
因为static类型的属性会在类被加载之后被初始化，我们在深度分析Java的ClassLoader机制（源码级别）和Java类的加载、链接和初始化两个文章中分别介绍过，当一个Java类第一次被真正使用到的时候静态资源被初始化、Java类的加载和初始化过程都是线程安全的。所以，创建一个enum类型是线程安全的。
```