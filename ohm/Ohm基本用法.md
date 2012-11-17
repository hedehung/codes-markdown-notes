###安装和使用
```
gem install ohm
```

###使用默认的redis配置
```ruby
Ohm.connect
Ohm.redis.set "Foo", "Bar"
Ohm.redis.get "Foo"
```

###申明模型
```ruby
class Event < Ohm::Model
end
```

###属性
```
attribute :name
```

###引用
```
reference :person, :Person
```

###集合
```
set :person, :Person
```

###累计
```
counter :votes
```

###索引
```
index :name
```

###其他数据结构支持
```
list
collection
unique
```

###完整的例子
```ruby
class Event < Ohm::Model
  attribute :name
  reference :venue, :Venue
  set :participants, :Person
  counter :votes

  index :name

  def validate
    assert_present :name
  end
end

class Venue < Ohm::Model
  attribute :name
  collection :events, :Event
end

class Person < Ohm::Model
  attribute :name
end
```

###创建和查询
```ruby
event = Event.create :name => "zhangsan"
event = Event.with(:name => "zhangsan")
event.id
event == Event[1]
Event[2]
Event.all
```

###查询支持
```
find
with
limit
order
by参数
sort
sort_by
```

###特殊用法(直接redis命令)
```ruby
self.key[action_key].set action_value
self.key[action_key].expire USER_ACTION_EXPIRE
self.key[action_key].get
self.key[action_key].del
```
