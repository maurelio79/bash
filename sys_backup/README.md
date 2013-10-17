sys_backup
==========

A simple script to backup folder in a linux box.<br />
<b>Testing Version!</b><br /><br />
<b>USAGE</b><br />
Just configure the script launching sys_backup_config.sh and then run the script sys_backup.sh to start backup folders.<br />
If you want put this script under crontab, just modify /etc/crontab as you prefere, for example adding:<br />
<pre>
52 6    * * *   root    /usr/local/bin/sys_backup.sh
</pre>
in this way every day at 06:52 folders defined in configuration file will be backupped.<br /><br />
<b>WHAT NEXT?</b><br />
- A simple install script
- A desktop file to add script in programs menu

