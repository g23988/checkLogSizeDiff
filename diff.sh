#!/bin/sh

# adjust value here
work_space=/mnt/log_backup
today=`date +%Y%m%d`
yesterday=`date -d '1 day ago' '+%Y%m%d'`


#input ==> folderPath,date
#output ==> sum size
dailylogSum()
{
	if [ -z "$(ls -A $1)" ]; then
		echo "0K"
	else
		list=$(find $1/* -type f | grep $2)
		if [ -z "$list" ]; then
			echo "0K"
		else
			echo $(echo $list | xargs du -h --max-depth=1 | grep total | awk '{print $1}')
		fi
	fi
}

#input ==> 20181011
#output ==> 201810
getMonth()
{
	echo $(echo $1 | cut -c1-6 )
}

#input ==> targetFolder,date,targetFilePath
output()
{
	#delete output file
	rm -f $3
	#loop all subfolder
	for subfolder in `find $1/* -maxdepth 1 -type d`
        	do
		size=$(dailylogSum $subfolder $2)
		echo "$subfolder && $size" >> $3
        	done
}


############# Main #############
#today part
targetFolder=$work_space/$(getMonth $today)
output $targetFolder $today /tmp/filediffA.log
#yesterday part
targetFolder=$work_space/$(getMonth $yesterday)
output $targetFolder $yesterday /tmp/filediffB.log
#compare
diff -a -b -B -u /tmp/filediffA.log /tmp/filediffB.log

