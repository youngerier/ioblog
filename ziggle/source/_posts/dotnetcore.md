---
title: dotnetcore
date: 2018-01-02 13:05:22
tags:
    - dotnetcore
---


## dotent  Deployment


### self-contained deployment (SCD) 
* 生成是带有运行时
 dotnet publish -c Release --self-contained -r linux-x64
* 宿主带有运行时
 dotnet publish -c Release 


 ### 判断属性值是否为null
 ```csharp
 static void CheckNull<T>(Expression<Func<T>> expression)
 {
     var name = ((MemberExpression)expression.Body).Member.Name;
     if(expression.Compile()()==null)
     {
         System.Console.WriteLine($"{name} is null");
     }
 }
 ```

 >Exception
Q: Unhandled Exception: System.Net.HttpListenerException: Access is denied
A: netsh http add urlacl url=http://+:11221/ user=everyone
