#less常用函数

```
color(@string);  // 将字符串解析为颜色值
percentage(@number); // 将浮点数转换为百分比，例如 0.5 -> 50%

// 可能老的浏览器不支持rgb,rgba,hsl,hsla
// 使用mixin既可以这样，结果生成的hex所有浏览器都认
rgb(@r, @g, @b);                             // 转换为颜色值
rgba(@r, @g, @b, @a);                        // 转换为颜色值
hsl(@hue, @saturation, @lightness);          // 创建颜色值
hsla(@hue, @saturation, @lightness, @alpha); // 创建颜色值

red(@color);                                 // 从颜色值中提取 'red' 值
green(@color);                               // 从颜色值中提取 'green' 值
blue(@color);                                // 从颜色值中提取 'blue' 值
alpha(@color);                               // 从颜色值中提取 'alpha' 值

saturate(@color, 10%);                       // 饱和度增加 10%
desaturate(@color, 10%);                     // 饱和度降低 10%
lighten(@color, 10%);                        // 亮度增加 10%
darken(@color, 10%);                         // 亮度降低 10%
fadein(@color, 10%);                         // 透明度增加 10%
fadeout(@color, 10%);                        // 透明度降低 10%
fade(@color, 50%);                           // 设定透明度为 50%
spin(@color, 10);                            // 色相值增加 10

// 下面的函数很有意思
mix(@color1, @color2, [@weight: 50%]);       // 混合两种颜色
greyscale(@color);                           // 完全移除饱和度，输出灰色

multiply(@color1, @color2);                  // 分别将两种颜色的红绿蓝 (RGB) 三种值做乘法运算，然后再除以 255，输出结果是更深的颜色
screen(@color1, @color2);                    // 与 multiply() 函数效果相反，输出结果是更亮的颜色

overlay(@color1, @color2);                   // 结合 multiply() 与 screen() 两个函数的效果，令浅的颜色变得更浅，深的颜色变得更深

difference(@color1, @color2);                // 从第一个颜色值中减去第二个（分别计算 RGB 三种颜色值），输出结果是更深的颜色

negation(@color1, @color2);                  // 与 difference() 函数效果相反，输出结果是更亮的颜色

average(@color1, @color2);                   // 分别对 RGB 的三种颜色值取平均值，然后输出结果
```