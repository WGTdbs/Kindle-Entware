#!/bin/sh

# Kindle Paperwhite 3的架构为ARMv7，内核版本为3.0.2
ARCH=armv7sf-k2.6

# 定义日志函数
POS=1
log() {
  echo "${1}" >> /mnt/us/entware_install.log
  eips 0 $POS "${1}"
  POS=$((POS+1))
}

# 定义安装目录
INSTALL_DIR=/mnt/us/entware

log 'Info: Checking for prerequisites and creating folders...'
# 创建安装目录
mkdir -p $INSTALL_DIR/bin
mkdir -p $INSTALL_DIR/etc
mkdir -p $INSTALL_DIR/lib/opkg
mkdir -p $INSTALL_DIR/tmp
mkdir -p $INSTALL_DIR/var/lock

log 'Info: Opkg package manager deployment...'
URL=http://bin.entware.net/${ARCH}/installer
wget $URL/opkg -O $INSTALL_DIR/bin/opkg
chmod 755 $INSTALL_DIR/bin/opkg
wget $URL/opkg.conf -O $INSTALL_DIR/etc/opkg.conf

# 修改opkg.conf中的安装路径
sed -i "s:/opt:$INSTALL_DIR:g" $INSTALL_DIR/etc/opkg.conf

log 'Info: Basic packages installation...'
$INSTALL_DIR/bin/opkg update
$INSTALL_DIR/bin/opkg install entware-opt

# 修复多用户环境的权限问题
chmod 777 $INSTALL_DIR/tmp

log 'Info: Congratulations!'
log 'Info: If there are no errors above then Entware was successfully initialized.'
log "Info: Add $INSTALL_DIR/bin & $INSTALL_DIR/sbin to \$PATH variable"
log 'Info: Found a Bug? Please report at https://github.com/Entware/Entware/issues'
