#!/bin/bash
if [ $(id -u) != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

trap exit SIGINT

if [ ! -d '/usr/portage/packages/s/signatures/' ]; then
	mkdir -p /usr/portage/packages/s/signatures/
fi

export BINPKG_COMPRESS="xz" XZ_OPT="--x86 --lzma2=preset=9e,dict=1024MB,nice=273,depth=200,lc=4"

if [ "$1" = 'deep' ]; then
	find /usr/portage/packages/ -mindepth 1 -maxdepth 1 ! -name s -exec rm -Rf {} \;
	emerge -C hwinfo ntfs3g ; emerge ntfs3g ; emerge hwinfo ; emerge -C sys-apps/dbus obs-studio ; emerge obs-studio ; emerge -1 sys-apps/dbus ; emerge -C jack-audio-connection-kit audacity ; emerge audacity ; emerge jack-audio-connection-kit
	quickpkg --include-unmodified-config=y "*/*" 2>&1 | ansi2html > /usr/portage/packages/s/quickpkg.html
	emerge -B sudo openssh postfix dcron vixie-cron cronie fcron anacron
fi

emerge --sync
layman -S
emerge -uavDNb --exclude=gentoo-sources @world
emerge -1b --exclude=palemoon $(find /var/db/pkg/ -mindepth 2 -maxdepth 2 -name \*-9999\* | awk -F \/ '{printf "=%s/%s ", $5, $6}')
emerge -b @preserved-rebuild
emerge --depclean

[[ $(stat -c \%Y /usr/portage/packages/dev-libs/glib*) -gt $(stat -c \%Y /usr/portage/packages/s/nodbus/dev-libs/glib*) ]] && PKGDIR="/usr/portage/packages/s/nodbus/" USE="-dbus -webengine" emerge -B glib qtgui PyQt5

php mirrors/index.php > /usr/portage/packages/index.html
./mirrors/indexalt.sh > /usr/portage/packages/indexalt.html
EIX_LIMIT=0 eix -IF | grep -v "Available versions" | ansi2html > /usr/portage/packages/s/packages.html &

rm -Rf /usr/portage/packages/s/signatures/*
find /usr/portage/packages/ -type d -not -path "/usr/portage/packages/s/signatures*" | sed "s#/usr/portage/packages/##" | xargs -I{} mkdir /usr/portage/packages/s/signatures/{}
find /usr/portage/packages/ -type f -not -path "/usr/portage/packages/s/signatures*" | sed "s#/usr/portage/packages/##" | xargs -P 8 -I{} gpg --armor --detach-sign --output /usr/portage/packages/s/signatures/{}.asc --sign /usr/portage/packages/{}

chmod -R 755 /usr/portage/packages/
rsync -a --delete /usr/portage/packages/ root@nl.cloveros.ga:/var/www/html/cloveros.ga/
