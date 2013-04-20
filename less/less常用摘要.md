#Less常用

###定义变量

```
@color: #4D926F;
// 使用直接@color
```

###定义混合体，像是函数

```
.rounded-corners (@radius: 5px) {
  -webkit-border-radius: @radius;
  -moz-border-radius: @radius;
  -ms-border-radius: @radius;
  -o-border-radius: @radius;
  border-radius: @radius;
}
// 调用的时候可以加!important关键字.
```

###嵌套规则

```
#header {
  p { font-size: 12px;
    a { text-decoration: none;
      &:hover { border-width: 1px }
    }
  }
}
```

###&的使用

```
&:hover,&.className 会生成没有空格的选择器
#header p a:hover {
  border-width: 1px;
}
& .className 会生成有空格的选择器
```

###运算

```
@base-color: #111;
color: (@base-color + #003300);
// cool
@base: 5%;
@filler: (@base * 2);
@other: (@base + @filler);
// so cool
color: (#888 / 4);
background-color: (@base-color + #111);
height: (100% / 2 + @filler);
```

###媒体查询

```
.one {
    @media (width: 400px) {
        font-size: 1.2em;
        @media print and color {
            color: blue;
        }
    }
}
```

###组合器

```
.child, .sibling {
    .parent & {
        color: black;
    }
    & + & {
        color: red;
    }
}
// 将生成
.parent .child,
.parent .sibling {
    color: black;
}
.child + .child,
.child + .sibling,
.sibling + .child,
.sibling + .sibling {
    color: red;
}
```

###帮助函数

```
@base: #f04615;
@width: 0.5;

.class {
  width: percentage(0.5); // returns `50%`
  color: saturate(@base, 5%);
  background-color: spin(lighten(@base, 25%), 8);
}	
```

###注释

```
/* Hello, I'm a CSS-style comment */
// Hi, I'm a silent comment, I won't show up in your CSS
```

###导入用于组合文件

```
@import "vars.css";
@import "functions.css";
// 媒体查询条件导入
@import "library.less" screen and (max-width: 400px); 
// import with media queries
```

###字符串感知

```
@base-url: "http://assets.fnord.com";
background-image: url("@{base-url}/images/bg.png");'
//@{selector}
@name: blocked;
.@{name} {
    color: black;
}
// 输出非css语法
.class {
  filter: ~"ms:alwaysHasItsOwnSyntax.For.Stuff()";
}
```

###js执行器

```
@var: `"hello".toUpperCase() + '!'`;
// @var: "HELLO!";
@str: "hello";
@var: ~`"@{str}".toUpperCase() + '!'`;
```

###客户端使用

```
 <link rel="stylesheet/less" type="text/css" href="styles.less" />
 <script src="less.js" type="text/javascript"></script>
```

###函数参考

```
escape(@string); // URL encodes a string
e(@string); // escape string content
%(@string, values...); // formats a string

unit(@dimension, [@unit: ""]); // remove or change the unit of a dimension
color(@string); // parses a string to a color
data-uri([mimetype,] url); // * inlines a resource and falls back to url()

ceil(@number); // rounds up to an integer
floor(@number); // rounds down to an integer
percentage(@number); // converts to a %, e.g. 0.5 -> 50%
round(number, [places: 0]); // rounds a number to a number of places
sqrt(number); // * calculates square root of a number
abs(number); // * absolute value of a number
sin(number); // * sine function
asin(number); // * arcsine - inverse of sine function
cos(number); // * cosine function
acos(number); // * arccosine - inverse of cosine function
tan(number); // * tangent function
atan(number); // * arctangent - inverse of tangent function
pi(); // * returns pi
pow(@base, @exponent); // * first argument raised to the power of the second argument
mod(number, number); // * first argument modulus second argument

convert(number, units); // * converts between number types
unit(number, units); // *changes number units without converting it
color(string); // converts string or escaped value into color

rgb(@r, @g, @b); // converts to a color
rgba(@r, @g, @b, @a); // converts to a color
argb(@color); // creates a #AARRGGBB
hsl(@hue, @saturation, @lightness); // creates a color
hsla(@hue, @saturation, @lightness, @alpha); // creates a color
hsv(@hue, @saturation, @value); // creates a color
hsva(@hue, @saturation, @value, @alpha); // creates a color

hue(@color); // returns the `hue` channel of @color in the HSL space
saturation(@color); // returns the `saturation` channel of @color in the HSL space
lightness(@color); // returns the 'lightness' channel of @color in the HSL space
hsvhue(@color); // * returns the `hue` channel of @color in the HSV space
hsvsaturation(@color); // * returns the `saturation` channel of @color in the HSV space
hsvvalue(@color); // * returns the 'value' channel of @color in the HSV space
red(@color); // returns the 'red' channel of @color
green(@color); // returns the 'green' channel of @color
blue(@color); // returns the 'blue' channel of @color
alpha(@color); // returns the 'alpha' channel of @color
luma(@color); // returns the 'luma' value (perceptual brightness) of @color

saturate(@color, 10%); // return a color 10% points *more* saturated
desaturate(@color, 10%); // return a color 10% points *less* saturated
lighten(@color, 10%); // return a color 10% points *lighter*
darken(@color, 10%); // return a color 10% points *darker*
fadein(@color, 10%); // return a color 10% points *less* transparent
fadeout(@color, 10%); // return a color 10% points *more* transparent
fade(@color, 50%); // return @color with 50% transparency
spin(@color, 10); // return a color with a 10 degree larger in hue
mix(@color1, @color2, [@weight: 50%]); // return a mix of @color1 and @color2
greyscale(@color); // returns a grey, 100% desaturated color
contrast(@color1, [@darkcolor: black], [@lightcolor: white], [@threshold: 43%]); // return @darkcolor if @color1 is > 43% luma
                    // otherwise return @lightcolor, see notes
multiply(@color1, @color2);
screen(@color1, @color2);
overlay(@color1, @color2);
softlight(@color1, @color2);
hardlight(@color1, @color2);
difference(@color1, @color2);
exclusion(@color1, @color2);
average(@color1, @color2);
negation(@color1, @color2);
```