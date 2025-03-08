locals {
  wordpress-user-data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum upgrade -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo yum install unzip -y
    unzip awscliv2.zip
    sudo ./aws/install
    sudo amazon-linux-extras enable php8.2
    sudo yum clean metadata
    sudo yum install httpd php php-mysqlnd -y
    cd /var/www/html
    touch indextest.html
    echo "Hello World - this is a WordPress test file" > indextest.html
    sudo yum install wget -y
    wget https://wordpress.org/wordpress-6.1.1.tar.gz
    tar -xzf wordpress-6.1.1.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress
    rm -rf wordpress-6.1.1.tar.gz
    chmod -R 755 wp-content
    chown -R apache:apache wp-content
    cd /var/www/html && mv wp-config-sample.php wp-config.php
    sed -i "s@define( 'DB_NAME', 'database_name_here' )@define( 'DB_NAME', '${var.db-name}' )@g" /var/www/html/wp-config.php
    sed -i "s@define( 'DB_USER', 'username_here' )@define( 'DB_USER', '${var.db-username}' )@g" /var/www/html/wp-config.php
    sed -i "s@define( 'DB_PASSWORD', 'password_here' )@define( 'DB_PASSWORD', '${var.db-password}' )@g" /var/www/html/wp-config.php
    sed -i "s@define( 'DB_HOST', 'localhost' )@define( 'DB_HOST', '${element(split(":", aws_db_instance.wordpress-db-instance.endpoint), 0)}')@g" /var/www/html/wp-config.php
    sudo chkconfig httpd on
    sudo service httpd start
    sudo setenforce 0
    sudo hostnamectl set-hostname webserver
  EOF
}
