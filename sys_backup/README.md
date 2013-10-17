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
In this way every day at 06:52 folders defined in configuration file will be backupped.<br /><br />
<b>sys_backup.conf file example</b><br />
If you want you can just create manually sys_backup.conf and put it in /etc/.<br />
<b>Attention!</b><br />
It must to be in the same format of the example below!
<pre>
Directory to backup :/etc /var/log
Destination folder :/home/maurelio/Pubblici
Days :5
Log file :sys_backup.log
</pre>
In this way you don't need sys_backup_config.sh. You can just launch sys_backup.sh and backup is done.<br /><br />
<b>WHAT NEXT?</b><br />
- A simple install script
- A desktop file to add script in programs menu

