 #!/bin/sh
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
echo "; Welcom to TechNHIT LAMP Stack with VHost installation ;"
echo "; Thank You for installanton Virtual Host ;"
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"

echo -n "Enter Your Domin (FQDN) name :"
read vuser
echo -n "Enter Admin Email Address :"
read eml
echo "You have enter Domin Name : $vuser"
len=`echo $vuser|awk '{print length}'`
echo "lenth is $len"
dn=""
p=$(echo ${vuser%.*} | wc -c) #Finding position of . in domen name

if [ $p -eq 8 ]
then
echo "your virtual username will be `expr substr $vuser 1 $((p-1))` "
dn=`expr substr $vuser 1 $((p-1))`
elif [ $p -lt 8 ]
then
echo "your virtual username will be `expr substr $vuser 1 $((p-1))` "
dn=`expr substr $vuser 1 $((p-1))`
else
echo "your virtual username will be `expr substr $vuser 1 8`"
dn=`expr substr $vuser 1 8`
fi

if grep -c "^$dn:" /etc/passwd ; then

echo -n "User already exist,Please Enter Another User Name:"
read dn
fi

echo "Do you want to proceed (Yes/No)?"
read ch
if [ "$ch" = "y" ] || [ "$ch" = "Y" ] || [ "$ch" = "yes" ] || [ "$ch" = "YES" ]
then
sudo apt-get update
sudo apt-get install apache2 mysql-server php libapache2-mod-php php-mysql php-gd php-mcrypt

sudo useradd -m $dn

#sudo chown -R $dn:$dn /home/$dn/

sudo mkdir /home/$dn/public_html
sudo touch /home/$dn/public_html/index.php

f="/home/$dn/public_html/index.php"
sudo sh -c "echo '<?php phpinfo(); ?>' >> $f"


sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$vuser.conf

f="/etc/apache2/sites-available/$vuser.conf"

sudo sed -i -e '11c\'"ServerAdmin $eml" $f
sudo sed -i -e '12c\'"ServerName $vuser" $f
sudo sed -i -e '13i\'"ServerAlias www.$vuser" $f
sudo sed -i -e '14i\'"DocumentRoot /home/$dn/public_html/" $f
sudo sed -i -e '15i\'"<Directory /home/$dn/public_html/>" $f
sudo sed -i -e '16i\'"Options Indexes FollowSymLinks" $f
sudo sed -i -e '17i\'"AllowOverride None" $f
sudo sed -i -e '18i\'"Require all granted" $f
sudo sed -i -e '19i\'"</Directory>" $f


sudo a2dissite 000-default.conf #Desible the default sites
sudo a2ensite $vuser.conf #Enable the sites
sudo service apache2 restart #Apache configration reload and restart

#Add record to hosts file
f2="/etc/hosts"
sudo sed -i -e '1i\'"127.0.0.1 $vuser" $f2

fi
#End of Script
