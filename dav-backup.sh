#!/bin/bash

# getting config
source "${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/config"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/credentials"

if [[ ! -w $OUT/ ]]; then
	echo "Error: unable to write into directory '${OUT}'!"
	exit 1
fi

# create empty tarpackage
tar cfT "$OUT/DAV-$DATE.tar.gz" /dev/null

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

for addr in $ADDRESSBOOK; do
	wget -q \
		-O $OUT/${addr}-$DATE.vcf \
		$HOST/$CARDURL/$DAVUSER/$addr?export
	
	if [ -s $OUT/$addr-$DATE.vcf ]; then
		echo "$addr successfully downloaded"
	else
		echo "unknwon error"
		rm $OUT/$addr-$DATE.vcf
		exit $?
	fi

	tar r -C $OUT -f $OUT/DAV-$DATE.tar.gz $addr-$DATE.vcf
	rm $OUT/$addr-$DATE.vcf
done

for cal in $CALENDAR; do
	wget -q \
		-O $OUT/$cal-$DATE.ics \
		$HOST/$CALURL/$DAVUSER/$cal?export
	
	if [ -s $OUT/$cal-$DATE.ics ]; then
		echo "$cal successfully downloaded"
	else
		echo "unknwon error"
		rm $OUT/$cal-$DATE.ics
		exit $?
	fi

	tar r -C $OUT -f $OUT/DAV-$DATE.tar.gz $cal-$DATE.ics
	rm $OUT/$cal-$DATE.ics
done
