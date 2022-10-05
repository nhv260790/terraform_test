resource "aws_instance" "app_server" {
  ami           = "ami-0f62d9254ca98e1aa"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.open_80.id]
  
  user_data = <<EOF
				#!/bin/bash
				yum update -y
				amazon-linux-extras install nginx1 -y
				systemctl start nginx.service
				systemctl enable nginx.service
				amazon-linux-extras install php8.0 -y
				systemctl start php-fpm.service
				systemctl enable php-fpm.service
				rm /usr/share/nginx/html/index.html -y
				echo "<?php phpinfo();?>" > /usr/share/nginx/html/index.php
				systemctl restart php-fpm.service
				systemctl restart nginx.service
				EOF

  tags = {
    Name = "EC2ForNginx"
  }
}