#! /bin/sh

#update geoip 
cd /var/www/%PATH_TO_ADMIN_PANEL%/geoip/
rm -f GeoLiteCity.dat.gz
wget -P/var/www/%PATH_TO_ADMIN_PANEL%/geoip/ -a /var/www/%PATH_TO_ADMIN_PANEL%/geoip/updatelogs/wget-geoip-update-log.txt http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz  && rm -f GeoLiteCity.dat 
gzip -d /var/www/%PATH_TO_ADMIN_PANEL%/geoip/GeoLiteCity.dat.gz
date >> /var/www/%PATH_TO_ADMIN_PANEL%/geoip/updatelogs/update-geoip-log.txt

