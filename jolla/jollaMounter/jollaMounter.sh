#!/bin/bash

usage() { echo "Usage: $0 [-a ] [-r ]" 1>&2; exit 1;}

########
#vars
userName=`whoami`
deviceName=`simple-mtpfs -l | grep -in jolla | awk '{print $2}'`

#if its unpluging theres no device so... deviceName=JollaSailfish
if [ -z $deviceName ]; then
	deviceName="JollaSailfish"
fi

mountPath="/home/${userName}/Desktop/${deviceName}"
desktopPath="/home/${userName}/Desktop/${deviceName}"

#now its not used becuse mountPath is no equal at desktopPath

########
#chech arguments

if [ $# -ne 1 ]
then
	usage
	exit 1
fi

while getopts ":ar" o; do
	case "${o}" in
	a)
		echo "simple-mtpfs ${mountPath}"
		mkdir -p ${mountPath}
		simple-mtpfs ${deviceName} ${mountPath}
		#ln -s ${desktopPath} ${mountPath}
	;;
	r)
		echo "fusermount -u ${mountPath}"
		fusermount -u ${mountPath}
		#rm ${desktopPath}
	;;
	*)
		usage
	;;
	esac
done
