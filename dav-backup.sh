#!/bin/bash

if [[ ! -w ./ ]]; then
	echo "Error: unable to write in directory"
	exit 1
fi

# getting config
source ./config

echo "$PASSWORD"

tar cfT OC-$DATE.tar.gz /dev/null

if [[ -z "$PASSWORD" ]]; then
	echo -n "Enter host password for user '$OCUSER':"
	read -s PASSWORD
fi

for i in $ADDRESSBOOK; do
	wget --user="$OCUSER" --password="$PASSWORD" --no-check-certificate --recursive -nv -O $i-$DATE.vcf $HOST/remote.php/carddav/addressbooks/$OCUSER/$i?export
	
	if [ -s $i-$DATE.vcf ]; then
		echo "$i successfully downloaded"
	else
		echo "unknwon error"
		exit $?
	fi

	tar rvf OC-$DATE.tar.gz $i-$DATE.vcf
	rm $i-$DATE.vcf
done

for j in $CALENDAR; do
	wget --user="$OCUSER" --password="$PASSWORD" --no-check-certificate --recursive -nv -O $j-$DATE.ics $HOST/remote.php/caldav/calendars/$OCUSER/$j?export
	
	if [ -s $j-$DATE.ics ]; then
		echo "$j successfully downloaded"
	else
		echo "unknwon error"
		exit $?
	fi

	tar rvf OC-$DATE.tar.gz $j-$DATE.ics
	rm $j-$DATE.ics
done

unset PASSWORD
