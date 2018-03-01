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
