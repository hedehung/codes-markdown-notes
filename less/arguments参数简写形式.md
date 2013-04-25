#mixinb不定参数和@arguments的使用

```
.box-shadow (@x: 0, @y: 0, @blur: 1px, @color: #000) {
    box-shadow: @arguments;
    -moz-box-shadow: @arguments;
    -webkit-box-shadow: @arguments;
}

// 调用
.box-shadow(2px, 5px);

// 输出
box-shadow: 2px 5px 1px #000;
-moz-box-shadow: 2px 5px 1px #000;
-webkit-box-shadow: 2px 5px 1px #000;
```

使用点语法限制参数:

* .mixin (...) { // 匹配 0-N 个参数,也就是不限制参数个数  
* .mixin () { // 不匹配任何参数
* .mixin (@a: 1) { // 匹配 0-1 个参数,也就是顶多1个参数，如有参数名为@a
* .mixin (@a: 1, ...) { // 匹配 0-N 个参数,如有@a表示第一个参数
* .mixin (@a, ...) { // 匹配 1-N 个参数,第一个参数是必须的
* .mixin (@a, @rest...) { @a表示第一个参数,@rest表示余下的参数

**任何情况下，@arguments都表示所有的参数,和js里面的函数一样.**