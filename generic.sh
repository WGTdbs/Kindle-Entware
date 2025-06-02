#!/bin/sh

TYPE='generic'
#TYPE='alternative'

#|---------|-----------------------|---------------|---------------|---------------------|-------------------|-------------------|----------------------|-------------------|
#| ARCH    | aarch64-k3.10         | armv5sf-k3.2  | armv7sf-k2.6  | armv7sf-k3.2        | mipselsf-k3.4     | mipssf-k3.4       | x64-k3.2             | x86-k2.6          |
#| LOADER  | ld-linux-aarch64.so.1 | ld-linux.so.3 | ld-linux.so.3 | ld-linux.so.3       | ld.so.1           | ld.so.1           | ld-linux-x86-64.so.2 | ld-linux.so.2     |
#| GLIBC   | 2.27                  | 2.27          | 2.23          | 2.27                | 2.27              | 2.27              | 2.27                 | 2.23              |
#|---------|-----------------------|---------------|---------------|---------------------|-------------------|-------------------|----------------------|-------------------|

unset LD_LIBRARY_PATH
unset LD_PRELOAD

ARCH=armv7sf-k2.6
LOADER=ld-linux.so.3
GLIBC=2.23

echo 'Info: Checking for prerequisites and creating folders...'
if [ -d /mnt/us/opt ]; then
    echo 'Warning: Folder /mnt/us/opt exists!'
else
    mkdir /mnt/us/opt
fi
# no need to create many folders. entware-opt package creates most
for folder in bin etc lib/opkg tmp var/lock
do
  if [ -d "/mnt/us/opt/$folder" ]; then
    echo "Warning: Folder /mnt/us/opt/$folder exists!"
    echo 'Warning: If something goes wrong please clean /mnt/us/opt folder and try again.'
  else
    mkdir -p /mnt/us/opt/$folder
  fi
done

echo 'Info: Opkg package manager deployment...'
URL=http://bin.entware.net/ ${ARCH}/installer
wget $URL/opkg -O /mnt/us/opt/bin/opkg
chmod 755 /mnt/us/opt/bin/opkg
wget $URL/opkg.conf -O /mnt/us/opt/etc/opkg.conf

echo 'Info: Basic packages installation...'
/mnt/us/opt/bin/opkg update
if [ $TYPE = 'alternative' ]; then
  /mnt/us/opt/bin/opkg install busybox
fi
/mnt/us/opt/bin/opkg install entware-opt

# Fix for multiuser environment
chmod 777 /mnt/us/opt/tmp

for file in passwd group shells shadow gshadow; do
  if [ $TYPE = 'generic' ]; then
    if [ -f /etc/$file ]; then
      ln -sf /etc/$file /mnt/us/opt/etc/$file
    else
      [ -f /mnt/us/opt/etc/$file.1 ] && cp /mnt/us/opt/etc/$file.1 /mnt/us/opt/etc/$file
    fi
  else
    if [ -f /mnt/us/opt/etc/$file.1 ]; then
      cp /mnt/us/opt/etc/$file.1 /mnt/us/opt/etc/$file
    fi
  fi
done

[ -f /etc/localtime ] && ln -sf /etc/localtime /mnt/us/opt/etc/localtime

echo 'Info: Finish!'
echo 'Info: Kindle-Entware was successfully initialized.'
echo 'Info: Add /mnt/us/opt/bin & /mnt/us/opt/sbin to $PATH variable'
echo 'Info: Add "/mnt/us/opt/etc/init.d/rc.unslung start" to startup script for Kindle-Entware services to start'

echo 'Info: Found a Bug? Please report at wuguantingdanbishi@outlook.com'
echo 'Follow my BiliBili:wuguantingdanbish'
echo 'Made by:Wuguanting'