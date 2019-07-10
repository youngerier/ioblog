---
title: javascript
date: 2018-02-26 19:00:35
tags:
    - javascript
---

> js 中switch 语句 区分类型
```js
function chooseUseRegion() {
    $('#EffectiveType').change(function() {
        $('.showdiv').hide();
        switch ($(this).val()) {
        case '1':
            $('#use_time_2').show();
            return;
        case '2':
            $('#use_time_1').show();
            return;
        case '0':
            return;
        default:
            return;
        };
    });
}
```
#### 前端路由实现之 #hash

前端路由实现方式 1 使用 h5 提供historyapi
                2 使用hash 路由


### 跨域配置
> 简单请求
{% asset_img 简单请求.png 简单请求 %}

> 带cookie跨域 origin 不能为 *

{% asset_img 带cookie请求服务端.png 带cookie请求服务端 %}


> ajax带cookie 请求
{% asset_img 发送ajax会带上cookie.png ajax配置 %}


>隐藏跨域
页面中api地址 /a?b=1&c=2
{% asset_img 使用nginx支持跨域.png 隐藏跨域nginx配置 %}


js map/reduce/filter/sort
```js
// map
var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
var results = arr.map(pow); // [1, 4, 9, 16, 25, 36, 49, 64, 81]
console.log(results);
// reduce
var arr = [1, 3, 5, 7, 9];
arr.reduce(function (x, y) {
    return x + y;
}); // 25

// filter
var arr = [1, 2, 4, 5, 6, 9, 10, 15];
var r = arr.filter(function (x) {
    return x % 2 !== 0;
});
r; // [1, 5, 9, 15]

//sort

var arr = [10, 20, 1, 2];
arr.sort(function (x, y) {
    if (x < y) {
        return -1;
    }
    if (x > y) {
        return 1;
    }
    return 0;
});
console.log(arr); // [1, 2, 10, 20]

```


html页面注入js
```js
(function(d,s,id){
	  var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)){ return; }
    js = d.createElement(s); js.id = id;
    js.onload = function(){
        console.log(11111)
    };
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
})(document,'script','facebook-jssdk') 
```

<!-- more -->
