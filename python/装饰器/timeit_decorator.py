#coding:utf-8

import time

def timeit(func):
    def wrapper():
        start = time.clock()
        func()
        end =time.clock()
        print 'used:', end - start
    return wrapper

# 语法糖
# 与另外写foo = timeit(foo)完全等价
# 更有装饰器的感觉

@timeit
def foo():
    print 'in foo()'

foo()

# [python对装饰器的内置支持查看](http://django-china.cn/topic/148/)