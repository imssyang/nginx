#!/bin/sh

GROUP=nginx
USER=nginx
APP=nginx
SYSD=/etc/systemd/system
SERFILE=nginx.service

egrep "^$GROUP" /etc/group >/dev/null
if [[ $? -ne 0 ]]; then
  groupadd -r $GROUP
fi

egrep "^$USER" /etc/passwd >/dev/null
if [[ $? -ne 0 ]]; then
  useradd -r -g $GROUP -s /usr/sbin/nologin -M $USER
fi

if [[ ! -d /opt/$APP/cache ]]; then
  mkdir /opt/$APP/cache
fi

chown -R $GROUP:$USER /opt/$APP
chmod 755 /opt/$APP

if [[ ! -s $SYSD/$SERFILE ]]; then
  ln -s /opt/$APP/setup/$SERFILE $SYSD/$SERFILE
  echo -e "\033[91m($APP)\033[0m create symlink: $SYSD/$SERFILE --> /opt/$APP/setup/$SERFILE"
fi

