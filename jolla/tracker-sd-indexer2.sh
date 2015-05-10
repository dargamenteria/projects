#!/bin/bash

DEF_UID=`grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2`
user=`egrep "^[[:alpha:]]+:[[:alpha:]]+:${DEF_UID}" /etc/passwd  | cut -f1 -d ":"`


#add directories to be exclude or include by indexer
toMountFile=/home/$user/.config/tracker/toMount
toExcludeFile=/home/$user/.config/tracker/toExclude


################
#Check mounted and exclude propeties file
toMountFlag=0
toExcludeFlag=0

#if exist and are correct flags = 1
[ -f $toMountFile ]   && . $toMountFile   && toMountFlag=1 
[ -f $toExcludeFile ] && . $toExcludeFile && toExcludeFlag=1 

################
#Check if sdcard is mounted
sdCardFlag=1
sdCardMountPoint=""

grep "^/dev/mmcblk1" /proc/mounts >/dev/null && sdCardFlag=1 




defaults="'&DOWNLOAD', '&MUSIC', '&PICTURES', '&VIDEOS'"


if [ $sdCardFlag -eq 1  ];then
	echo "SD"
	sdCardMountPoint=`df -k | grep "^/dev/mmcblk1" | awk '{print $6}'`

	#Set to true to enable indexing mounted directories for removable devices.
	if [ "$(gsettings get org.freedesktop.Tracker.Miner.Files index-removable-devices)" = "false" ];then
    	echo "gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true"
    	#gsettings set org.freedesktop.Tracker.Miner.Files index-removable-devices true
  	fi

  	#add the toMount array at the end
	if [ $toMountFlag -eq 1 ]; then

    #toMountArray is defined on toMountFile
    	if [ -z "$toMountArray" ]; then
    		echo "gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories \"[${defaults}, '${sdCardMountPoint}']\""
      		#gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "[${defaults} '${sdCardMountPoint}']"
    	else
      	
      		toMountString=""
      		for i in $toMountArray; do
        		toMountString=${toMountString}",'${i}'"
      		done

     		echo "gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories \"[${defaults}, '${sdCardMountPoint}' ${toMountString}]\""
      		#gsettings set org.freedesktop.Tracker.Miner.Files index-recursive-directories "[${defaults}, '${sdCardMountPoint}' ${toMountString}]"
    	fi
	fi
else
	echo "!SD"
fi