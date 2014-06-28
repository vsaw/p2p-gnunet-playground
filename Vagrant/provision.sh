#! /bin/bash

# Fail on error
set -e

if [[ $1 != "--no-apt" ]]; then
	sudo apt-get update --yes
	sudo apt-get upgrade --yes
fi

# Check for the two dependancies and add them to the list of sources if they are
# not there yet.
if [[ -z $(grep "deb http://ftp.de.debian.org/debian/ unstable main" /etc/apt/sources.list) ]]; then
	echo "Adding unstable to apt sources"
	echo "deb http://ftp.de.debian.org/debian/ unstable main" | sudo tee -a /etc/apt/sources.list
fi
if [[ -z $(grep "deb http://ftp.de.debian.org/debian/ testing main" /etc/apt/sources.list) ]]; then
	echo "Adding testing to apt sources"
	echo "deb http://ftp.de.debian.org/debian/ testing main" | sudo tee -a /etc/apt/sources.list
fi

if [[ -f /etc/apt/preferences ]]; then
	echo "WARNING: APT preferences already set. Check if they are correct"
else
	echo "Creating new APT preferences"
	pref="
Package: *
Pin: release a=stable
Pin-Priority: 700

Package: *
Pin: release a=testing
Pin-Priority: 650

Package: *
Pin: release a=unstable
Pin-Priority: 600"
	sudo touch /etc/apt/preferences
	echo "$pref" | sudo tee -a /etc/apt/preferences
fi

if [[ $1 != "--no-apt" ]]; then
	sudo apt-get update --yes
	# sudo apt-get upgrade --yes

	if ! which svn >/dev/null; then
		# First som utils we will need later on
		sudo apt-get install --yes adduser
		sudo apt-get install --yes subversion
	fi

	if ! which automake >/dev/null; then
		# Install automake to be able to compile gnunet-mqtt
		sudo apt-get install --yes automake
	else
		echo 'skipping automake ...'
	fi

	if ! which gnunet-arm >/dev/null;
	then
		# Now install the dependancies
		sudo apt-get install --yes gcc
		sudo apt-get install --yes make
		sudo apt-get install --yes python-zbar
		sudo apt-get install --yes libltdl-dev
		sudo apt-get install --yes libsqlite3-dev
		sudo apt-get install --yes libunistring-dev
		sudo apt-get install --yes libopus-dev
		sudo apt-get install --yes libpulse-dev
		sudo apt-get install --yes openssl
		sudo apt-get install --yes libglpk-dev
		sudo apt-get install --yes texlive
		sudo apt-get install --yes libidn11-dev
		sudo apt-get install --yes libmysqlclient-dev
		sudo apt-get install --yes libpq-dev
		sudo apt-get install --yes libarchive-dev
		sudo apt-get install --yes libbz2-dev
		sudo apt-get install --yes libexiv2-dev
		sudo apt-get install --yes libflac-dev
		sudo apt-get install --yes libgif-dev
		sudo apt-get install --yes libglib2.0-dev
		sudo apt-get install --yes libgtk-3-dev
		sudo apt-get install --yes libmagic-dev
		sudo apt-get install --yes libjpeg8-dev
		sudo apt-get install --yes libmpeg2-4-dev
		sudo apt-get install --yes libmp4v2-dev
		sudo apt-get install --yes librpm-dev
		sudo apt-get install --yes libsmf-dev
		sudo apt-get install --yes libtidy-dev
		sudo apt-get install --yes libtiff5-dev
		sudo apt-get install --yes libvorbis-dev
		sudo apt-get install --yes libogg-dev
		sudo apt-get install --yes zlib1g-dev
		sudo apt-get install --yes g++
		sudo apt-get install --yes gettext
		sudo apt-get install --yes libgsf-1-dev
		sudo apt-get install --yes libunbound-dev
		sudo apt-get install --yes libqrencode-dev
		sudo apt-get install --yes libgladeui-dev
		sudo apt-get install --yes nasm
		sudo apt-get install --yes texlive-latex-extra
		sudo apt-get install --yes libunique-3.0-dev
		sudo apt-get install --yes gawk
		sudo apt-get install --yes miniupnpc
		sudo apt-get install --yes libfuse-dev
		sudo apt-get install --yes libbluetooth-dev

		# Install testing libraries
		sudo apt-get install -t unstable --yes nettle-dev
		sudo apt-get install -t unstable --yes libgstreamer1.0-dev
		sudo apt-get install -t unstable --yes gstreamer1.0-plugins-base
		sudo apt-get install -t unstable --yes gstreamer1.0-plugins-good
		sudo apt-get install -t unstable --yes libgstreamer-plugins-base1.0-dev
	else
		echo 'gnunet-arm already installed, skipping apt installs...'
	fi

	if ! which gdb >/dev/null;
	then
		# To install GDB the correct version of libpython has to be installed
		# manually first. Otherwise apt can not resolve the dependancies
		sudo apt-get install --yes libpython2.7=2.7.7~rc1-1
		sudo apt-get install --yes gdb
	else
		echo 'skipping gdb ...'
	fi

	# Some clean up
	sudo apt-get autoremove --yes
fi

# Install deps from source

mkdir -p /vagrant/res

if [[ ! -d /vagrant/res/libextractor ]];
then
	cd /vagrant/res
	wget http://ftp.gnu.org/gnu/libextractor/libextractor-1.3.tar.gz
	tar xvf libextractor-1.3.tar.gz
	rm libextractor-1.3.tar.gz
	mv libextractor-1.3 libextractor
	cd libextractor
	./configure
	make
	sudo make install
else
	echo 'skipping libextractor ...'
fi

if [[ ! -d /vagrant/res/libav ]];
then
	cd /vagrant/res
	wget https://libav.org/releases/libav-9.10.tar.xz
	tar xvf libav-9.10.tar.xz
	rm libav-9.10.tar.xz
	mv libav-9.10 libav
	cd libav
	./configure --enable-shared
	make
	sudo make install
else
	echo 'skipping libav ...'
fi

if [[ ! -d /vagrant/res/libgpg-error ]];
then
	cd /vagrant/res
	wget ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.12.tar.bz2
	tar xvf libgpg-error-1.12.tar.bz2
	rm libgpg-error-1.12.tar.bz2
	mv libgpg-error-1.12 libgpg-error
	cd libgpg-error
	./configure
	make
	sudo make install
else
	echo 'skipping libgpg-error ...'
fi

if [[ ! -d /vagrant/res/libgcrypt ]];
then
	cd /vagrant/res
	wget ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.0.tar.bz2
	tar xvf libgcrypt-1.6.0.tar.bz2
	rm libgcrypt-1.6.0.tar.bz2
	mv libgcrypt-1.6.0 libgcrypt
	cd libgcrypt
	./configure --with-gpg-error-prefix=/usr/local
	make
	sudo make install
else
	echo 'skipping libgcypt ...'
fi

if [[ ! -d /vagrant/res/gnutls ]];
then
	cd /vagrant/res
	wget ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.7.tar.xz
	tar xvf gnutls-3.2.7.tar.xz
	rm gnutls-3.2.7.tar.xz
	mv gnutls-3.2.7 gnutls
	cd gnutls
	./configure
	make
	sudo make install
else
	echo 'skipping gnutls ...'
fi

if [[ ! -d /vagrant/res/libmicrohttpd ]];
then
	cd /vagrant/res
	wget http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.33.tar.gz
	tar xvf libmicrohttpd-0.9.33.tar.gz
	rm libmicrohttpd-0.9.33.tar.gz
	mv libmicrohttpd-0.9.33 libmicrohttpd
	cd libmicrohttpd
	./configure
	make
	sudo make install
else
	echo 'skipping libmicrohttpd ...'
fi

if [[ ! -d /vagrant/res/gnurl ]];
then
	cd /vagrant/res
	wget https://gnunet.org/sites/default/files/gnurl-7.34.0.tar.bz2
	tar xvf gnurl-7.34.0.tar.bz2
	rm gnurl-7.34.0.tar.bz2
	mv gnurl-7.34.0 gnurl
	cd gnurl
	./configure --enable-ipv6 --with-gnutls=/usr/local --without-libssh2 --without-libmetalink --without-winidn --without-librtmp --without-nghttp2 --without-nss --without-cyassl --without-polarssl --without-ssl --without-winssl --without-darwinssl --disable-sspi --disable-ntlm-wb --disable-ldap --disable-rtsp --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smtp --disable-gopher --disable-file --disable-ftp
	make
	sudo make install
else
	echo 'skipping gnurl ...'
fi

# Add a GNUnet user if not exists
if [[ -z $(grep gnunet: /etc/passwd) ]];
then
	sudo adduser --system --shell /bin/bash --home /var/lib/gnunet --group --disabled-password gnunet
	sudo addgroup --system gnunetdns
fi

# Finally install GNUnet
if [[ ! -d /vagrant/res/gnunet ]];
then
	cd /vagrant/res
	wget http://ftpmirror.gnu.org/gnunet/gnunet-0.10.1.tar.gz
	tar xvf gnunet-0.10.1.tar.gz
	rm -rf gnunet-0.10.1.tar.gz
	mv gnunet-0.10.1 gnunet
	cd gnunet
	./configure --with-sudo=sudo --with-nssdir=/lib --enable-logging=verbose
	make
	sudo make install
	cd ..
else
	echo 'skipping gnunet ...'
fi

# Create config if not present
if [[ ! -f /etc/gnunet.conf ]]; then
	sudo touch /etc/gnunet.conf
	echo "[arm]" | sudo tee -a /etc/gnunet.conf
	echo "SYSTEM_ONLY = YES" | sudo tee -a /etc/gnunet.conf
	echo "USER_ONLY = NO" | sudo tee -a /etc/gnunet.conf
	sudo adduser vagrant gnunet
	echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" | sudo tee -a /home/vagrant/.bashrc
fi

# Start GNUnet
sudo -u vagrant bash -c "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib; gnunet-arm -c /etc/gnunet.conf -s"

# Some inital conf that is recommended to be done after GNUnet is started
if [[ ! -f /etc/gnunet.conf ]]; then
	gnunet-gns-import.sh
	gnunet-gns-proxy-setup-ca
fi

# export GNUNET_PRREFIX for vagrant user
if ! grep -q GNUNET_PREFIX "/home/vagrant/.bashrc"; then
   echo "export GNUNET_PREFIX=/usr/local" | sudo tee -a /home/vagrant/.bashrc
fi

# export GNUNET_LOG for MQTT
if ! grep -q GNUNET_LOG "/home/vagrant/.bashrc"; then
	echo 'export GNUNET_LOG="mqtt-api;;;;DEBUG/mqtt;;;;DEBUG"' | sudo tee -a /home/vagrant/.bashrc
fi
