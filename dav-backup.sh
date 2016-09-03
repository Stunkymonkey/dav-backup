#!/bin/bash

if [[ ! -w ./ ]]; then
	echo "Error: unable to write in directory"
	exit 1
fi

# getting config
source ./config

tar cfT OC-$DATE.tar.gz /dev/null

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


for i in $ADDRESSBOOK; do
	wget --user="$DAVUSER" --password="$PASSWORD" --no-check-certificate --recursive -q -O $i-$DATE.vcf $HOST/$CARDURL/$DAVUSER/$i?export
	
	if [ -s $i-$DATE.vcf ]; then
		echo "$i successfully downloaded"
	else
		echo "unknwon error"
		rm $i-$DATE.vcf
		exit $?
	fi

	tar rvf OC-$DATE.tar.gz $i-$DATE.vcf
	rm $i-$DATE.vcf
done

for j in $CALENDAR; do
	wget --user="$DAVUSER" --password="$PASSWORD" --no-check-certificate --recursive -q -O $j-$DATE.ics $HOST/$CALURL/$DAVUSER/$j?export
	
	if [ -s $j-$DATE.ics ]; then
		echo "$j successfully downloaded"
	else
		echo "unknwon error"
		rm $j-$DATE.ics
		exit $?
	fi

	tar rvf OC-$DATE.tar.gz $j-$DATE.ics
	rm $j-$DATE.ics
done

unset PASSWORD
