#mixin模式匹配

```
// 和erlang的模式匹配一样,dark可看作symbol或者原子
mixin (dark, @color) {
    color: darken(@color, 10%);
}

// 匹配light
.mixin (light, @color) {
    color: lighten(@color, 10%);

}

// 加下划线匹配左右的模式，哈哈哈，和erlang一样
.mixin (@_, @color) {
    display: block;
}
```

定义之后可以加个开关来全局控制编译行为:

```
// 开灯的样式
@switch: light;

.panel {
	.mixin(@switch, #888);
}

// 关灯模式只需改变@switch为dark即可.
```