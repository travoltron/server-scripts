#!/bin/bash
clear

install() {
	cd $home
	# Update the build
	sudo apt-get update
	# Download and install MySQL
	sudo apt-get -y install build-essential zlib1g-dev libpcre3 libpcre3-dev libbz2-dev libssl-dev tar unzip
	sudo apt-get -y install mysql-server
	# Install MySQLTuner
	sudo apt-get -y install mysqltuner
	# Install MongoDB
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
	sudo apt-get update
	sudo apt-get -y install mongodb-org
	sudo service mongod restart
	# Install Redis Server
	sudo apt-get -y install python-software-properties
	sudo add-apt-repository -y ppa:rwky/redis
	sudo apt-get -y update
	sudo apt-get -y install redis-server
	# Install Sphinx Search
	sudo add-apt-repository ppa:builds/sphinxsearch-stable
	sudo apt-get update
	sudo apt-get install sphinxsearch
	sudo service sphinxsearch restart
	clear
	read -p 'Databases are all installed. Make sure to update permissions for access.'
	exit 1
}

echo -e "The following software will be installed with this script:\n\tMySQL -v 5.6\n\tMongoDB -v 2.4.10\n\tRedis -v 2.8.12\n\tSphinx Search -v 2.1.8"
while true; do
	read -p 'Would you like to continue? [y/N] ' answer
	case $answer in
		[Yy]* ) install; break;;
		[Nn]* ) echo ""; break;;
		* ) echo "Incorrect choice.";;
	esac
done
