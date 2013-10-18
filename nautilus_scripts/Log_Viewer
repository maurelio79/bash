#!/bin/bash

# echo -n "`hostname` - `hostname -I`\n\n`uptime`\n\n`uname -a`\n\n`df -h|grep 192`" | zenity --text-info --title "System Information" --width="800" --height="600"
# tail -250 "/var/log/Xorg.0.log" |  zenity --text-info --title "Log Information" --width="1280" --height="1024"

function show_dialog(){
	LOG=`zenity --title="Log Viewer" --text="Choose log to view" --height="250" --list --radiolist --column="Select" --column="Log" \
	FALSE Auth.log \
	FALSE Boot.log \
	FALSE Syslog \
	FALSE Xorg.0.log \
	`
	if [ $? -eq 0 ]; then
		select_log
	fi
}

function select_log(){
	case $LOG in
		Auth.log)
			tail -250 "/var/log/auth.log" |  zenity --text-info --title "$LOG" --width="1280" --height="1024"
		;;
		Boot.log)
			tail -250 "/var/log/boot.log" |  zenity --text-info --title "$LOG" --width="1280" --height="1024"
		;;
		Syslog)
			tail -250 "/var/log/syslog" |  zenity --text-info --title "$LOG" --width="1280" --height="1024"
		;;
		Xorg.0.log)
			tail -250 "/var/log/Xorg.0.log" |  zenity --text-info --title "$LOG" --width="1280" --height="1024"
		;;
		*)
			zenity --notification --text="Selection error!"
			show_dialog
		;;
	esac
}

show_dialog


