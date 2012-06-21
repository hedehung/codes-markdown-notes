###创建基本的migations
```
class CreateProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name
      t.text :description
 
      t.timestamps #将会生成created_at和updated_at
    end
  end
 
  def down
    drop_table :products
  end
end
```

###可以在更改结构的时候执行模型的方法更新数据
```
class AddReceiveNewsletterToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.boolean :receive_newsletter, :default => false #默认值是false
    end
    User.update_all ["receive_newsletter = ?", true] #将现有的数据更新为true
  end
 
  def down
    remove_column :users, :receive_newsletter
  end
end
```

migration是继承自ActiveRecord::Migration的子类,这个类提供了up，down回调，定义了如下的方法

* add_column
* add_index
* change_column
* change_table
* create_table
* drop_table
* remove_column
* remove_index
* rename_column

migration支持的列的类型

* :binary
* :boolean
* :date
* :datetime
* :decimal
* :float
* :integer
* :primary_key
* :string
* :text
* :time
* :timestamp

可以没有枚举类型的直接支持，有人实现了mysql的枚举类型支持，可以参考[https://github.com/electronick/enum_column](https://github.com/electronick/enum_column)

可以直接创建模型来创建对应的migrations文件  
```
rails generate model Product name:string description:text
```

也可以创建独立的migrations文件  
```
rails generate migration AddPartNumberToProducts
``` 

将会生成   
```
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
  end
end
```

也可以定义字段   
```
rails generate migration AddPartNumberToProducts part_number:string
```

将会生成  
```
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
    add_column :products, :part_number, :string
  end
end
```

也可以直接定义删除    
```
rails generate migration RemovePartNumberFromProducts part_number:string
```

将会生成remove的操作  
```
class RemovePartNumberFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :part_number
  end
 
  def down
    add_column :products, :part_number, :string
  end
end
```

除了t.timestamps帮助函数外，还有t.references也比较常用.
也可以直接定义sql语句  
```
class ExampleMigration < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.references :category
    end
    #add a foreign key
    execute <<-SQL
      ALTER TABLE products
        ADD CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
    SQL
    add_column :users, :home_page_url, :string
    rename_column :users, :email, :email_address
  end
 
  def down
    rename_column :users, :email_address, :email
    remove_column :users, :home_page_url
    execute <<-SQL
      ALTER TABLE products
        DROP FOREIGN KEY fk_products_categories
    SQL
    drop_table :products
  end
end
```

执行  
```
rake db:migrate
```

或者是带版本执行  
```
rake db:migrate VERSION=20080906120000
```

回滚和重做
```
rake db:rollback
rake db:rollback STEP=3
rake db:migrate:redo STEP=3
```

