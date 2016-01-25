#!/bin/bash

# getting config
source ./config

echo -n "Enter host password for user '$OCUSER':"
read -s PASSWORD

wget --user="$OCUSER" --password="$PASSWORD" --no-check-certificate --no-clobber -O $ADDRESSBOOK-$DATE.vcf \
	$HOST/remote.php/carddav/addressbooks/$OCUSER/$ADDRESSBOOK?export

wget --user="$OCUSER" --password="$PASSWORD" --no-check-certificate --no-clobber -O $CALENDAR-$DATE.ics \
	$HOST/remote.php/caldav/calendars/$OCUSER/$CALENDAR?export

if [ -s $CALENDAR-$DATE.ics -a -s $ADDRESSBOOK-$DATE.vcf ]
then
	tar cfvz OC-$DATE.tar.gz ./$ADDRESSBOOK-$DATE.vcf ./$CALENDAR-$DATE.ics
else
	echo "wrong password"
fi

rm $CALENDAR-$DATE.ics
rm $ADDRESSBOOK-$DATE.vcf

unset PASSWORD