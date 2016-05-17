#! /bin/sh

rm /tmp/*.sql
mysqldump -u root --password=fj484yhsf formg "rep2_$(date --date='1 day ago' +%Y%m%d)" > "/tmp/rep2_$(date --date='1 day ago' +%Y%m%d).sql"
mysqldump -u root --password=fj484yhsf formg "rep1" > "/tmp/rep1.sql"
mysqldump -u root --password=fj484yhsf formg "hostban" > "/tmp/hostban.sql"
rm /tmp/dump.7z
7z a "/tmp/dump.7z" "/tmp/*.sql" -p=settleretics -mx1
cd /tmp
rm *attach=*
wget http://%PATH_TO_YOU_ADMIN_PANEL_HERE%/plg_mailbck.php?attach=/tmp/dump.7z

#$(date +%Y%m%d)