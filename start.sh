#!/bin/bash
echo " " > /tmp/filediff.log
echo " " > /tmp/filediffA.log
echo " " > /tmp/filediffB.log
echo "Start:`date +%F-%T`" >> /tmp/filediff.log
echo "Start:`date +%F-%T`" >> /tmp/filediffA.log
echo "Start:`date +%F-%T`" >> /tmp/filediffB.log
backup_day="1 days ago"
month=`date -d "$backup_day" +"%Y""%m"`
echo "month=$month" >> /tmp/filediff.log
yesterday=`date -d'1  days ago' +%Y-%m-%d`
today=`date +%Y-%m-%d`
Dir_Size1=$(ls -ltrh| grep "$today" | awk '{print $NF}' | xargs du -ch | grep total | awk '{print $1}')
Dir_Size2=$(ls -ltrh| grep "$yesterday" | awk '{print $NF}' | xargs du -ch | grep total | awk '{print $1}')

for i in `ls -l /mnt/log_backup/$month/ | awk {'print $9'}`
        do
        echo $i
        Dir_Size1=$(ls -ltrh| grep "$today" | awk '{print $NF}' | xargs du -ch | grep total | awk '{print $1}')
        echo "/mnt/log_backup/$month/$i && $Dir_Size1" >> /tmp/filediffA.log
        done
diff -a -b -B -u /tmp/filediffA.log /tmp/filediffB.log >> /tmp/filediff.log
