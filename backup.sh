#!/bin/bash
set -e

check_unset_var ()
{
	if [ -z "${!1}" ]
	then
		echo "$1 is unset"
		exit 1;
	fi
}


rcon ()
{
	echo "rcon $1"
	set +e
	rconc s $1
	error=$?
	set -e
	i=0
	while [ $error -ne 0 ]
	do
		((i=i+1))
		echo "retry in 10s	($i)"
		sleep 10s
		set +e
		rconc s $1
		error=$?
		set -e
	done
}

backup_world ()
{
	rcon save-off
	rcon save-all
	tar -czPf "/backup/$(date +%Y_%m_%d_%H_%M.tar.gz)" "$SRC_DIR"
	rcon save-on
}





#main

check_unset_var RCON_ADDRESS
check_unset_var RCON_PASSWORD
check_unset_var SRC_DIR
set -u

set +e
rconc server remove s
set -e
rconc server add s "$RCON_ADDRESS:${RCON_PORT:-25575}" "$RCON_PASSWORD"

echo "waiting initial delay of ${INITIAL_DELAY}"
sleep "${INITIAL_DELAY:-2m}"

while true
do
	backup_world
	sleep $"BACKUP_INTERVAL"
done

