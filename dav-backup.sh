#!/bin/bash

if [[ ! -w ./ ]]; then
	echo "Error: unable to write in directory"
	exit 1
fi

# getting config
source "${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/config"

tar cfT DAV-$DATE.tar.gz /dev/null

case "$SERVICE" in
	"owncloud" )
		CARDURL="remote.php/carddav/addressbooks"
		CALURL="remote.php/caldav/calendars"
		;;
	"baikal" )
		CARDURL="dav.php/addressbooks"
		CALURL="dav.php/calendars"
		;;
	*)
		echo "Unknown Service"
		exit 1
esac

if [[ -z "$PASSWORD" ]]; then
	echo -n "Enter host password for user '$DAVUSER':"
	read -s PASSWORD
fi


for addr in $ADDRESSBOOK; do
	wget --user="$DAVUSER" --password="$PASSWORD" --no-check-certificate --recursive -q -O ${addr}-$DATE.vcf $HOST/$CARDURL/$DAVUSER/$addr?export
	
	if [ -s $addr-$DATE.vcf ]; then
		echo "$addr successfully downloaded"
	else
		echo "unknwon error"
		rm $addr-$DATE.vcf
		exit $?
	fi

	tar rvf DAV-$DATE.tar.gz $addr-$DATE.vcf
	rm $addr-$DATE.vcf
done

for cal in $CALENDAR; do
	wget --user="$DAVUSER" --password="$PASSWORD" --no-check-certificate --recursive -q -O $cal-$DATE.ics $HOST/$CALURL/$DAVUSER/$cal?export
	
	if [ -s $cal-$DATE.ics ]; then
		echo "$cal successfully downloaded"
	else
		echo "unknwon error"
		rm $cal-$DATE.ics
		exit $?
	fi

	tar rvf DAV-$DATE.tar.gz $cal-$DATE.ics
	rm $cal-$DATE.ics
done

unset PASSWORD
