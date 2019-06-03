# Download package
wget http://apache.crihan.fr/dist//httpd/httpd-2.4.39.tar.gz
wget https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2 --no-check-certificate
wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2 --no-check-certificate
wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.43.tar.gz
sudo apt -y install make gcc libexpat1-dev g++

# OPENSSL installation
tar -zxf openssl-1.1.1b.tar.gz && cd openssl-1.1.1b
./config
make
sudo make test
sudo mv /usr/bin/openssl ~/tmp
sudo make install
sudo ln -s /usr/local/bin/openssl /usr/bin/openssl
sudo ldconfig
cd ..

# APR installtion
tar xjf apr-1.7.0.tar.bz2
cd apr-1.7.0
./configure --prefix=/usr --disable-static --with-installbuilddir=/usr/share/apr-1/build && make
sudo make install
cd ..


# APR-UTIL installtion
tar xjf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1
./configure --prefix=/usr --with-apr=/usr --with-gdbm=/usr --with-openssl=/usr --with-crypto && make
sudo make install
cd ..


# PCRE installtion
tar zxvf pcre-8.43.tar.gz
cd pcre-8.43
./configure --prefix=/usr/local/pcre
make
sudo make install
cd ..


# APACHE2 installation
tar zxvf httpd-2.4.39.tar.gz
cd httpd-2.4.39
./configure --prefix=/usr/local/apache2 --with-pcre=/usr/local/pcre
make
sudo make install
cd ..

# Certificate creation
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/apache2/conf/server.key -out /usr/local/apache2/conf/server.crt
sudo sed -i '134s/#//' /usr/local/apache2/conf/httpd.conf
sudo sed -i '495s/#//' /usr/local/apache2/conf/httpd.conf
sudo sed -i '85s/#//' /usr/local/apache2/conf/httpd.conf
sudo sed -i '79s:SSLProtocol all -SSLv3:SSLProtocol -all +TLSv1.3 +TLSv1.2:' /usr/local/apache2/conf/extra/httpd-ssl.conf
sudo sed -i '54iSSLCipherSuite    TLSv1.3   TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256' /usr/local/apache2/conf/extra/httpd-ssl.conf
sudo sed -i '55iSSLCipherSuite    SSL       ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256' /usr/local/apache2/conf/extra/httpd-ssl.conf
sudo sed -i '56iSSLOpenSSLConfCmd Curves X25519:secp521r1:secp384r1:prime256v1' /usr/local/apache2/conf/extra/httpd-ssl.conf
sudo /usr/local/apache2/bin/apachectl -k start

# Manualy last modif
echo "For last modif      -> go /usr/local/apache2/conf/httpd.conf"
echo "Read                -> https://unix.stackexchange.com/questions/443341/how-to-enable-tlsv1-3-in-apache2"
echo "For testing TLSv1.3 -> https://www.ssllabs.com/ssltes"
echo "For start do : /usr/local/apache2/bin/apachectl -k start/stop"
