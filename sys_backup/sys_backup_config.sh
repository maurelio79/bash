#!/bin/bash

####################################################################
#
# GUI Script to configure sys_backup script.
#
# Author: Mauro Lomartire
# Script Name: sys_backup_config
# Script Version: 1.0 BETA
# License: GPLv2 http://www.gnu.org/licenses/licenses.en.html
#
####################################################################         
																			 
####################################################################         
#																			 
# DESCRIPTION
# This script help you to create the configuration file
# for the sys_backup script.
#
####################################################################


#############################################
# TODO
# - Check folder if exist
# - Check correct execution of function
# - Check id $DAYS is a number
# - Verify ctime and mtime
#############################################


##########################################
#
# Define variables and function
#
##########################################

	CONFIG="/etc/sys_backup.conf"
	FOLDER_LOG="/var/log"

# If config file already exist, we delete it.
	function del_files(){
		if [ -f $CONFIG ]; then
			rm -f $CONFIG
		fi


# If log file already exist, we delete it.
		if [ -f $FOLDER_LOG/$LOG ]; then
			rm -f $FOLDER_LOG/$LOG
		fi
	}

# Write down the configuration file
	function create_conf(){
		echo "Directory to backup :$SOURCE" >> $CONFIG
		echo "Destination folder :$DESTDIR" >> $CONFIG
		echo "Days :$DAYS" >> $CONFIG
		echo "Log file :$LOG" >> $CONFIG
	}


# Write in log file.
	function write_log(){
		# echo "Configuration file correctly created as $CONFIG"
		# echo "Now you can run sys_backup script located in /usr/local/bin"
		echo "----------------------------------------------------------" >> $FOLDER_LOG/$LOG
		echo `date` >> $FOLDER_LOG/$LOG
		echo "Configuration file created." >> $FOLDER_LOG/$LOG
		echo "----------------------------------------------------------" >> $FOLDER_LOG/$LOG
	}


##########################################
#
# Starting the script
#
##########################################

# Check if we are in a window system or not; if not execute the text version
	if [ ! $DISPLAY ]; then
# Verify if user is root, if not he can not configure script.
		user=`whoami`
		if [ $user != "root" ]; then
			echo "You need to be root in order to configure sys_backup script"
			exit 1
		fi

		echo "Enter source folders to backup separeted by space and press [enter]:"
		read SOURCE
			while [[ ! $SOURCE || ! -d $SOURCE ]]
			do
				echo "Error! Is this a real folder? Enter source folders to backup separeted by space and press [enter]:"
				read SOURCE
			done

		echo "Enter destination folder of backup and press [enter]:"
		read DESTDIR
			while [[ ! $DESTDIR || ! -d $DEST ]]
			do
				echo "Error! Is this a real folder? Enter destination folder of backup and press [enter]:"
				read DESTDIR
			done

		echo "Enter number of days to keep backup and press [enter]:"
		read DAYS
			while [ ! $DAYS ]
			do
				echo "Enter number of days to keep backup and press [enter]:"
				read DAYS
			done

		echo "Enter log file name (it will create in /var/log/) and press [enter]:"
		read LOG
			while [ ! $LOG ]
			do
				echo "Enter position and log file name and press [enter]:"
				read LOG
			done

		del_files

		create_conf

		write_log

		exit 0
	fi

# If we are here it means that we are in window X system, so zenity version of script will be used.
# Verify if user is root, if not he can not configure script.
		user=`whoami`
		if [ $user != "root" ]; then
			 zenity --error --title="You are not root" --text="You need to be root in order to configure sys_backup script"
			exit 1
		fi

# Display zenity window
	PARAMETERS=`zenity --title="System Backup Configurator" --forms --text="All files/folders need to be in absolute path format and without / at the end;\n source folder can be more than 1 but they need to be sperated by space.\n" --add-entry="Source folders" --add-entry="Destination folder" --add-entry="Days to keep old backup" --add-entry="Log File"  --separator=:`


# Extract variables needed in config file
	SOURCE=`echo $PARAMETERS | cut -d: -f1 `
	DESTDIR=`echo $PARAMETERS | cut  -d: -f2`
	DAYS=`echo $PARAMETERS | cut  -d: -f3`
	LOG=`echo $PARAMETERS | cut  -d: -f4`


# If all variables are not set, display error
	if [[ ! $SOURCE || ! $DESTDIR || ! $DAYS || ! $LOG || ! $CONFIG ]]; then
		    # echo "Please fill all fields!"
			zenity --error --title="Config dialog Error" --text="Please fill all fields! They are necessary to correctly run the script."
		    exit 1
	fi

	del_files

	create_conf

	write_log


	zenity --info --title="Well Done!" --text="Configuration file correctly created as $CONFIG\nNow you can run sys_backup script located in /usr/local/bin"

##########################################
#
# End of script
#
##########################################

