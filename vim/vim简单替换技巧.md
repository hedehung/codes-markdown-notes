###vim替换技巧
	:s/vivian/sky/ 替换当前行第一个vivian为sky
	:s/vivian/sky/g 替换当前行所有vivian为sky
	:n,$s/vivian/sky/ 替换第n行开始到最后一行中每一行的第一个vivian为sky
	:n,$s/vivian/sky/g 替换第n行开始到最后一行中每一行所有vivian为sky,n为数字，若n为.，表示从当前行开始到最后一行
	:%s/vivian/sky/（等同于:g/vivian/s//sky/）替换每一行的第一个vivian为sky
	:%s/vivian/sky/g（等同于:g/vivian/s//sky/g）替换每一行中所有vivian为sky
