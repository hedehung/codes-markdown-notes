###使用select 
```
Event.find(:all, :select => "id, title, description")
```

###搭配named_scope设定 
```
class User < ActiveRecord::Base 
  named_scope :short, :select => "id,nme, email"
end

User.short.find(:all)
```

###使用include
```
@events = Event.find(:all, :include => [:group])
@events.each do |e|
  e.group.title
end
```

###使用include设定
```
class User <ActiveRecord::Base 
  has_one :foo, :include => [:bar]
end

#同时载入bar
@user.foo
```

###使用joins代替include
```
Group.find(:all, :include => [:group_memberships], :conditions => ["group_memberships.created_at > ?", Time.now - 30.days])
#改成
Group.find(:all, :joins => [:group_memberships], :conditions => ["group_memberships.created_at > ?", Time.now - 30.days])
```

###使用counter_cache解决size问题
```
class Topic < ActiveRecord::Base 
  belongs_to :topic, :counter_cache => true
end
```
