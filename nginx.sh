#!/bin/bash
clear

install() {
	cd $home
	# Update the build
	sudo apt-get update
	#Download and install NGINX and additional modules
	sudo apt-get -y install build-essential zlib1g-dev libpcre3 libpcre3-dev libbz2-dev libssl-dev tar unzip
	sudo add-apt-repository ppa:nginx/development
	sudo apt-get update
	sudo apt-get install nginx
	# Install PHP5-FPM
	sudo apt-get install php5-fpm php5-cli php5-mcrypt
	sudo mkdir -p {/var/www/development,/var/www/staging,/var/www/production}
	sudo cd /etc/nginx/sites-available
	sudo rm default
	sudo wget https://raw.githubusercontent.com/travoltron/server-scripts/master/laravel-nginx-default.txt
	sudo cp laravel-nginx-default.txt default
	sudo rm laravel-nginx-default.txt
	# Secure PHP
	sudo sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
	sudo sed -i -e 's/127.0.0.1:9000/\/var\/run\/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
	# Restart
	sudo service php5-fpm restart
	sudo service nginx restart
	# Install Composer
	sudo curl -sS https://getcomposer.org/installer | php
	sudo mv composer.phar /usr/local/bin/composer
	# Git 
	sudo apt-get install git

	clear

	read -p "Press [Enter] key to configure the Git credentials..."
	gitsetup
}

gitsetup() {
	echo -e "Enter your email address for your Github account, followed by [ENTER]:"
	read email
	ssh-keygen -t rsa -C "$email"
	echo -e "Copy and paste the public RSA key into Github."

	clear 
	read -p "Press [Enter] key to configure NGINX..."
	nginxsetup
}
nginxsetup() {
	sudo nano /etc/nginx/nginx.conf
	
}

echo -e "The following software will be installed with this script:\n\tNGINX -v 1.6.0\n\tPHP5-FPM -v 5.5\n\tGit"
while true; do
	read -p 'Would you like to continue? [y/N] ' answer
	case $answer in
		[Yy]* ) install; break;;
		[Nn]* ) echo ""; break;;
		* ) echo "Incorrect choice.";;
	esac
done
