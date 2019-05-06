# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

REQUIRED_BUILDSPACE='9G'

inherit mozilla eutils flag-o-matic desktop

DESCRIPTION="Basilisk Web Browser"
HOMEPAGE="https://www.basilisk-browser.org/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MoonchildProductions/UXP.git"
else
	SRC_URI="https://github.com/MoonchildProductions/UXP/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
IUSE="
	+official-branding
	-private-build
	-official-build
	bindist
	+privacy
	+optimize cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_ssse3
	debug -valgrind +jemalloc threads
	gold
	+pie
	+alsa
	dbus
	startup-notification
	-pgo
	-stylo
	-necko-wifi
	-webrtc
	-gamepad
	-webspeech
	-accessibility
	+gtk2 -gtk3
	pulseaudio
	jack
	+devtools
	gnome
	-system-nspr -system-nss -system-icu -system-hunspell -system-hyphen
	-system-ffi -system-sqlite -system-cairo -system-pixman -system-libevent
	-system-libvpx -system-zlib -system-bzip2 -system-jpeg -system-png
"

RESTRICT="mirror"

RDEPEND="
	app-arch/zip
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/fontconfig
	virtual/ffmpeg[x264]
	x11-libs/libXt

	optimize? ( sys-libs/glibc )
	pgo? ( >=sys-devel/gcc-4.5 )
	valgrind? ( dev-util/valgrind )

	dbus? (
		>=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.60
	)

	gnome? ( gnome-base/gconf )

	gtk2? ( >=x11-libs/gtk+-2.18.0:2 )
	gtk3? ( >=x11-libs/gtk+-3.4.0:3 )

	pulseaudio? ( media-sound/pulseaudio )
	jack? ( virtual/jack )

	startup-notification? ( x11-libs/startup-notification )

	necko-wifi? ( net-wireless/wireless-tools )

	system-nspr? ( dev-libs/nspr )
	system-nss? ( >=dev-libs/nss-3.28.3 )
	system-icu? ( dev-libs/icu )
	system-cairo? ( x11-libs/cairo )
	system-zlib?  ( >=sys-libs/zlib-1.2.3 )
	system-bzip2? ( app-arch/bzip2 )
	system-jpeg? ( media-libs/libjpeg-turbo )
	system-png? ( media-libs/libpng:*[apng] )
	system-libevent? ( dev-libs/libevent )
	system-pixman? ( x11-libs/pixman )
	system-sqlite? ( >=dev-db/sqlite-3.13.0[secure-delete] )
	system-libvpx? ( >=media-libs/libvpx-1.5.0 )
	system-ffi? ( virtual/libffi )
	system-hunspell? ( app-text/hunspell )
	system-hyphen? ( dev-libs/hyphen )
"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.13:2.1
	dev-lang/python:2.7
	>=dev-lang/perl-5.6
	dev-lang/yasm
"

REQUIRED_USE="
	optimize? ( !debug )
	jemalloc? ( !valgrind )
	^^ ( gtk2 gtk3 )
	necko-wifi? ( dbus )
	?? ( private-build official-build )
	private-build? ( official-branding !bindist )
	official-build? (
		official-branding
		!system-nspr !system-nss !system-icu !system-hunspell !system-hyphen
		!system-ffi !system-sqlite !system-cairo !system-pixman !system-libevent
		!system-libvpx !system-zlib !system-bzip2 !system-jpeg !system-png
	)
"

src_configure() {
	# Basic configuration:
	pozconfig_init

	pozconfig_enable release
	pozconfig_disable updater maintenance-service

	pozconfig_export MOZ_ADDON_SIGNING 1
	pozconfig_export MOZ_REQUIRE_SIGNING 0

	pozconfig_use_enable official-branding
	if use official-branding; then
		pozconfig_export MOZILLA_OFFICIAL 1
	fi

	pozconfig_use_enable private-build

	if use privacy; then
		pozconfig_export MOZ_DATA_REPORTING 0
		pozconfig_export MOZ_TELEMETRY_REPORTING 0
		pozconfig_export MOZ_CRASHREPORTER 0
		pozconfig_export MOZ_SERVICES_HEALTHREPORT 0

		pozconfig_disable eme
		pozconfig_disable parental-controls
		pozconfig_disable crashreporter
		pozconfig_disable safe-browsing
		pozconfig_disable b2g-camera b2g-ril b2g-bt
		pozconfig_disable mozril-geoloc
		pozconfig_disable nfc
		pozconfig_disable url-classifier
		pozconfig_disable userinfo
	fi

	# system-* flags
	pozconfig_use_with system-nspr
	pozconfig_use_with system-nss
	pozconfig_use_with system-icu
	pozconfig_use_with system-zlib
	pozconfig_use_with system-bzip2 system-bz2
	pozconfig_use_with system-libevent
	pozconfig_use_with system-jpeg
	pozconfig_use_with system-png
	pozconfig_use_with system-libvpx
	pozconfig_use_enable system-sqlite
	pozconfig_use_enable system-cairo
	pozconfig_use_enable system-pixman
	pozconfig_use_enable system-ffi
	pozconfig_use_enable system-hunspell

	# Common flags
	pozconfig_enable strip install-strip
	pozconfig_use_enable gold
	pozconfig_use_enable pie
	pozconfig_use_enable jemalloc
	pozconfig_use_enable valgrind
	pozconfig_use_with threads pthreads

	if use optimize; then
		local O="-O2"
		if use cpu_flags_x86_ssse3; then
			O="${O} -mssse3 -mfpmath=both"
		elif use cpu_flags_x86_sse && use cpu_flags_x86_sse2; then
			O="${O} -msse2 -mfpmath=sse"
		elif use cpu_flags_x86_sse; then
			O="${0} -msse -mfpmath=sse"
		fi
		pozconfig_enable "optimize=\"${O}\""
		#filter-flags '-O*' '-msse2' '-mssse3' '-mfpmath=*'
	else
		pozconfig_disable optimize
	fi

	if use pgo; then
		pozconfig_export MOZ_PGO 1
		pozconfig_var PROFILE_GEN_SCRIPT \
			"'EXTRA_TEST_ARGS=10 \$(MAKE) -C \$(MOZ_OBJDIR) pgo-profile-run'"
	fi

	if use debug; then
		pozconfig_var MOZ_DEBUG_SYMBOLS 1
		pozconfig_enable debug-symbols=\"-gdwarf-2\"
	fi
	pozconfig_use_enable debug debug debug-symbols tests

	pozconfig_use_enable alsa
	pozconfig_use_enable pulseaudio
	pozconfig_use_enable jack
	pozconfig_use_enable dbus
	pozconfig_use_enable gnome gconf
	pozconfig_use_enable necko-wifi
	pozconfig_use_enable startup-notification

	pozconfig_use_enable stylo
	pozconfig_use_enable webrtc
	pozconfig_use_enable gamepad
	pozconfig_use_enable devtools

	pozconfig_use_enable webspeech webspeech webspeechtestbackend synth-speechd synth-pico
	pozconfig_use_enable accessibility

	if use gtk2; then
		pozconfig_enable default-toolkit=\"cairo-gtk2\"
	fi

	if use gtk3; then
		pozconfig_enable default-toolkit=\"cairo-gtk3\"
	fi

	# Prevents portage from setting its own XARGS which messes with the
	# Pale Moon build system checks:
	# See: https://gitweb.gentoo.org/proj/portage.git/tree/bin/isolated-functions.sh
	pozconfig_var XARGS "$(which xargs)"
	pozconfig_var PYTHON "$(which python2)"
	pozconfig_var AUTOCONF "$(which autoconf-2.13)"
	pozconfig_var MOZ_MAKE_FLAGS "\"${MAKEOPTS}\""
	pozconfig_export MOZBUILD_STATE_PATH "${WORKDIR}/mach_state"

	# Shorten obj dir to limit some errors linked to the path size hitting
	# a kernel limit (127 chars):
	pozconfig_var MOZ_OBJDIR "@TOPSRCDIR@/o"

	# Disable mach notifications, which also cause sandbox access violations:
	pozconfig_export MOZ_NOSPAM 1
}

src_compile() {
	# Reset and cleanup environment variables used by GNOME/XDG
	gnome2_environment_reset

	python2 mach build || die
}

src_install() {
	DESTDIR="${D}" python2 mach install || die

	local ver="$(< application/${PN}/config/version.txt)"
	if use system-hunspell; then
		rm -rf "${D}/usr/lib/${PN}-${ver}/dictionaries"
		dosym /usr/share/hunspell "/usr/lib/${PN}-${ver}/dictionaries"
	fi

	if use system-hyphen; then
		rm -rf "${D}/usr/lib/${PN}-${ver}/hyphenation"
		dosym /usr/share/hyphen "/usr/lib/${PN}-${ver}/hyphenation"
	fi

	# https://bugzilla.mozilla.org/show_bug.cgi?id=658850
	rm -f "${D}/usr/lib/${PN}-${ver}/${PN}-bin"
	dosym "${PN}" "/usr/lib/${PN}-${ver}/${PN}-bin"

	local size sizes icon_path
	if use official-branding; then
		icon_path="${S}/application/${PN}/branding/official"
		sizes="16 22 24 32 64 48 256"
	else
		icon_path="${S}/application/${PN}/branding/unofficial"
		sizes="16 32 48"
	fi
	for size in $sizes; do
	    insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
	    newins "${icon_path}/default${size}.png" "${PN}.png"
	done

	# The 128x128, 192x192, and 384x384 icons have different names:
	insinto /usr/share/icons/hicolor/128x128/apps
	newins "${icon_path}/mozicon128.png" "${PN}.png"
	insinto /usr/share/icons/hicolor/192x192/apps
	newins "${icon_path}/content/about-logo.png" "${PN}.png"
	insinto /usr/share/icons/hicolor/384x384/apps
	newins "${icon_path}/content/about-logo@2x.png" "${PN}.png"

	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}/default48.png" "${PN}.png"

	# Install a menu entry
	domenu "${FILESDIR}/${PN}.desktop"
}
