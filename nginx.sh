#!/bin/bash
clear

install() {
	cd /home/root
	#Download and install NGINX and additional modules
	sudo apt-get -y install build-essential zlib1g-dev libpcre3 libpcre3-dev libbz2-dev libssl-dev tar unzip
	wget https://github.com/pagespeed/ngx_pagespeed/archive/master.zip
	unzip master.zip
	cd ngx_pagespeed-master
	wget https://dl.google.com/dl/page-speed/psol/1.7.30.1.tar.gz
	tar -xvzf 1.7.30.1.tar.gz
	cd ../
	wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.24.tar.gz
	tar -xvzf v0.24.tar.gz
	wget http://nginx.org/download/nginx-1.7.2.tar.gz
	tar -xvzf nginx-1.7.2.tar.gz
	cd nginx-1.7.2
	./configure \
		--prefix=/usr/share/nginx \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/nginx/nginx.conf \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/lock/nginx.lock \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/access.log \
		--user=www-data \
		--group=www-data \
		--without-mail_pop3_module \
		--without-mail_imap_module \
		--without-mail_smtp_module \
        	--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-http_spdy_module \
		--with-http_gzip_static_module \
		--add-module=$HOME/ngx_pagespeed-master \
		--add-module=$HOME/headers-more-nginx-module-0.24 \
		--with-file-aio \
	make
	sudo make install
	# Autostart NGINX service
	wget https://raw.githubusercontent.com/travoltron/server-scripts/master/nginx-restart.sh
	sudo mv nginx-restart.sh /etc/init.d/nginx
	sudo chmod +x /et/init.d/nginx
	sudo service nginx start
	sudo apt-get install chkconfig
	sudo chkconfig --add nginx
	sudo chkconfig nginx on
	# Install PHP5-FPM
	sudo apt-get install php5-fpm php5-cli php5-mcrypt
	mkdir /var/www
	mkdir /var/www/development /var/www/staging/ /var/www/production
	cd /etc/nginx/sites-available
	rm default
	wget https://raw.githubusercontent.com/travoltron/server-scripts/master/laravel-nginx-default.txt
	cp laravel-nginx-default.txt default
	rm laravel-nginx-default.txt
	# Secure PHP
	sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
	sed -i -e 's/127.0.0.1:9000/\/var\/run\/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
	# Restart
	service php5-fpm restart
	service nginx restart
	# Install Composer
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
	# Git 
	sudo apt-get install git
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
