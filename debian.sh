#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
curl -s -o ip.txt http://kallong.000webhost.com/debian7/sh/ip.txt
find=`grep $myip ip.txt`
if [ "$find" = "" ]
then
clear
echo "
                                        _\|/_                         
                                        (o o)                         
                #====================o00-{_}-00o=====================#
                #        SCRIPT SYSTEM AUTO INSTAL KALLONGNET        #
                #====================================================#
                #      Mohon Maaf IP Anda Belum Memiliki Akses       #
                #           Untuk Menggunakan script ini             #
                #----------------------------------------------------#
                #              [SILAHKAN KONTAK KAMI]                #
                #              ----------------------                #
                #            WhatsApp   : 085211277183               #
                #            Pin-Bbm    : kallong                    #
                #            Facebook   : Aditya PratamaII           #
                #            Website    : kallonet.top               #
                #                                                    #
                #   Copyright © 2017 KallongNet Premium              #
                #====================================================#
"
rm *.txt
rm *.sh
exit
fi
if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
fi
echo "
== KALLONGNET SYSTEM SCRIPT ==
PLEASE CANCEL ALL PACKAGE POPUP
TAKE NOTE !!!"
clear
echo "START AUTOSCRIPT NO CLOSE INSTALLER !!"
clear
# go to root
cd
# aplikasi
sudo apt-get install ruby
sudo gem install lolcat;

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update
apt-get -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update 
apt-get -y upgrade

#text gambar
apt-get install boxes

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install nmap nano iptables sysv-rc-conf openvpn vnstat apt-file
apt-get -y install libexpat1-dev libxml-parser-perl
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# Setting Vnstat
vnstat -u -i eth0
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# install screenfetch
cd
wget http://kallongnet.com/debian32/config/openvpn/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# Install Web Server
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://kallong.000webhost.com/debian7/config/openvpn/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by ambon</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://kallong.000webhost.com/debian7/config/openvpn/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "http://kallong.000webhost.com/debian7/config/openvpn/openvpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "http://kallong.000webhost.com/debian7/config/openvpn/1194-debian.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
wget -O /etc/iptables.up.rules "http://kallong.000webhost.com/debian7/config/openvpn/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i 's/port 465/port 465/g' /etc/openvpn/1194.conf
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
service openvpn restart

# configure openvpn client config
cd /etc/openvpn/
wget -O /etc/openvpn/1194-client.ovpn "http://kallong.000webhost.com/debian7/config/openvpn/1194-client.conf"
sed -i $MYIP2 /etc/openvpn/1194-client.ovpn;
sed -i 's/1194/465/g' /etc/openvpn/1194-client.ovpn
NAME=`uname -n`.`awk '/^domain/ {print $2}' /etc/resolv.conf`;
mv /etc/openvpn/1194-client.ovpn /etc/openvpn/$NAME.ovpn
useradd -M -s /bin/false kallongnet
echo "aditya:pratama" | chpasswd
tar cf client.tar $NAME.ovpn
cp client.tar /home/vps/public_html/

# install badvpn
wget -O /usr/bin/badvpn-udpgw "http://kallong.000webhost.com/debian7/config/openvpn/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

cd
# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 80 -p 110 -p 69 -p 777 -p 22507"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# upgade dropbear
apt-get install zlib1g-dev
wget cp /root/hapususer.sh /usr/bin/hapusakun
chmod +x /usr/bin/hapusakun
wget http://kallong.000webhost.com/debian7/config/dropbear-2016.74.tar.bz2
bzip2 -cd dropbear-2016.74.tar.bz2 | tar xvf -
cd dropbear-2016.74
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear.old
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
cd && rm -rf dropbear-2016.74 && rm -rf dropbear-2016.74.tar.bz2

# install vnstat gui
cd /home/vps/public_html/
wget http://kallong.000webhost.com/debian7/config/openvpn/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
cd

# Install Dos Deflate
apt-get -y install dnsutils dsniff
wget http://kallong.000webhost.com/debian7/config/openvpn/ddos-deflate-master.zip
unzip master.zip
cd ddos-deflate-master
./install.sh

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://kallong.000webhost.com/debian7/config/openvpn/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.820_all.deb"
dpkg --install webmin_1.820_all.deb;
apt-get -y -f install;
rm /root/webmin_1.820_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart

# Install Menu
cd
wget http://kallong.000webhost.com/debian7/menu/menu
mv ./menu /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# instal akun trial
cd
wget http://kallong.000webhost.com/debian7/config/trial
mv ./trial /usr/bin/trial
chmod +x /usr/bin/trial

# instal usernew
cd
wget http://kallong.000webhost.com/debian7/config/usernew
mv ./usernew /usr/bin/usernew
chmod +x /usr/bin/usernew

# instal renew
cd
wget http://kallong.000webhost.com/debian7/config/renew
mv ./renew /usr/bin/renew
chmod +x /usr/bin/renew

# instal cekuser
cd
wget http://kallong.000webhost.com/debian7/config/cekuser
mv ./cekuser /usr/bin/cekuser
chmod +x /usr/bin/cekuser

# instal userlogin
cd
wget http://kallong.000webhost.com/debian7/config/userlogin
mv ./userlogin /usr/bin/userlogin
chmod +x /usr/bin/userlogin

# hapususer
wget http://kallong.000webhost.com/debian7/config/hapususer.sh
cp /root/hapususer.sh /usr/bin/hapusakun
chmod +x /usr/bin/hapusakun

#speedtest
cd
apt-get install python
wget -O speedtest.py "http://kallong.000webhost.com/debian7/config/speedtest.py"
chmod +x speedtest.py

# moth
cd
wget http://kallong.000webhost.com/debian7/config/motd
mv ./motd /etc/motd

# text warna
cd
rm -rf .bashrc
wget http://kallong.000webhost.com/debian7/config/.bashrc

#bonus block torrent
wget http://kallong.000webhost.com/debian7/sh/torrent.sh
chmod +x  torrent.sh
./torrent.sh

#cache ram
cd
wget http://kallong.000webhost.com/debian7/sh/clearcache.sh
mv clearcache.sh /root/
#echo "@reboot root /root/clearcache.sh" > /etc/cron.d/clearcache
chmod 755 /root/clearcache.sh

# auto reboot 24jam
cd
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
echo "*/50 * * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "*/50 * * * * root service ssh restart" >> /etc/cron.d/dropbear
#echo "* * * * * root sleep 10; ./userlimit.sh 2" > /etc/cron.d/userlimit2
#echo "* * * * * root sleep 20; ./userlimit.sh 2" > /etc/cron.d/userlimit4
#echo "* * * * * root sleep 30; ./userlimit.sh 2" > /etc/cron.d/userlimit6
#echo "* * * * * root sleep 40; ./userlimit.sh 2" > /etc/cron.d/userlimit8
#echo "* * * * * root sleep 50; ./userlimit.sh 2" > /etc/cron.d/userlimit11
echo "0 1 * * * root ./userexpired.sh" >> /etc/cron.d/reboot
echo "*/3 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache

# auto kill dropbear
#wget "http://kallong.000webhost.com/debian7/menu/userlimit.sh"
#mv ./userlimit /usr/bin/userlimit.sh
#chmod +x /usr/bin/userlimit.sh
#echo " /etc/security/limits.conf" > /etc/security/limits.conf

# cranjob
#sudo apt-get install cron
#wget http://kallong.000webhost.com/debian7/menu/crontab
#mv crontab /etc/
#chmod 644 /etc/crontab

# tool 
cd
wget -O userlimit.sh "http://kallong.000webhost.com/debian7/menu/userlimit.sh"
wget -O user-expired.sh "http://kallong.000webhost.com/debian7/sh/user-expired.sh"
wget -O /usr/bin/gusur "http://kallongnet.com/debian32/config/gusur"
#wget -O autokill.sh "http://kallong.000webhost.com/debian7/menu/autokill.sh"
#wget -O userlimitssh.sh "http://kallong.000webhost.com/debian7/menu/userlimitssh.sh"
echo "@reboot root /root/user-expired.sh" > /etc/cron.d/user-expired.sh
#echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimit
#echo "@reboot root /root/userlimitssh.sh" > /etc/cron.d/userlimitssh
#echo "@reboot root /root/autokill.sh" > /etc/cron.d/autokill
#sed -i '$ i\screen -AmdS check /root/autokill.sh' /etc/rc.local
chmod +x user-expired.sh
chmod +x /usr/bin/gusur
chmod 755 userlimit.sh
#chmod +x autokill.sh
#chmod +x userlimitssh.sh

# userlimit
#cd
#wget "http://kallong.000webhost.com/debian7/menu/limits.conf"
#mv limits.conf /etc/security/limits.conf
#chmod 644 /etc/security/limits.conf

# Restart Service

chown -R www-data:www-data /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

#rip
cd
rm debian.sh

# info
clear
echo "                        _\|/_                        "
echo "                        (o o)                        "                                       
echo "#====================o00-{_}-00o====================#"
echo "Setup by Aditya PratamaII"
echo "OpenVPN  : TCP 1194 , 465"
echo "OpenSSH  : 22, 143"
echo "Dropbear : 80, 110, 443 , 69 , 777 . 22507"
echo "Squid3   : 8080 , 8000 , 3128 (limit to IP SSH)"
echo "BadVPN   : 7300"
echo "FITUR LAIN"
echo "------------------------------------------------------"
echo "OpenVPN  : client config : http://$MYIP:81/client.tar"
echo "Webmin   : http://$MYIP:10000/"
echo "vnstat   : http://$MYIP:81/vnstat/"
echo "Timezone : Asia/Jakarta"
echo "Fail2Ban : [on]"
echo "IPv6     : [off]"
echo "ClearCace: [on]"
echo "Auto Expd: [on]"
echo "Reboot   : 24 Jam Sekali"
echo "Status   : please type ./status to check user status"
echo ""
echo "SILAHKAN KETIK MENU SETELAH REBOOT"
echo "WIS PRAGAT TINGGAL REBOOT TOK GYAN !"
echo ""
echo "======================================================"

