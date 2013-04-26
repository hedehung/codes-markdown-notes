#Underscore初探

[英文](http://underscorejs.org/)  
[中文](http://learningcn.com/underscore/)

文档简明扼要，非常的清晰，如果没有js经验有erlang和ruby经验的话，也会感觉很亲切，分为几个部分:

* 集合 collections
* 数组 arrays
* 函数 functions
* 对象 objects
* 实用功能 utility
* 链式语法 chaining

_语法就像jQuery的$一样，是一个别名，提供了防止冲突的方法:

```
var underscore = _.noConflict();
```

遍历数组简单的样例:

```
_.each([1, 2, 3], function(num){ alert(num); });
// 和ruby对比
[1,2,3].each{|x|puts x}
// map函数类似，眼前豁然一亮
_.map([1, 2, 3], function(num){ return num * 3; });
```

函数名字更像ruby，很多函数都提供了别名，比如典型的filter和select,all和every,any和some等等。集合处理函数和数组处理函数都是很好理解的，和原生js一样，最难掌握的还是function对象。用的最多的bind函数:

```
var func = function(greeting){ return greeting + ': ' + this.name };
// 给这个对象绑定func方法
// this就是{name : 'moe'}了
func = _.bind(func, {name : 'moe'}, 'hi');
func();
=> 'hi: moe'
```

如果不提供绑定的方法名称，对象里面的方法全部被自动绑定:

```
var buttonView = {
  label   : 'underscore',
  onClick : function(){ alert('clicked: ' + this.label); },
  onHover : function(){ console.log('hovering: ' + this.label); }
};
_.bindAll(buttonView);
// 调用
$('#underscore_button').bind('click', buttonView.onClick);
```

defer,throttle,debounce,wrap等函数看起来比较有意思。
使用功能中有个times函数，rubyer笑了:

```
_(3).times(function(n){ genie.grantWishNumber(n); });
```

mixin允许加入自己的函数，就像$.fn.tool_name一样:

```
_.mixin({
  capitalize : function(string) {
    return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();
  }
});
_("fabio").capitalize();
=> "Fabio"
```

生成唯一id，记得上次我是用靠date()函数转换成秒数生成的:

```
_.uniqueId('contact_');
=> 'contact_1'
_.uniqueId('contact_');
=> 'contact_2'
```

result函数，就像invoke一样的执行器:

```
var object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};
// 集合
_.result(object, 'cheese');
=> "crumpets"
// stuff是个函数
_.result(object, 'stuff');
=> "nonsense"
```

链式语法中的面向对象和函数风格的代码编写方式都是被允许的:

```
_.map([1, 2, 3], function(n){ return n * 2; });
_([1, 2, 3]).map(function(n){ return n * 2; });
```

最后不得不说就是这个template函数了，实现了js模板:

```
var compiled = _.template("hello: <%= name %>");
compiled({name : 'moe'});
=> "hello: moe"
// 集合遍历
var list = "<% _.each(people, function(name) { %> <li><%= name %></li> <% }); %>";
_.template(list, {people : ['moe', 'curly', 'larry']});
=> "<li>moe</li><li>curly</li><li>larry</li>"
还有unescape的功能，显示html,css源代码的时候很有用
var template = _.template("<b><%- value %></b>");
template({value : '<script>'});
=> "<b>&lt;script&gt;</b>"
```
