#!/bin/bash

APP=nginx
HOME=/opt/$APP
GROUP=$APP
USER=$APP
SYSD=/etc/systemd/system
SERFILE=nginx.service

initialize() {
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

  if [[ ! -d $HOME/run ]]; then
    mkdir $HOME/run
  fi

  if [[ ! -d $HOME/cache ]]; then
    mkdir $HOME/cache
  fi

  chown -R $GROUP:$USER $HOME
  chmod 755 $HOME

  if [[ ! -s $SYSD/$SERFILE ]]; then
    ln -s $HOME/setup/$SERFILE $SYSD/$SERFILE
    echo "($APP) create symlink: $SYSD/$SERFILE --> $HOME/setup/$SERFILE"
  fi

  systemctl daemon-reload
}

deinitialize() {
  if [[ -d $HOME/log ]]; then
    rm -rf $HOME/log
  fi

  if [[ -d $HOME/run ]]; then
    rm -rf $HOME/run
  fi

  if [[ -d $HOME/cache ]]; then
    rm -rf $HOME/cache
  fi

  chown -R root:root $HOME

  if [[ -s $SYSD/$SERFILE ]]; then
    rm -rf $SYSD/$SERFILE
    echo "($APP) delete symlink: $SYSD/$SERFILE"
  fi

  systemctl daemon-reload
}

daemon_start() {
  pgrep -x $APP >/dev/null
  if [[ $? != 0 ]]; then
	systemctl start $SERFILE
    echo "($APP) $APP start!"
  fi

  daemon_show
}

daemon_stop() {
  pgrep -x $APP >/dev/null
  if [[ $? == 0 ]]; then
    systemctl stop $SERFILE
    echo "($APP) $APP stop!"
    #kill -9 `pidof $APP`
    #echo "($APP) $APP stop! (auto restart when systemd)"
  fi

  daemon_show
}

daemon_show() {
  ps -ef | grep $APP | grep -v 'grep'
}

case "$1" in
  init)
    initialize
    ;;
  deinit)
    deinitialize
    ;;
  start)
    daemon_start
    ;;
  stop)
    daemon_stop
    ;;
  show)
	daemon_show
	;;
  *)
    SCRIPTNAME="${0##*/}"
    echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
    exit 3
    ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
