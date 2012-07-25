###安装zsh
```
yum install zsh 
```

###安装oh-my-zsh 
```
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

###另外一个.zshrc配置也非常不错
```
cd ~ && wget -O .zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc && source ~/.zshrc
```

###切换默认的shell到zsh
```
chsh -s /bin/zsh
```
