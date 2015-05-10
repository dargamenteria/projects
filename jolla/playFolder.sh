#!/bin/bash

usage() { echo "Usage: $0 [-s <0|1>] [-f ]" 1>&2; exit 1;}

########
#defaults
playFolder="/home/nemo/remote/licaon"
shuf=1

########
#chech arguments

while getopts ":s:f:" o; do
	case "${o}" in
	s)
		shuf=${OPTARG}
		((shuf == 0 || shuf == 1 )) || usage
	;;
	f)
		playFolder=${OPTARG}
	;;
	*)
		usage
	;;
	esac
done

if [ ! -d "${playFolder}" ]; then
	usage
fi

echo "Playing folder: ${playFolder}"

if [ ${shuf} -eq "0" ]; then

	find ${playFolder} -type f -name "*.mp3" -or -name "*.ogg" -or -name "*.ogm" -or -name "*.fla" |while read line;do echo Playing "$line"; gst-launch-0.10 playbin uri=file://"$line" > /dev/null; done

else
	find ${playFolder} -type f -name "*.mp3" -or -name "*.ogg" -or -name "*.ogm" -or -name "*.fla" | shuf |while read line;do echo Playing "$line"; gst-launch-0.10 playbin uri=file://"$line" > /dev/null; done
fi
