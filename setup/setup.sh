#!/bin/bash

APP=nginx
HOME=/opt/$APP
GROUP=$APP
USER=$APP
SYSD=/etc/systemd/system
SERFILE=nginx.service

init() {
  egrep "^$GROUP" /etc/group >/dev/null
  if [[ $? -ne 0 ]]; then
    groupadd -r $GROUP
  fi

  egrep "^$USER" /etc/passwd >/dev/null
  if [[ $? -ne 0 ]]; then
    useradd -r -g $GROUP -s /usr/sbin/nologin -M $USER
  fi

  if [[ ! -d $HOME/log ]]; then
    mkdir $HOME/log
  fi

  if [[ ! -d $HOME/record ]]; then
    mkdir -p $HOME/record
  fi

  if [[ ! -d $HOME/var ]]; then
    mkdir -p $HOME/var
  fi

  if [[ ! -d $HOME/var/cache ]]; then
    mkdir -p $HOME/var/cache
  fi

  if [[ ! -d $HOME/var/cache/hls_temp ]]; then
    mkdir -p $HOME/var/cache/hls_temp
  fi

  if [[ ! -d $HOME/var/run ]]; then
    mkdir -p $HOME/var/run
  fi

  chown -R $GROUP:$USER $HOME
  chmod 755 $HOME

  if [[ ! -s $SYSD/$SERFILE ]]; then
    ln -s $HOME/setup/$SERFILE $SYSD/$SERFILE
    systemctl enable $SERFILE
    echo "($APP) create symlink: $SYSD/$SERFILE --> $HOME/setup/$SERFILE"
  fi

  systemctl daemon-reload
}

deinit() {
  if [[ -d $HOME/log ]]; then
    rm -rf $HOME/log
  fi

  if [[ -d $HOME/var ]]; then
    rm -rf $HOME/var
  fi

  chown -R root:root $HOME

  if [[ -s $SYSD/$SERFILE ]]; then
    systemctl disable $SERFILE
    rm -rf $SYSD/$SERFILE
    echo "($APP) delete symlink: $SYSD/$SERFILE"
  fi

  systemctl daemon-reload
}

start() {
  pgrep -x $APP >/dev/null
  if [[ $? != 0 ]]; then
	systemctl start $SERFILE
    echo "($APP) $APP start!"
  fi

  show
}

stop() {
  pgrep -x $APP >/dev/null
  if [[ $? == 0 ]]; then
    systemctl stop $SERFILE
    echo "($APP) $APP stop!"
    #kill -9 `pidof $APP`
    #echo "($APP) $APP stop! (auto restart when systemd)"
  fi

  show
}

show() {
  ps -ef | grep $APP | grep -v 'grep'
}

case "$1" in
  init) init ;;
  deinit) deinit ;;
  start) start ;;
  stop) stop ;;
  show) show ;;
  *) SCRIPTNAME="${0##*/}"
     echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
     exit 3
     ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
