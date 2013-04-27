#Backbone Todos解析

![todos](http://backbonejs.org/docs/images/todos.png)

先看markup,使用的html5,非常清晰,注意几个id:

* id="new-todo"
* id="toggle-all"
* id="clear-completed"

```
<header>
  <h1>Todos</h1>
  <input id="new-todo" type="text" placeholder="What needs to be done?">
</header>

<section id="main">
  <input id="toggle-all" type="checkbox">
  <label for="toggle-all">Mark all as complete</label>
  <ul id="todo-list"></ul>
</section>

<footer>
  <a id="clear-completed">Clear completed</a>
  <div id="todo-count"></div>
</footer>
```

这些就是全部的html标签代码了，todos的细节被模板化了，放在了页脚底部。模板代码有两段，第一段是todo条目(Todo Item)的代码，script类型是text/template，注意数据传递是如何工作的，几个关键点:

* id="item-template"
* class="view"
* title被调用了2次，1次是label，1次是input
* class="toggle"
* class="destroy"
* <%= done ? 'checked="checked"' : '' %>

```
 <script type="text/template" id="item-template">
 <div class="view">
  <input class="toggle" type="checkbox" <%= done ? 'checked="checked"' : '' %> />
  <label><%- title %></label>
  <a class="destroy"></a>
 </div>
 <input class="edit" type="text" value="<%- title %>" />
 </script>
```

第二段是该要信息的模板，几个关键点:

* id="stats-template"
* <%= done == 1 ? 'item' : 'items' %>
* id="clear-completed"
* class="todo-count"

```
 <script type="text/template" id="stats-template">
 <% if (done) { %>
  <a id="clear-completed">Clear <%= done %> completed <%= done == 1 ? 'item' : 'items' %></a>
 <% } %>
 <div class="todo-count"><b><%= remaining %></b> <%= remaining == 1 ? 'item' : 'items' %> left</div>
 </script>
```

核心的MVC代码都在todos.js文件中。先看模型的代码:

```
var Todo = Backbone.Model.extend({
  defaults: function() {
    return {
      title: "empty todo...",
      // Todos是collection list，下面定义的
      order: Todos.nextOrder(),
      done: false
    };
  },

  toggle: function() {
    this.save({done: !this.get("done")});
  }
});
```

集合的代码，里面使用了underscore的where和without函数:

* 取得完成的个数 return this.where({done: true});
* 取得未完成的个数 return this.without.apply(this, this.done());
* 实现了nextOrder函数，注意里面的last，backbone确实重度依赖underscore
* 保持插入顺序 comparator: 'order'

```
var TodoList = Backbone.Collection.extend({
  model: Todo,
  localStorage: new Backbone.LocalStorage("todos-backbone"),
  done: function() {
    return this.where({done: true});
  },
  remaining: function() {
    return this.without.apply(this, this.done());
  },
  nextOrder: function() {
    if (!this.length) return 1;
    return this.last().get('order') + 1;
  },
  comparator: 'order'
});

var Todos = new TodoList;
```

视图分为两端，第一段是每个todo条目的:

```
var TodoView = Backbone.View.extend({
  // 使用的标签 
  // todo-list的声明 <ul id="todo-list"></ul>
  tagName:  "li",
  // 模板
  template: _.template($('#item-template').html()),
  // 事件绑定
  events: {
    "click .toggle"   : "toggleDone",
    "dblclick .view"  : "edit",
    "click a.destroy" : "clear",
    "keypress .edit"  : "updateOnEnter",
    "blur .edit"      : "close"
  },
  initialize: function() {
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
  },
  // $el是缓存的jquery对象
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    // 从保存的数据中拿出标志
    this.$el.toggleClass('done', this.model.get('done'));
    // 引用编辑框
    this.input = this.$('.edit');
    return this;
  },
  toggleDone: function() {
    // 持久化标志数据
    this.model.toggle();
  },
  edit: function() {
    this.$el.addClass("editing");
    this.input.focus();
  },
  close: function() {
    var value = this.input.val();
    if (!value) {
      this.clear();
    } else {
      this.model.save({title: value});
      this.$el.removeClass("editing");
    }
  },
  updateOnEnter: function(e) {
    if (e.keyCode == 13) this.close();
  },
  clear: function() {
    this.model.destroy();
  }
});
```

最后是整个应用程序的View视图:

```
var AppView = Backbone.View.extend({
  el: $("#todoapp"),
  statsTemplate: _.template($('#stats-template').html()),
  events: {
    "keypress #new-todo":  "createOnEnter",
    "click #clear-completed": "clearCompleted",
    "click #toggle-all": "toggleAllComplete"
  },
  initialize: function() {
    this.input = this.$("#new-todo");
    this.allCheckbox = this.$("#toggle-all")[0];

    this.listenTo(Todos, 'add', this.addOne);
    this.listenTo(Todos, 'reset', this.addAll);
    this.listenTo(Todos, 'all', this.render);

    this.footer = this.$('footer');
    this.main = $('#main');

    Todos.fetch();
  },
  render: function() {
    var done = Todos.done().length;
    var remaining = Todos.remaining().length;

    if (Todos.length) {
      this.main.show();
      this.footer.show();
      this.footer.html(this.statsTemplate({done: done, remaining: remaining}));
    } else {
      this.main.hide();
      this.footer.hide();
    }

    this.allCheckbox.checked = !remaining;
  },
  addOne: function(todo) {
    var view = new TodoView({model: todo});
    this.$("#todo-list").append(view.render().el);
  },
  addAll: function() {
    Todos.each(this.addOne, this);
  },
  createOnEnter: function(e) {
    if (e.keyCode != 13) return;
    if (!this.input.val()) return;

    Todos.create({title: this.input.val()});
    this.input.val('');
  },
  clearCompleted: function() {
    _.invoke(Todos.done(), 'destroy');
    return false;
  },
  toggleAllComplete: function () {
    var done = this.allCheckbox.checked;
    Todos.each(function (todo) { todo.save({'done': done}); });
  }
});

// kick off
var App = new AppView;
```