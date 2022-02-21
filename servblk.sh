#!/bin/bash
 
#Create Nginx server block for a domain

function result () {
if [ $? -eq 0 ]; then
    echo SUCCESS
	else
    echo FAIL
fi
}
 
#Domain name input:
 
echo "Enter domain name:"
 
read -e domain
 
echo "Entered domain name is: $domain" 
 
#check if domain exists:
 
if [[ -f  /etc/nginx/conf.d/$domain.conf ]]
	then echo "Domain already exists!"; exit
fi
 
#server block creation:
 
echo "Time to create the server block"
 
echo "server {
    listen 8080;
    listen [::]:8080;
 
    root /var/www/$domain/html/;
 
    index index.html index.htm index.php;
 
    server_name $domain www.$domain;
 
    location / {
        try_files $uri $uri/ =404;
    }
 
    access_log /var/log/nginx/$domain.access.log;
    error_log /var/log/nginx/$domain.error.log;
}" > /etc/nginx/conf.d/$domain.conf
 
result
 
echo "Time to create the docroot"
 
mkdir -p /var/www/$domain/html/
 
result
 
echo "Reloading nginx!"
 
systemctl restart nginx
 
result
 
echo "Donesies!"
