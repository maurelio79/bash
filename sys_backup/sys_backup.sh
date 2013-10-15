#!/bin/bash
 
####################################################################
#
# Script to weekly backup important system folder.
#
# Author: Mauro Lomartire
# Script Name: sys_backup
# Script Version: 1.0 BETA
# License: GPLv2 http://www.gnu.org/licenses/licenses.en.html
#
####################################################################

#############################################
# TODO
# - Check folder if exist
# - Check correct execution of function
# - Check id $DAYS is a number
# - Verify ctime and mtime
#############################################
 
# Define configuration file
CONFIG="/etc/sys_backup.conf"
 
        if [ ! -f $CONFIG ]; then
                echo "Configuration file not found"
                exit 1
        fi
 
# Define variables needed for script
        SOURCE=`cat $CONFIG | grep "Directory to backup" | cut -d: -f2`
        DESTDIR=`cat $CONFIG | grep "Destination folder" | cut -d: -f2`
        DAYS=`cat $CONFIG | grep "Days" | cut -d: -f2`
        LOG=`cat $CONFIG | grep "Log file" | cut -d: -f2`
        # ARCHIVE=`cat $CONFIG | grep "Archive .bak" | cut -d: -f2`
 
        if [[ ! -d $SOURCE || ! -d $DESTDIR || ! $DAYS || ! $LOG ]]; then
                echo "Some element in configuration file are not present."
                exit 1
        fi
 
# Declare array with directory to backup
declare -a dirtobak=($SOURCE);
 
# Remove backup older than 5 days
clean() {
        find $DESTDIR/ -type f -mtime +5 | xargs rm -f -- 2>> "/var/log/$LOG"
}
 
# Move all backupped diretctory in a single archive to keep for 5 days
tarbak(){
        ls $DESTDIR/*.tar 2>> "/var/log/$LOG"
        if [ $? -eq 0 ]; then
	        tar cf $DESTDIR/archive`date +%d%m%y`.tar.bz2 $DESTDIR/*.tar 2>> "/var/log/$LOG"
			if [ $? -gt 0 ]; then
				echo "Some errors occuring during tar of old backup, see above" >> "/var/log/$LOG"
				echo "I will not remove old backup" >> "/var/log/$LOG"
				return 1
				exit 1
			fi
        rm -f $DESTDIR/*.tar 2>> "/var/log/$LOG"
        fi
 
############################################################
#       for k in `ls $DESTDIR/*.tar`; do
#               NEWNAME=$k.bak
#               mv $k $NEWNAME
#                       if [ $? -gt 0 ]; then
#                       echo "Error during renaming of $k" >> $LOG
#                       fi
#       done
#       fi
#
#       if [ $ARCHIVE == "yes" ]; then
#       ls $DESTDIR/*.bak 2>> $LOG
#               if [ $? -eq 0 ]; then
#               tar cf $DESTDIR/archive`date +%d%m%y`.tar $DESTDIR/*.bak 2>> $LOG
#                       if [ $? -gt 0 ]; then
#                       echo "Error creating archive.tar" >> $LOG
#                       fi
#               fi
####################################################################
 
}
 
# Start backup of directory defined in configuration file
backup(){
        for i in ${dirtobak[@]}; do
        tar cf $DESTDIR/`basename $i`-`date +%H%M%S`.tar $i  2>> "/var/log/$LOG"
                        if [ $? -gt 0 ]; then
                        echo "Error during tar of $i" >> "/var/log/$LOG"
						return 1
                        fi
 
        done
}
 
echo "----------------------------------------------------------" >> "/var/log/$LOG"
echo `date` >> "/var/log/$LOG"
echo "----------------------------------------------------------" >> "/var/log/$LOG"
 
# Launch all function
clean
 
if ! tarbak; then
	echo "Abnormal exiting. See error above" >> "/var/log/$LOG"
	exit 1
fi
 

if backup; then
	echo "All directory correctly backupped"  >> "/var/log/$LOG"
else
	echo "Abnormal exiting. See error above" >> "/var/log/$LOG"
	exit 1
fi


