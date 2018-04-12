---
title: paraller
date: 2017-11-27 22:29:55
tags:
---
###  Paraller 并发请求
```C#
  var url = "http://112.124.121.109:11250/order/1230a611-e189-4296-a50d-b48910bc1850";
    var client = new HttpClient();
    Enumerable.Range(1, 10).AsParallel().ToList().ForEach(async (item) =>
    {
        var watch = Stopwatch.StartNew();
        var res = await client.GetStringAsync(url);
        watch.Stop();
        Console.WriteLine($"{watch.ElapsedMilliseconds}  : {item}");
    });

```