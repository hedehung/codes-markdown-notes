###安装zsh
```
yum install zsh 
```

###安装oh-my-zsh 
```
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

###这个.zshrc配置也非常不错(支持SVN信息显示)
```
cd ~ && wget -O .zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc && source ~/.zshrc
```

###切换默认的shell到zsh
```
chsh -s /bin/zsh
```

###MacOSX下的命令有点不同
```
chsh -s /bin/zsh -udebugger
```
