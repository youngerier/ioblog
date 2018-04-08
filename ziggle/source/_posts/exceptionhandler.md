---
title: exceptionhandler
date: 2018-04-04 13:34:51
tags:
    - Exception handling (parallel library)
---

> 在task执行完处理异常

**处理异常1**
```C#

var task1 = Task.Run(() =>
{
    Console.WriteLine(1223);
    // throw new CustomException("task1 faulted.");
}).ContinueWith(t => {
    Console.WriteLine("{0}: {1}",
        t.Exception.InnerException.GetType().Name,
        t.Exception.InnerException.Message);
}, TaskContinuationOptions.OnlyOnFaulted);
Thread.Sleep(500);
// 当发生异常时执行ContinueWith 
```


> 在task执行结束 主线程内处理异常

 **处理异常2**
```C#
    var tt = Task.Factory.StartNew(() => throw new ArgumentException());
    while (!tt.IsCompleted){} // tt.Wait()
    var excoCollection = tt.Exception?.InnerExceptions; 
```

 **处理异常3**
 ```C#
    var task1 = Task.Run(() => { throw new CustomException("This exception is expected!"); });
    while (!task1.IsCompleted) { }
    if (task1.Status == TaskStatus.Faulted)
    {
        foreach (var e in task1.Exception.InnerExceptions)
        {
            // 处理自定义异常
            if (e is CustomException)
            {
                Console.WriteLine(e.Message);
            }
            // 抛去其他异常
            else{throw e;}
        }
    }
 ```


> 如果不想等到task结束