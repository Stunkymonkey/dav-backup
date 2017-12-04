#!/bin/bash

die() { echo "$*" >&2; exit 1; }

# download first argument and put with filename of argument two into archive
download(){

	url="${1?No URL given to download.}"
	file="${2?No filename given to save.}"

	wget -q \
		-O "$OUT/${file}" \
		"${url}"

	if [ -s "$OUT/$file" ]; then
		echo "SUCCESS: $file"
	else
		die "Unknown Error at '${file}'!"
	fi

	tar r -C "$OUT" -f "$OUT/DAV-$DATE.tar.gz" "${file}"
	rm "$OUT/${file}"
}

# getting config
source "${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/config"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/dav-backup/credentials"

if [[ ! -w "$OUT/" ]]; then
	die "Error: unable to write into directory '${OUT}'!"
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
	"radicale" )
		CARDURL="$HOST/$DAVUSER/%s"
		CALURL="${CARDURL}"
		;;
	*)
		die "Unknown Service"
esac

for addr in "${ADDRESSBOOKS[@]}"; do

	IFS=: read id name <<< "${addr}"
	[ -n "${name}" ] || name="${id}"

	download "$(printf "${CARDURL}" "${id}")" "${name}-$DATE.vcf"
done

for cal in "${CALENDARS[@]}"; do

	IFS=: read id name <<< "${cal}"
	[ -n "${name}" ] || name="${id}"

	download "$(printf "${CALURL}" "${id}")" "$name-$DATE.ics"
done
