# 目录
http://mirrors.jenkins-ci.org/war/latest/jenkins.war  
/var/www/jenkins/

# java
/usr/lib/java

sudo update-alternatives --install /usr/bin/java java /usr/lib/java/bin/java 300  
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/java/bin/javac 300  
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/java/bin/jar 300  
sudo update-alternatives --install /usr/bin/javah javah /usr/lib/java/bin/javah 300  
sudo update-alternatives --install /usr/bin/javap javap /usr/lib/java/bin/javap 300   

# 选择默认版本
sudo update-alternatives --config java

# 启动
java -jar jenkins.war  
nohup java -jar jenkins.war --httpPort=83 > jenkins.log 2>&1

# 重启
{jenkins_url}/restart

# 查看所有的cli
{jenkins_url}/cli

# 帐号
* admin  
* dOMzfm@44  