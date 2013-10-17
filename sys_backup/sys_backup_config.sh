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
# - Check folder if exist -> partial done
# - Check correct execution of function -> partial done
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

# Verify if user is root, if not he can not configure script.
	function check_user(){
		user=`whoami`
		if [ $user != "root" ]; then
			 zenity --error --title="You are not root" --text="You need to be root in order to configure sys_backup script"
			exit 1
		fi
	}

# Display zenity menu
	function show_zenity_menu(){
		PARAMETERS=`zenity --title="System Backup Configurator" --forms --text="\tAll files/folders need to be in absolute path format and without / at the end.\n\tSource folder can be more than 1 but they need to be sperated by space.\n\tFor log file just write the name you want, it will be create in /var/log/.\n\n" --width="480" --add-entry="Source folders" --add-entry="Destination folder" --add-entry="Days to keep old backup" --add-entry="Log File"  --separator=:`
	if [ $? -eq 0 ]; then
		check_zenity_menu
	else
		echo "Exiting"
		exit 1
	fi
	}

# Check if configuration file will create correctly
	function check_zenity_menu(){
		SOURCES=`echo $PARAMETERS | cut -d: -f1 `
		DESTDIR=`echo $PARAMETERS | cut  -d: -f2`
		DAYS=`echo $PARAMETERS | cut  -d: -f3`
		LOG=`echo $PARAMETERS | cut  -d: -f4`

# If all variables are not set, display error
	if [[ ! $SOURCES || ! -d $DESTDIR || ! $DAYS || ! $LOG || ! $CONFIG ]]; then
			zenity --error --title="Config dialog Error" --text="Please fill correctly all fields! They are necessary to correctly run the script."
			show_zenity_menu
	fi
	
	declare -a SOURCE=($SOURCES);
	
	for i in ${SOURCE[@]}; do
		if [ ! -d $i ]; then
			zenity --error --title="Config dialog Error" --text="$i is not a directory, please verify."
			show_zenity_menu
			break
		fi	
	done
	}

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
		echo "Directory to backup :$SOURCES" >> $CONFIG
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
		check_user

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
				echo "Enter log file name and press [enter]:"
				read LOG
			done

		del_files

		if create_conf; then
			write_log
			echo "Configuration file correctly created as $CONFIG\nNow you can run sys_backup script located in /usr/local/bin"	
			exit 0
		else
			echo "Errors occur during creation of configuration file."
			exit 1
		fi
	fi

# If we are here it means that we are in window X system, so zenity version of script will be used.

# Verify if user is root, if not he can not configure script.
	check_user

# Display zenity window
	show_zenity_menu

# Delete old files
	del_files

# Create configuration file
	if create_conf; then
# Write into log
		write_log
		zenity --info --title="Well Done!" --text="Configuration file correctly created as $CONFIG\nNow you can run sys_backup script located in /usr/local/bin"
		exit 0
	else
		zenity --error --title="Config dialog Error" --text="Errors occur during creation of configuration file."
		exit 1
	fi	


##########################################
#
# End of script
#
##########################################

