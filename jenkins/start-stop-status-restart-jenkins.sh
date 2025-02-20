#!/bin/bash

set -e

INSTALL_DIR="/app/jenkins"
LOGS_DIR="$INSTALL_DIR/logs"
JENKINS_WAR="$INSTALL_DIR/jenkins.war"
PID_FILE="$INSTALL_DIR/jenkins.pid"
JENKINS_PORT=8080

start_jenkins() {
  if [ -f "$PID_FILE" ]; then
    echo "Jenkins is already running."
    exit 1
  fi

  echo "Starting Jenkins"
  nohup java -jar "$JENKINS_WAR" --httpPort=$JENKINS_PORT > "$LOGS_DIR/jenkins.log" 2>&1 &
  echo $! > "$PID_FILE"
  echo "Jenkins started with port $JENKINS_PORT and PID $(cat $PID_FILE)"
}

stop_jenkins() {
  if [ ! -f "$PID_FILE" ]; then
    echo "Jenkins is not running."
    exit 1
  fi

  echo "Stopping Jenkins..."
  kill "$(cat $PID_FILE)" && rm -f "$PID_FILE"
  echo "Jenkins stopped."
}

status_jenkins() {
  if [ -f "$PID_FILE" ]; then
    echo "Jenkins is running with port $JENKINS_PORT and PID $(cat $PID_FILE)."
  else
    echo "Jenkins is not running."
  fi
}

restart_jenkins() {
  stop_jenkins
  start_jenkins
}

case "$1" in
  start) start_jenkins ;;
  stop) stop_jenkins ;;
  restart) restart_jenkins ;;
  force-stop) force_stop_jenkins ;;
  status) status_jenkins ;;
  *)
    echo "Usage: $0 {start|stop|status|restart}"
    exit 1
    ;;
esac
