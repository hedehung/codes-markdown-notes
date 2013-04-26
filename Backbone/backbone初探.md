#Backbone初探

Backbone重度依赖于underscore，很多有公司都在使用:

* DocumentCloud
* USA Today
* Hulu
* WordPress
* Disqus
* Khan Academy
* Do
* IRCCloud
* Basecamp
* 等等太华丽了[长列表](http://backbonejs.org/#examples)

分为几个部分:

* Events 事件 Backbone.Event
* Model 模型 Backbone.Model
* Collection 集合 Backbone.Collection
* Router 路由 Backbone.Router
* History 历史记录 Backbone.History
* Sync 同步数据 Backbone.Sync
* View 视图 Backbone.View
* Utility 实用功能 Backbone.Utility

Event时间对象可以被混合到任何对象，看看事件的基本绑定和触发的编程模型:

```
var object = {};
// 继承
_.extend(object, Backbone.Events);
// 定义行为,on其实是bind的别名
// 相反的是off和unbind
object.on("alert", function(msg) {
  alert("Triggered " + msg);
});
// 触发事件
object.trigger("alert", "an event");
```

all可以定义任何触发的事件行为，下面的代理模式，把事件转移到另外一个对象上:

```
proxy.on("all", function(eventName) {
  object.trigger(eventName);
});
```

侦听某个对象的特殊事件:

```
// 除了listentTo还有listenToOnce
view.listenTo(model, 'change', view.render);
// 停止
view.stopListening();
view.stopListening(model);
```

Events模块定义了很多事件，比如add,remove,sort,change等等。
定义数据模型的风格完全一致:

```
// Backbone.Model.extend
var Sidebar = Backbone.Model.extend({
  promptColor: function() {
    var cssColor = prompt("Please enter a CSS color:");
    this.set({color: cssColor});
  }
});

// 创建实例对象
window.sidebar = new Sidebar;
// 定义事件，当前对象的color改变的时候执行的行为
sidebar.on('change:color', function(model, color) {
  $('#sidebar').css({background: color});
});
// 将触发
sidebar.set({color: 'white'});
// 当然也可直接调用
sidebar.promptColor();
```

模型提供很多数据操作方法，有些是属性操作，有的数据转换，还有数据验证，数据改变标志等等。表示模型的集合使用Backbone.Collection，比如创建个图书馆:

```
var Library = Backbone.Collection.extend({
  model: Book
});
```

还能方便的实现多太特性:

```
var Library = Backbone.Collection.extend({
  // model方法 
  model: function(attrs, options) {
    if (condition) {
      return new PublicDocument(attrs, options);
    } else {
      return new PrivateDocument(attrs, options);
    }
  }
});
```

定义路由，直接解决地址栏查询数据问题:

```
var Workspace = Backbone.Router.extend({
  routes: {
    "help":                 "help",    // #help
    "search/:query":        "search",  // #search/kiwis
    "search/:query/p:page": "search"   // #search/kiwis/p7
  },
  help: function() {
    ...
  },
  search: function(query, page) {
    ...
  }
});
```

Backbone.History解决历史访问记录问题，Backbone.Sync实现数据同步到服务器上。
Backbone.View太强大了，你不需要和DOM，JSON等打交道了，可以使用任何的模板语法:

```
var ItemView = Backbone.View.extend({
  tagName: 'li'
});

var BodyView = Backbone.View.extend({
  el: 'body'
});

var item = new ItemView();
var body = new BodyView();

alert(item.el + ' ' + body.el);

// cached object
view.$el.show();
listView.$el.append(itemView.el);

// render方法需要被覆盖，默认行为是什么都不干
var Bookmark = Backbone.View.extend({
  template: _.template(…),
  render: function() {
    this.$el.html(this.template(this.model.attributes));
    return this;
  }
});
```

一个文档视图的样子:

```
var DocumentView = Backbone.View.extend({

  events: {
    "dblclick"                : "open",
    "click .icon.doc"         : "select",
    "contextmenu .icon.doc"   : "showMenu",
    "click .show_notes"       : "toggleNotes",
    "click .title .lock"      : "editAccessLevel",
    "mouseover .title .date"  : "showTooltip"
  },

  render: function() {
    this.$el.html(this.template(this.model.attributes));
    return this;
  },

  open: function() {
    window.open(this.model.get("viewer_url"));
  },

  select: function() {
    this.model.set({selected: true});
  },

  ...

});
```

解决冲突:

```
var localBackbone = Backbone.noConflict();
var model = localBackbone.Model.extend(...);
```