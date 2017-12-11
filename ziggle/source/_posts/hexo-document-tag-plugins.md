---
title: hexo document tag plugins
date: 2017-11-28 22:00:13
tags: hexo
---


## 使用引用
```
{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}
```
### 样例
{% blockquote %}
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque hendrerit lacus ut purus iaculis feugiat. Sed nec tempor elit, quis aliquam neque. Curabitur sed diam eget dolor fermentum semper at eu lorem.
{% endblockquote %}

## 加入Image
```
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}

{% asset_img example.jpg This is an example image %} # 通过这种方式，图片将会同时出现在文章和主页以及归档页中。
```
## 加入 jsFiddle
```
{% jsfiddle shorttag [tabs] [skin] [width] [height] %}
```


### 显示文章预览

``` nil
Next 使用 <!-- more -->
```