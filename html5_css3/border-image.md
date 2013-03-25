#border-image

参数:

1. 图片地址
2. 边框宽度(固定像素或者是百分比，上右下左)
3. 过渡效果定义(stretch是默认值，先是水平后是垂直)

```
border-image: url(img/border.png) 0 12 0 12 stretch stretch;
```

三个过渡效果:

1. stretch 延伸
2. repeat 平铺，但是图片超过边界的部分被截断
3. round 平铺，但是根据图片的尺寸动态调节图片大小使其正好铺满整个边框

遗憾的是，这个特性IE10和Opera mini(5-7)都不支持。

代码样例:

```
border-width: 0 5 0 5;
-webkit-border-image: url(boder.png) 0 5 0 5 stretch stretch;
-moz-border-image: url(border.png) 0 5 0 5 stretch stretch;

```