box-shadow和text-shadow差不多，但是要加浏览器前缀:

```
.element {
	-o-box-shadow: 1px 1px 1px #d3d3d3;
	-ms-box-shadow: 1px 1px 1px #d3d3d3;
	-moz-box-shadow: 1px 1px 1px #d3d3d3;
	-webkit-box-shadow: 1px 1px 1px #d3d3d3;
	box-shadow: 1px 1px 1px #d3d3d3;
}
```

和阴影可以定义在元素的内部:

```
.element {
	box-shadow:inset 1px 1px 1px #d3d3d3;
}
```

同样盒阴影也是可以叠加的:

```
.element {
	box-shadow:inset 0px 0px 30px hsl(0, 0%, 0%), 
	           inset 0 0 70px hsla(0, 97%, 53%, 1);
}
```
```