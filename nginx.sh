#!/bin/bash
clear

install() {
	cd /home/root
	#Download and install tools for the NGINX modules we need to make the server fast
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
