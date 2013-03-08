#最基本的文件结构，定义了视口和基本的文件:

```html
<!DOCTYPE html>
<html>
<head>
	<title>Bootstrap 101 Template</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Bootstrap -->
	<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
</head>
<body>
	<h1>Hello, world!</h1>
	<script src="http://code.jquery.com/jquery.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>
```

#定义fav图标的代码:

```html
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
<link rel="shortcut icon" href="../assets/ico/favicon.png">
```

#定义菜单:

```html
<div class="navbar navbar-inverse navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">
			<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>     
       <a class="brand" href="#">Project name</a>
       <div class="nav-collapse collapse">
	       <ul class="nav">
					<li class="active"><a href="#">Home</a></li>
					<li><a href="#about">About</a></li>
					<li><a href="#contact">Contact</a></li>
				</ul>
       </div><!--/.nav-collapse -->
     </div>
	</div>
</div>
```

#正文都在continer(-fluid)下面:

```html
<div class="container">
	// 固定布局
</div>

<div class="container-fluid">
	// 流式布局
</div>
```

#定义下拉式菜单和输入框:

```html
<div class="nav-collapse collapse">
	<ul class="nav">
	  <li class="active"><a href="#">Home</a></li>
	  <li><a href="#about">About</a></li>
	  <li><a href="#contact">Contact</a></li>
	  <li class="dropdown">
	    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
	    <ul class="dropdown-menu">
	      <li><a href="#">Action</a></li>
	      <li><a href="#">Another action</a></li>
	      <li><a href="#">Something else here</a></li>
	      <li class="divider"></li>
	      <li class="nav-header">Nav header</li>
	      <li><a href="#">Separated link</a></li>
	      <li><a href="#">One more separated link</a></li>
	    </ul>
	  </li>
	</ul>
	<!-- 使用pull-right放置在右边 -->
	<form class="navbar-form pull-right">
	  <input class="span2" type="text" placeholder="Email">
	  <input class="span2" type="password" placeholder="Password">
	  <button type="submit" class="btn">Sign in</button>
	</form>
</div><!--/.nav-collapse -->
```

#使用continer-fluid:

```html
<div class="navbar navbar-inverse navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container-fluid">
      <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="brand" href="#">Project name</a>
      <div class="nav-collapse collapse">
        <p class="navbar-text pull-right">
          Logged in as <a href="#" class="navbar-link">Username</a>
        </p>
        <ul class="nav">
          <li class="active"><a href="#">Home</a></li>
          <li><a href="#about">About</a></li>
          <li><a href="#contact">Contact</a></li>
        </ul>
      </div><!--/.nav-collapse -->
    </div>
  </div>
</div>
```

#所谓的hero-unit效果(primary):

```html
<!-- Main hero unit for a primary marketing message or call to action -->
<div class="hero-unit">
	<h1>Hello, world!</h1>
	<p>This is a template for a simple marketing or informational website. It includes a large callout called the hero unit and three supporting pieces of content. Use it as a starting point to create something more unique.</p>
	<p><a href="#" class="btn btn-primary btn-large">Learn more &raquo;</a></p>
</div>
```

#使用row行:

```html
<div class="row">
	<div class="span4">
	  <h2>Heading</h2>
	  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
	  <p><a class="btn" href="#">View details &raquo;</a></p>
	</div>
	<div class="span4">
	  <h2>Heading</h2>
	  <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
	  <p><a class="btn" href="#">View details &raquo;</a></p>
	</div>
	<div class="span4">
	  <h2>Heading</h2>
	  <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
	  <p><a class="btn" href="#">View details &raquo;</a></p>
	</div>
</div>
```

#container-fluid和row-fluid相结合产生流式布局系统:

```html
<div class="container-fluid">
  <div class="row-fluid">
    <div class="span3">
    	...nav-list
    </div>
    <div class="span9">
		<div class="hero-unit"> ... </div>	
		<div class="row-fluid">
        	<div class="span4"> ... </div>
        	<div class="span4"> ... </div>
        	<div class="span4"> ... </div>
        </div>
        <div class="row-fluid">
        	<div class="span4"> ... </div>
        	<div class="span4"> ... </div>
        	<div class="span4"> ... </div>
        </div>	
    </div>
  </div> <!--/row-->
```

#使用很窄的container叫做container-narrow:

```css
margin: 0 auto;
max-width: 700px;
```

```html
<div class="container-narrow">
  <div class="masthead">
    <ul class="nav nav-pills pull-right">
      <li class="active"><a href="#">Home</a></li>
      <li><a href="#">About</a></li>
      <li><a href="#">Contact</a></li>
    </ul>
    <h3 class="muted">Project name</h3>
  </div>
  <hr>
  <div class="jumbotron">
    <h1>Super awesome marketing speak!</h1>
    <p class="lead">Cras justo odio, dapibus ac facilisis in, egestas eget quam. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
    <a href="#" class="btn btn-large btn-success">Sign up today</a>
  </div>
  <hr>
  <div class="row-fluid marketing">
    <div class="span6">
      <h4>Subheading</h4>
      <p>Donec id elit non mi porta gravida at eget metus. Maecenas faucibus mollis interdum.</p>
      <h4>Subheading</h4>
      <p>Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Cras mattis consectetur purus sit amet fermentum.</p>
      <h4>Subheading</h4>
      <p>Maecenas sed diam eget risus varius blandit sit amet non magna.</p>
    </div>
    <div class="span6">
      <h4>Subheading</h4>
      <p>Donec id elit non mi porta gravida at eget metus. Maecenas faucibus mollis interdum.</p>
      <h4>Subheading</h4>
      <p>Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Cras mattis consectetur purus sit amet fermentum.</p>
      <h4>Subheading</h4>
      <p>Maecenas sed diam eget risus varius blandit sit amet non magna.</p>
    </div>
  </div>
  <hr>
  <div class="footer">
    <p>&copy; Company 2013</p>
  </div>
</div>
```

#默认的导航栏:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      <ul class="nav">
        <li class="active"><a href="#">Home</a></li>
        <li><a href="#">Projects</a></li>
        <li><a href="#">Services</a></li>
        <li><a href="#">Downloads</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Contact</a></li>
      </ul>
    </div>
  </div>
</div>
```

#定义全铺的页脚:

```html
<div id="footer">
  <div class="container">
    <p class="muted credit">
    	Example courtesy 
    	<a href="http://martinbean.co.uk">Martin Bean</a> and 
    	<a href="http://ryanfait.com/sticky-footer/">Ryan Fait</a>.
    </p>
  </div>
</div>
```

#定义幻灯片:

```html
<div class="carousel slide" id="myCarousel">
  <div class="carousel-inner">
    <div class="item active">
      <img alt="" src="../assets/img/examples/slide-01.jpg">
      <div class="container">
        <div class="carousel-caption">
          <h1>Example headline.</h1>
          <p class="lead">Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
          <a href="#" class="btn btn-large btn-primary">Sign up today</a>
        </div>
      </div>
    </div>
    <div class="item">
      <img alt="" src="../assets/img/examples/slide-02.jpg">
      <div class="container">
        <div class="carousel-caption">
          <h1>Another example headline.</h1>
          <p class="lead">Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
          <a href="#" class="btn btn-large btn-primary">Learn more</a>
        </div>
      </div>
    </div>
    <div class="item">
      <img alt="" src="../assets/img/examples/slide-03.jpg">
      <div class="container">
        <div class="carousel-caption">
          <h1>One more for good measure.</h1>
          <p class="lead">Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
          <a href="#" class="btn btn-large btn-primary">Browse gallery</a>
        </div>
      </div>
    </div>
  </div>
  <a data-slide="prev" href="#myCarousel" class="left carousel-control">‹</a>
  <a data-slide="next" href="#myCarousel" class="right carousel-control">›</a>
</div>
```

#基本的网格系统和偏移:

```html
<div class="row">
	<div class="span4">...</div>
	<div class="span8">...</div>
</div>

<div class="row">
    <div class="span4">...</div>
    <div class="span3 offset2">...</div>
</div>

<div class="row">
    <div class="span9">
	    Level 1 column
	    <div class="row">
	    	<div class="span6">Level 2</div>
	    	<div class="span3">Level 2</div>
	    </div>
    </div>
</div>

```

#加上-fluid则切换到流式布局:

```html
<div class="row-fluid">
    <div class="span4">...</div>
    <div class="span8">...</div>
</div>

<div class="row-fluid">
    <div class="span4">...</div>
    <div class="span4 offset2">...</div>
</div>

<div class="row-fluid">
    <div class="span12">
    	Fluid 12
    	<div class="row-fluid">
    		<div class="span6">
    			Fluid 6
    			<div class="row-fluid">
    				<div class="span6">Fluid 6</div>
    				<div class="span6">Fluid 6</div>
    			</div>
    		</div>
    		<div class="span6">Fluid 6</div>
    	</div>
    </div>
</div>
```

#两栏流式布局:

```html
<div class="container-fluid">
    <div class="row-fluid">
	    <div class="span2">
	    	<!--Sidebar content-->
	    </div>
    	<div class="span10">
	    	<!--Body content-->
	    </div>
    </div>
</div>
```

#开启响应式特性:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
```