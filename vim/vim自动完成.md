###指定字典
```
set dictionary+=/path/words.txt
```

###单词补齐
```
ctrl+x,k
```

###打来拼写检查和修复
```
set spell
ctrl+x,s
```

###处理文件路径
```
ctrl+x,f
```

###补齐敲过的单词
```
#忽略大小写
set ic
#甚至是.cxx对应中的头文件,具有联想范围
ctrl+n
ctrl+p
```

###行联想补齐
```
ctrl+x,l
```

###万能补齐
```
filetype plugin on
ctrl+x,o
```

###帮助
```
:h new-omini-complete
```

###调用函数
```
ia xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
ia myname <c-r>%<cr>
```