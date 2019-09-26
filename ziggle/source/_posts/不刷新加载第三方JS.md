---
title: 不刷新加载第三方JS
date: 2019-09-26 14:46:10
tags:
---

#### 异步加载
 异步加载JS的方法很多，最常见的就是动态创建一个script标签，然后设置其src和async属性，再插入到页面中

 ```html
 <script>
    function loadScript(url) {
        var scrs = document.getElementsByTagName('script');
        var last = scrs[scrs.length - 1];
        var scr = document.createElement('script');
        scr.src = url;
        scr.async = true;
        last.parentNode.insertBefore(scr, last);
    }
    loadScript('test.js');
</script>
 ```