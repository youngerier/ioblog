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

<!-- more -->

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