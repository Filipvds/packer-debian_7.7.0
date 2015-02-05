#!/bin/bash -eux

# Update aptitude library
apt-get update >/dev/null 2>&1

# Install Apache
echo "Installing Apache and setting it up."
# Install apache2 
apt-get install -y apache2 >/dev/null 2>&1
# Enable mod_rewrite
a2enmod rewrite

 # Install mysql
echo "Installing MySQL."

export MYSQLPASS=root
export DEBIAN_FRONTEND=noninteractive

# Set root password root
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQLPASS"
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQLPASS"

apt-get install -y mysql-server >/dev/null 2>&1
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
/etc/init.d/mysql restart
mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%'; UPDATE user SET Password=PASSWORD('$MYSQLPASS') WHERE User='root'; FLUSH PRIVILEGES;"

echo "Installing handy packages"
apt-get install -y curl git-core ftp unzip imagemagick vim colordiff gettext >/dev/null 2>&1

echo "Installing PHP Modules"
apt-get install -y php5 php5-cli php5-common php5-dev php5-imagick php5-imap php5-gd libapache2-mod-php5 php5-mysql php5-curl php5-intl php5-xdebug phpunit >/dev/null 2>&1

# Restart Apache
echo "Restarting Apache"
/etc/init.d/apache2 restart

# Install composer
echo "Installing composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Installing Ruby
echo "Installing ruby "
apt-get install -y ruby-dev libsqlite3-dev >/dev/null 2>&1

echo "Installing node.js"
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs build-essential >/dev/null 2>&1

echo "Installing SASS, Compass and Grunt"
gem install sass
gem install compass
gem install grunt
gem install bower

echo "Installing Mailcatcher"
gem install mailcatcher