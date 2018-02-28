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

