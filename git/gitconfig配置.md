[user]
  name = boostbob
  email = 1982wb@gmail.com
[color]
  ui = true
[branch "master"]
  remote = origin
  merge = refs/heads/master
[alias]
  ci = commit -a -v  
  st = status
  throw = reset --hard HEAD 
  throwh = reset --hard HEAD^
  ch = log --pretty=format:'%h-%an, %ar : %s' -10 
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --
