#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello TransUnion from $(hostname -f)" > /var/www/html/index.html
yum install mysql -y