---
title: android-Art虚拟机启动流程
date: 2020-06-19 10:09:02
tags: 
    - android
    - xposed
---


主要大致流程
①Linux `init`进程解析配置脚本->②`app_process`（`zygote`进程对应的程序）->③ZygoteInit

① 解析配置脚本

{% asset_img init_android.png init_android%}



`service zygote`:它告诉`init`进程,现在我们要配置一个名为`zygote`的服务.

`/system/bin/app_process`: 声明zygote进程对应的文件路径.init创建服务的处理逻辑很简单,就是启动(fork)一个子进程来运行指定的程序.对zygote服务而言这个程序就是`/system/bin/app_process`.

`-Xzygote/system/bin--zygote--start-system-server`:传递给`app_process`的启动参数.

<!-- more -->

②`app_process` 创建
`frameworks\base\cmds\app_process.cpp->main`函数

{% asset_img app_process.png app_process%}

{% asset_img runtime_start.png runtime_start%}

`frameworks\base\core\jni\AndroidRuntime.cpp->start`函数

核心函数为: `init`,`startVm`
三个函数主要功能:


1. `JNI_GetDefaultJavaVMInitArgs` -- 获取虚拟机的默认初始化参数
2. `JNI_CreateJavaVM` -- 在进程中创建虚拟机实例
3. `JNI_GetCreatedJavaVMs` -- 获取进程中创建的虚拟机实例

`ART`像`Dalvik`一样,都实现`Java`虚拟机接口,这三个接口也是`ART`虚拟机核心接口.

`startVm`函数很复杂牵扯逻辑也很多,不逐一描述了.

③`ZygoteInit`

继续查看 `frameworks\base\core\jni\AndroidRuntime.cpp->start`函数


参数`className`的值等于"`com.android.internal.os.ZygoteInit`",本地变量`env`是从调用另外一个成员函数`startVm`创建的`ART`虚拟机获得的`JNI`接口.函数的目标就是要找到一个名称为`com.android.internal.os.ZygoteInit`的类,以及它的静态成员函数`main`,然后就以这个函数为入口,开始运行ART虚拟机.为此,函数执行了以下步骤:



① 调用JNI接口`FindClass`加载`com.android.internal.os.ZygoteInit`类.

② 调用JNI接口 `GetStaticMethodID` 找到`com.android.internal.os.ZygoteInit` 类的静态成员函数`main`.

③ 调用JNI接口`CallStaticVoidMethod`开始执行`com.android.internal.os.ZygoteInit`类的静态成员函数`main`.

下面看看 `Xposed` 是如何做拦截的


打开 `Xposed` 项目

{% asset_img androidmk.png androidmk%}

大于21编译走的是 `app_main2.cpp` 看看 具体改动了哪些
经过查阅,被修改的 `main` 函数,一共有两个地方.



其一,红框的地方 是判断是否是 `Xposed`版本的虚拟机
{% asset_img 虚拟机判断.png 虚拟机判断%}


在解析开启启动 `init` 脚本的时候 添加了 `--xposedversion` 版本号的命令


这块启动的已经是自定义的虚拟机了
{% asset_img 启动自定义虚拟机.png 启动自定义虚拟机%}

handleOptions函数

{% asset_img handleOptions函数.png handleOptions函数%}


第二个地方在 `start` 函数这块,先看看 原函数.

也是在这个地方 进行的初始化 判断是否初始化成功 .


`initialize` 函数返回的是否加载成功的 一个全局变量 `isXposedLoaded`

{% asset_img  initialize函数.png  initialize函数%}
{% asset_img  xposed自定义的数据结构体.png  xposed自定义的数据结构体%}

初始化完毕以后开始调用真正的 `start` 函数
下面看 `runtimeStart` 函数


这块很有趣 在 `libart.so` 里面根据符号表信息尝试拿到 `Android::start` 函数
上面这些只要有一步失败了,在刷入的时候就可能变砖.
如果获取到了,则可以直接通过函数指针调用,主要是针对一些特殊的安卓版本号.


如果都没有找到 可以看到 Log会打印 .

"app_process: could not locate AndroidRuntime::start() method."
{% asset_img  runtimeStart函数.png  runtimeStart函数%}


（这个地方有个小技巧,可以对so文件里面的全部函数名字进行逐一字符判断,
比如可以对这个字符串 判断 是否含有 `RuntimeStart` 这几个字符,来绕过因为编译优化字符串不同问题）



这样一来完美替换了原虚拟机.
在新的虚拟机里面会将 `XposedBridge.jar` 进行注入,这么一来,所有被 `Xposed fork` 的进程都具备了` XposedBridge.jar` 的代码 .



问题3:
当我们 `findAndHookMethod` 一个函数以后 `Xposed` 是怎么处理的？



打开 `XposedBridge` 项目

找到 `findAndHookMethod`



`link:https://bbs.pediy.com/thread-257844.htm`