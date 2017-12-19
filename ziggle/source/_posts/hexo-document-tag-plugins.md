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

### 超链接
- 文字 
```md
 [链接文章](链接地址 "链接标题")
```
- 图片
```md
![图片说明](图片链接 "图片标题")
```
- 视频
```html
<script src="/js/youtube-autoresizer.js"></script>
<iframe width="640" height="360" src="https://www.youtube.com/embed/HfElOZSEqn4" frameborder="0" allowfullscreen></iframe>
```

- 引用
使用 > 表示文字引用
> 野火烧不尽，春风吹又生

- 绘制表格

>绘制表格格式如下，| 控制分列，- 控制分行，: 控制对齐方式。
```
| Item     | Value     | Qty   |
| :------- | --------: | :---: |
| Computer | 1600 USD  | 5     |
| Phone    | 12 USD    | 12    |
| Pipe     | 1 USD     | 234   |
```
| Item     | Value     | Qty   |
| :------- | --------: | :---: |
| Computer | 1600 USD  | 5     |
| Phone    | 12 USD    | 12    |
| Pipe     | 1 USD     | 234   |