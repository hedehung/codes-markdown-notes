pid=`ps -ef | grep -v grep | grep -v "proc_exist.sh" | grep $1 | sed -n  '1P' | awk '{print $2}'`  
if [ -z $pid ] ; then  
    echo "no this process"  
else  
    echo $pid  
fi
