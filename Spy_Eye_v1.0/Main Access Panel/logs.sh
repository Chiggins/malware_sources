#! /bin/sh

cd /var/www/%PATH_TO_YOUR_ADMIN_PANEL%
7z a "logs/$(date +%Y%m%d).7z" *.log
rm *.log
touch active.log
touch bots.log
touch debug.log
touch error.log
touch php_error.log
touch tasks.log
chmod 666 *.log