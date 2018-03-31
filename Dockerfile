FROM ubuntu:xenial

MAINTAINER Martins Balodis

ENV DEBCONF_NONINTERACTIVE_SEEN="true" TIMEZONE="UTC" DISPLAY=":1"


# database configuration
ENV DB_HOST="localhost" DB_DATABASE="ebesuchertest" DB_USERNAME="root" DB_PASSWORD="root" DISABLE_NOTIFIER="true"

# configuration and startup scripts
ADD fs /


# install all dependencies
RUN apt-get update && \
apt-get install -qqy software-properties-common curl sudo locales && \
locale-gen en_US.UTF-8 && locale-gen de_DE.UTF-8 && \
locale-gen ru_RU.UTF-8 && locale-gen es_ES.UTF-8 && \
locale-gen fr_FR.UTF-8

ENV LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8"
RUN add-apt-repository ppa:ondrej/php && \
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
apt-get update && \
/bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DB_PASSWORD'" && \
/bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DB_PASSWORD'" && \
DEBIAN_FRONTEND=noninteractive apt-get -y install  wget \
nano mysql-client \
php7.1-mcrypt php-apcu php-apcu-bc php7.1-cli php7.1-mysql php7.1-intl \
php7.1-fpm php7.1-mbstring php7.1-curl php7.1-bcmath php-xdebug php-imagick \
php7.1-zip php7.1-bz2 php7.1-mbstring php7.1-xsl php7.1-gd php7.1-sockets \
php7.1-ldap php7.1-gettext php7.1-mysql php7.1-simplexml php7.1-soap php7.1-xml \
git \
memcached \
build-essential python-pip tar unzip  \
aha \
nodejs psmisc php7.1-gd php7.1-memcache lsof iputils-ping php7.1-mongodb php7.1-zip \
openjdk-8-jre-headless xfonts-100dpi xfonts-75dpi \
xfonts-scalable xfonts-cyrillic tightvncserver supervisor expect \
gconf2 \
mysql-server mysql-client \
mongodb \
net-tools \
apt-transport-https \
ca-certificates \
lxc \
iptables \
bridge-utils \
python-software-properties \
cgroupfs-mount \
psmisc \
curl \
git \
subversion \
unzip \
wget \
aha \
zip \
mysql-server \
apt-transport-https zlib1g-dev libicu-dev g++ \
zip && \
pip install --upgrade awscli && \
sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
mkdir /var/run/mysqld && \
chown mysql:mysql /var/run/mysqld && \
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
DEBIAN_FRONTEND=noninteractive apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' && \
apt-get update -qq && \
apt-get install -qqy docker-engine && \
apt-get remove --purge -y software-properties-common python-software-properties expect && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
phpenmod mcrypt &&  \
npm install -g bower && \
npm install -g gulp && \
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer && \
rm -rf /var/lib/apt/lists/* && \
mkdir /root/.ssh && \
touch /root/.ssh/known_hosts && \
ssh-keyscan github.com >> /root/.ssh/known_hosts




# do some container configuration
RUN /usr/local/bin/configure_container.sh

