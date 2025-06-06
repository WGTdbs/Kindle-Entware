#!/bin/sh

TYPE='generic'
#TYPE='alternative'

unset LD_LIBRARY_PATH
unset LD_PRELOAD

ARCH=armv7sf-k2.6
LOADER=ld-linux.so.3
GLIBC=2.23

echo 'Info: Checking for prerequisites and creating folders...'
if [ -d /opt ]; then
    echo 'Warning: Folder /opt exists!'
else
    mkdir /opt
fi
# no need to create many folders. entware-opt package creates most
for folder in bin etc lib/opkg tmp var/lock
do
  if [ -d "/opt/$folder" ]; then
    echo "Warning: Folder /opt/$folder exists!"
    echo 'Warning: If something goes wrong please clean /opt folder and try again.'
  else
    mkdir -p /opt/$folder
  fi
done

echo 'Info: Opkg package manager deployment...'
URL=http://bin.entware.net/${ARCH}/installer
wget $URL/opkg -O /opt/bin/opkg
chmod 755 /opt/bin/opkg
wget $URL/opkg.conf -O /opt/etc/opkg.conf

echo 'Info: Basic packages installation...'
/opt/bin/opkg update
if [ $TYPE = 'alternative' ]; then
  /opt/bin/opkg install busybox
fi
/opt/bin/opkg install entware-opt

# Fix for multiuser environment
chmod 777 /opt/tmp

for file in passwd group shells shadow gshadow; do
  if [ $TYPE = 'generic' ]; then
    if [ -f /etc/$file ]; then
      ln -sf /etc/$file /opt/etc/$file
    else
      [ -f /opt/etc/$file.1 ] && cp /opt/etc/$file.1 /opt/etc/$file
    fi
  else
    if [ -f /opt/etc/$file.1 ]; then
      cp /opt/etc/$file.1 /opt/etc/$file
    fi
  fi
done

[ -f /etc/localtime ] && ln -sf /etc/localtime /opt/etc/localtime

cp /opt/bin/opkg /bin

echo 'Info: Finish!'
echo 'Info: Kindle-Entware was successfully initialized.'
echo 'Info: Add opt/bin & opt/sbin to $PATH variable'
echo 'Info: Add "opt/etc/init.d/rc.unslung start" to startup script for Kindle-Entware services to start'

echo 'Info: Found a Bug? Please report at wuguantingdanbishi@outlook.com'
echo 'Follow my BiliBili:wuguantingdanbish'
echo 'Made by:Wuguanting'
