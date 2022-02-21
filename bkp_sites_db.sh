#!/bin/bash
 
#Create backup of all sites and databases on the server
 
#Website backup:
 
site=$(ls -l /var/www/ | egrep -v "cgi-bin|html|total" | awk '{print $9}')
 
day=$(date +%Y%m%d)
 
for i in $site; do tar -zcf /var/bkp/$i.$day.tar.gz /var/www/$i; done
 
if [ $? -eq 0 ]; then
    echo "Websites Backup success!"
        else
    echo "Websites Backup fail!"
fi
 
#Now for the MySQL part:
 
#MySQL main user details:
echo "Please insert MySQL user:"
read -e mysql_user
 
echo "Please insert MySQL password:"
read -s mysql_pass
 
file=/var/bkp/list.txt
 
mysql --user=$mysql_user --password=$mysql_pass -e "SHOW DATABASES" > $file
 
for i in $(grep -v "Database" $file ); do mysqldump --user=$mysql_user --password=$mysql_pass $i > /var/bkp/$i.$day.sql; done
 
if [ $? -eq 0 ]; then
    echo "Databases Backup success!"
        else
    echo "Databases Backup fail!"
fi
