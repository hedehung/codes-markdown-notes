#SASS

###scss文件

```
/* style.scss */
#navbar {
  width: 80%;
  height: 23px;
}
```

###监测

```
sass --watch style.scss:style.css
sass --watch stylesheets/sass:stylesheets/compiled
```

###嵌套

```
#navbar {
  width: 80%;
  height: 23px;

  ul { list-style-type: none; }
  li {
    float: left;
    a { font-weight: bold; }
  }
}
// 可以嵌套属性
.fakeshadow {
  border: {
    style: solid;
    left: {
      width: 4px;
      color: #888;
    }
    right: {
      width: 2px;
      color: #ccc;
    }
  }
}
//  生成border-left和border-right
```

###父引用

```
a {
  color: #ce4dd6;
  &:hover { color: #ffb3ff; }
  &:visited { color: #c458cb; }
}
```

###定义变量

```
$main-color: #ce4dd6;
$style: solid;

#navbar {
  border-bottom: {
    color: $main-color;
    style: $style;
  }
}

a {
  color: $main-color;
  &:hover { border-bottom: $style 1px; }
}
```

###操作符和函数

```
#navbar {
  $navbar-width: 800px;
  $items: 5;
  $navbar-color: #ce4dd6;

  width: $navbar-width;
  border-bottom: 2px solid $navbar-color;

  li {
    float: left;
    width: $navbar-width/$items - 10px;

    background-color:
      lighten($navbar-color, 20%);
    &:hover {
      background-color:
        lighten($navbar-color, 10%);
    }
  }
}
```

###组合器

```
$vert: top;
$horz: left;
$radius: 10px;

.rounded-#{$vert}-#{$horz} {
  border-#{$vert}-#{$horz}-radius: $radius;
  -moz-border-radius-#{$vert}#{$horz}: $radius;
  -webkit-border-#{$vert}-#{$horz}-radius: $radius;
}
```

###混合体，就像函数，比less的语法麻烦些，不过显得更清晰

```
// @mixin 
@mixin rounded-top-left {
  $vert: top;
  $horz: left;
  $radius: 10px;

  border-#{$vert}-#{$horz}-radius: $radius;
  -moz-border-radius-#{$vert}#{$horz}: $radius;
  -webkit-border-#{$vert}-#{$horz}-radius: $radius;
}
// @include 
#navbar li { @include rounded-top-left; }
#footer { @include rounded-top-left; }
// 定义参数
@mixin rounded($vert, $horz, $radius: 10px) {
  border-#{$vert}-#{$horz}-radius: $radius;
  -moz-border-radius-#{$vert}#{$horz}: $radius;
  -webkit-border-#{$vert}-#{$horz}-radius: $radius;
}
#navbar li { @include rounded(top, left); }
#footer { @include rounded(top, left, 5px); }
#sidebar { @include rounded(top, left, 8px); }
```

###文件导入

```
/* _rounded.scss */
@mixin rounded($vert, $horz, $radius: 10px) {
  border-#{$vert}-#{$horz}-radius: $radius;
  -moz-border-radius-#{$vert}#{$horz}: $radius;
  -webkit-border-#{$vert}-#{$horz}-radius: $radius;
}
// import
@import "rounded";

#navbar li { @include rounded(top, left); }
#footer { @include rounded(top, left, 5px); }
#sidebar { @include rounded(top, left, 8px); }
```