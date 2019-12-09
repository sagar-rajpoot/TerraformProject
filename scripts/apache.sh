#!/bin/bash
#Installing apache
yum install httpd -y

systemctl start httpd
systemctl enable httpd

#Defualt Apache Directory for html file -
#/var/www/html/

echo "<h1> MY First Page at AWS </h1>" >> /var/www/html/index.html
