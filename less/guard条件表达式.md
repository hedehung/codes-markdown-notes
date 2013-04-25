#Guard条件表达式

类似于media和erlang的匹配:

```
.mixin (@a) when (lightness(@a) >= 50%) {
    background-color: black;
}

.mixin (@a) when (lightness(@a) < 50%) {
    background-color: white;
}

.mixin (@a) {
    color: @a;
}

// 调用
.class1 { .mixin(#ddd) }
.class2 { .mixin(#555) }

// 输出

.class1 {
    background-color: black;
    color: #ddd;
}

.class2 {
    background-color: white;
    color: #555;
}
```

值得注意的是，true是唯一判断为真的匹配值，也就是:

```
.truth (@a) when (@a) { ... }
.truth (@a) when (@a = true) { ... }

// 调用
.class {
	.truth(40); // 不会匹配上面的 mixin
}
```

使用逗号表示分割，表示或:

```
.mixin (@a) when (@a > 10), (@a < -10) { ... }
```

使用and表示并且: 

```
.mixin (@a) when (isnumber(@a)) and (@a > 0) { ... }
```

比较参数:

```
@media: mobile;

.mixin (@a) when (@media = mobile) { ... }
.mixin (@a) when (@media = desktop) { ... }

.max (@a, @b) when (@a > @b) { width: @a }
.max (@a, @b) when (@a < @b) { width: @b }
```

使用 is*函数判断值类型:

```
.mixin (@a, @b: 0) when (isnumber(@b)) { ... }
.mixin (@a, @b: black) when (iscolor(@b)) { ... }
```

基本类型的判断函数:

* iscolor
* isnumber
* isstring
* iskeyword
* isurl

还可以使用否定条件:

```
.mixin (@b) when not (@b > 0) { ... }
.mixin (@b) when not (isnumber(@b)) { ... }
```