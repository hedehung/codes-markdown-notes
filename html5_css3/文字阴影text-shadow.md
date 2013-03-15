```
.element {
	text-shadow: 1px 1px 1px #d3d3d3;
}
```

方向是，向右，向下，第三个值是值模糊距离，不需要可以省略。阴影的颜色可以使用rgba和hsla，但是为了老的浏览器的兼容性都写成:

```
.element {
	text-shadow: 1px 1px 1px #404442;
	text-shadow: 1px 1px 1px hsla(140, 3%, 26%, 0.4);
}
```

要制作左上方的阴影直接使用负值就可以了.

```
.element {
	text-shadow: -4px -4px 0px #d3d3d3;
}
```

阴影效果是可以叠加的:

```
.element {
	text-shadow: 0px 1px #fff, 4px 4px 0px #dad7d7;
}
```