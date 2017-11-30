#!/bin/bash

# getting config
source "${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/config"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/credentials"

if [[ ! -w "$OUT/" ]]; then
	echo "Error: unable to write into directory '${OUT}'!"
	exit 1
fi

# create empty tarpackage
tar cfT "$OUT/DAV-$DATE.tar.gz" /dev/null

case "$SERVICE" in
	"owncloud" )
		CARDURL="$HOST/remote.php/carddav/addressbooks/$DAVUSER/%s?export"
		CALURL="$HOST/remote.php/caldav/calendars/$DAVUSER/%s?export"
		;;
	"baikal" )
		CARDURL="$HOST/dav.php/addressbooks/$DAVUSER/%s?export"
		CALURL="$HOST/dav.php/calendars/$DAVUSER/%s?export"
		;;
	*)
		echo "Unknown Service"
		exit 1
esac

for addr in "${ADDRESSBOOKS[@]}"; do

	IFS=: read id name <<< "${addr}"
	[ -n "${name}" ] || name="${id}"

	wget -q \
		-O "$OUT/${name}-$DATE.vcf" \
		"$(printf "${CARDURL}" "${id}")"
	
	if [ -s "$OUT/$name-$DATE.vcf" ]; then
		echo "$name successfully downloaded"
	else
		echo "unknwon error"
		rm "$OUT/$name-$DATE.vcf"
		exit $?
	fi

	tar r -C "$OUT" -f "$OUT/DAV-$DATE.tar.gz" "$name-$DATE.vcf"
	rm "$OUT/$name-$DATE.vcf"
done

for cal in "${CALENDARS[@]}"; do

	IFS=: read id name <<< "${cal}"
	[ -n "${name}" ] || name="${id}"

	wget -q \
		-O "$OUT/$name-$DATE.ics" \
		"$(printf "${CALURL}" "${id}")"
	
	if [ -s "$OUT/$name-$DATE.ics" ]; then
		echo "$name successfully downloaded"
	else
		echo "unknwon error"
		rm "$OUT/$name-$DATE.ics"
		exit $?
	fi

	tar r -C "$OUT" -f "$OUT/DAV-$DATE.tar.gz" "$name-$DATE.ics"
	rm "$OUT/$name-$DATE.ics"
done
