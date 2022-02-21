#!/bin/bash
 
#Insert users from a csv file to the MySQL users table used by Pure-FTPD
 
#MySQL main user details:
echo "Please insert MySQL user:"
read -e mysql_user
 
echo "Please insert MySQL password:"
read -s mysql_pass
 
#Create sample csv file - can be commented out and a real csv file can be used
 
tail -n10 /etc/passwd | awk -F ":" '{print $1","$3","$4","$6","}' > pfd.csv
 
#Inserting a random string+number as a password to the file - please use for login details:
 
cat pfd.csv | while read line; do echo -e $(echo "$line$(shuf -n1 /usr/share/dict/words)$RANDOM"); done > pfd1.csv
 
#Insert users from csv to the MySQL table
 
while IFS="," read -r f1 f2 f3 f4 f5; 
do mysql --user=$mysql_user --password=$mysql_pass pureftpd <<EOF
INSERT INTO users (User, Password, Uid, Gid, Dir, QuotaSize, Status, ULBandwidth, DLBandwidth, Date, LastModif)
VALUES ("$f1", md5("$f5"), "$f2", "$f3", "$f4", "20", "2", "10", "10", now(), ''); 
EOF
done < pfd1.csv
 
if [ $? -eq 0 ]; then
    echo SUCCESS
        else
    echo FAIL
fi
