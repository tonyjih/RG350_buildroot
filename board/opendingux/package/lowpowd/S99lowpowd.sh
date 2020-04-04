#!/bin/sh

case "$1" in
start)
	echo "Starting low power warning daemon..."
	start-stop-daemon -S -b -m -p /var/run/lowpowd.pid \
		-x /usr/sbin/lowpowd
	;;
stop)
	echo "Stopping low power warning daemon..."
	start-stop-daemon -K -q -p /var/run/lowpowd.pid
	rm -f /var/run/lowpowd.pid
	;;
status)
	RET=1
	if [ -r /var/run/lowpowd.pid ] ; then
		kill -0 `cat /var/run/lowpowd.pid` 2>&1 >/dev/null
		RET=$?
	fi
	if [ $RET -eq 0 ] ; then
		echo "lowpowd is running"
	else
		echo "lowpowd is NOT running"
	fi
	exit $RET
	;;
*)
	echo "Usage: $0 {start|stop|status}"
	exit 1
esac

exit $?
