---
title: css
date: 2019-07-05 14:39:35
tags:
---


### margin/padding

`padding`和`margin`属性详解
先看两个单词的释义：
`margin` 边缘
`padding` 衬垫，填充
然后应该就能区分出这两个属性了，一个是边缘（外边距），指该控件距离父控件或其他控件的边距；另一个是填充（内边距），指该控件内部内容，如文本/图片距离该控件的边距。


{% asset_img css_margin_p.jpg padding和margin属性详解 %}


### Flexbox  

```css
.div{
    display:block;
    
}
```

display: flex;
 
flex-direction: column / row; 可以调换主轴：
flex-direction: column 并不意味着将子元素在交叉轴上排列。而是将主轴从横向变为纵向。
flex-direction 有另外两个值可以设置： row-reverse 和 column-reverse
justify-content 用于控制子元素在主轴上如何对齐。其共有五个可供设置的值：

flex-start
flex-end
center
space-between
space-around

```css
.container {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
}
```