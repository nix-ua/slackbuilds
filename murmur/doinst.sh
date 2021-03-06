#!/bin/sh

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

config etc/logrotate.d/murmur.new
config etc/murmur.ini.new
config etc/dbus-1/system.d/murmur.conf.new

preserve_perms etc/rc.d/rc.murmur.new
