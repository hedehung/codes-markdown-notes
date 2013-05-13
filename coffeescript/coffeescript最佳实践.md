#coffeescript最佳实践

###for...in被编译成for循环而不是更慢的也不兼容老的浏览器的forEach

```
//js的做法
// 1. for
for (var i=0; i < array.length; i++)
  myFunction(array[i]);
      
// 2. ES5 forEach
array.forEach(function(item, i){
  myFunction(item)
});

//coffeescript
myFunction(item) for item in array
```

###map函数

```
//js的做法
//1. for
var result = []
for (var i=0; i < array.length; i++)
  result.push(array[i].name)

//2.ES5 map
var result = array.map(function(item, i){
  return item.name;
});

//coffeescript
//不要忘记圆括号
result = (item.name for item in array)
```

###filter函数

```
//js的做法
//1. for
var result = []
for (var i=0; i < array.length; i++)
  if (array[i].name == "test")
    result.push(array[i])
    
//2. ES5 filter
result = array.filter(function(item, i){
  return item.name == "test"
});

//coffeescript
//CoffeeScript的基础语法使用when关键字通过一个比较来过滤数组项。在背后会产生一个for循环，整个运行过程都包裹在一个匿名函数中，以防止作用域泄漏或变量冲突。
//注意圆括号
result = (item for item in array when item.name is "test")
```

###包含

```
//IE不提供的indexOf函数
var included = (array.indexOf("test") != -1)
//coffeescript
included = "test" in array
```

###属性迭代

```
//js
var object = {one: 1, two: 2}
for(var key in object) alert(key + " = " + object[key])

//coffeescript
object = {one: 1, two: 2}
alert("#{key} = #{value}") for key, value of object
````

###最大值最小值

```
Math.max [14, 35, -7, 46, 98]... # 98
Math.min [14, 35, -7, 46, 98]... # -7
```

###默认值处理

```
//如果hash求值为false，则把它设置为一个空对象。在这里需要注意，表达式0、""和null都会被当作false。
hash or= {}
//存在操作符，只有hash是undefined或者null时才会触发。
hash ?= {}
```

###解构赋值

```
someObject = { a: 'value for a', b: 'value for b' }
{ a, b } = someObject
console.log "a is '#{a}', b is '#{b}'"
```