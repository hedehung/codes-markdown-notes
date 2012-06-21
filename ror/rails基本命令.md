###基本命令
* rails new app 生成一个rails工程
* rails new app -d mysql -T 执行数据库类型并且跳过test_unit的创建
* rails s 启动服务器
* rails s -p 8080 指定端口启动服务器
* rails dbconsole 进入数据库shell命令行
* rails db 同上
* rails generate controller users 生成控制器
* rails generate controller admin/users 指定空间
* rails generate controller Greetings hello 指定方法
* rails generate model user生成模型
* rails generate model admin/user 指定空间
* rails console 进入rails的shell，默认进入开发环境
* rails console --sandbox 沙盒环境，所有的更改都会被回滚
* rails c production 进入生产环境
* rails runner "Model.long_running_method" 运行模型中的方法
* rails runner -e production "Model.long_running_method" 指定环境运行
* rails generate model Oops &&  rails destroy model Oops 销毁模型
* rake --tasks 查看所有的rake任务
* rake about 查看概要
* rake assets:precompile 预编译资源文件
* rake assets:clean 清理编译好的资源文件
* rake notes 列出代码标记(FIXME, OPTIMIZE or TODO)
* rake notes:fixme 限制标记
