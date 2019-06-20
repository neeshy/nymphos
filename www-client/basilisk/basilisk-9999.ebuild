# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit check-reqs flag-o-matic toolchain-funcs eutils gnome2-utils multilib pax-utils desktop xdg-utils basilisk

DESCRIPTION="Basilisk Web Browser"
HOMEPAGE="https://www.basilisk-browser.org/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MoonchildProductions/UXP.git"
else
	SRC_URI="https://github.com/MoonchildProductions/UXP/archive/v${PV}.tar.gz -> UXP-${PV}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/UXP-${PV}"
fi

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
IUSE="
	bindist +official-branding
	debug test
	hardened selinux
	custom-cflags custom-optimization pie pgo gold +threads +jemalloc
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_ssse3
	+gtk2 -gtk3
	+minimal +devtools -eme -webrtc -gamepad -webspeech -accessibility
	dbus gnome gio startup-notification wifi
	alsa pulseaudio jack
	system-bzip2 system-cairo system-ffi system-hunspell system-hyphen
	system-icu system-jpeg system-libevent system-libvpx system-nspr
	system-nss system-pixman system-png system-sqlite system-zlib
"

REQUIRED_USE="
	^^ ( gtk2 gtk3 )
	wifi? ( dbus )
	cpu_flags_x86_sse? ( custom-optimization )
	cpu_flags_x86_sse2? ( custom-optimization )
	cpu_flags_x86_ssse3? ( custom-optimization )
	official-branding? (
		bindist? (
			!system-bzip2 !system-cairo !system-ffi !system-hunspell !system-hyphen
			!system-icu !system-jpeg !system-libevent !system-libvpx !system-nspr
			!system-nss !system-pixman !system-png !system-sqlite !system-zlib
		)
	)
"

RESTRICT="!bindist? ( bindist ) mirror"

RDEPEND="
	dev-libs/expat
	>=x11-libs/cairo-1.10[X]
	gtk2? (
		!gio? ( >=x11-libs/gtk+-2.10:2 )
		gio? ( >=x11-libs/gtk+-2.18:2 )
	)
	gtk3? ( >=x11-libs/gtk+-3.4.0:3 )
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	jack? ( virtual/jack )
	virtual/freedesktop-icon-theme
	dbus? (
		>=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.60
	)
	gnome? ( gnome-base/gconf )
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	wifi? ( net-wireless/wireless-tools )
	>=dev-libs/glib-2.26:2
	virtual/ffmpeg[x264]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	selinux? ( sec-policy/selinux-mozilla )
	system-bzip2? ( app-arch/bzip2 )
	system-cairo? ( >=x11-libs/cairo-1.12[X,xcb] )
	system-ffi? ( >=virtual/libffi-3.0.10 )
	system-hunspell? ( >=app-text/hunspell-1.2:= )
	system-hyphen? ( dev-libs/hyphen )
	system-icu? ( >=dev-libs/icu-58.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0=[threads] )
	system-libvpx? ( >=media-libs/libvpx-1.5.0:0=[postproc] )
	system-nspr? ( >=dev-libs/nspr-4.13.1 )
	system-nss? ( >=dev-libs/nss-3.28.3 )
	system-pixman? ( >=x11-libs/pixman-0.19.2 )
	system-png? ( >=media-libs/libpng-1.6.25:0=[apng] )
	system-sqlite? ( >=dev-db/sqlite-3.17.0:3[secure-delete,debug=] )
	system-zlib? ( >=sys-libs/zlib-1.2.3 )
"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.13:2.1
	virtual/pkgconfig
	dev-lang/python:2.7
	>=dev-lang/perl-5.6
	app-arch/zip
	app-arch/unzip
	>=sys-devel/binutils-2.16.1
	sys-apps/findutils
	>=dev-lang/yasm-1.1
	virtual/opengl
	pgo? ( >=sys-devel/gcc-4.5 )
"

pkg_setup() {
	# Nested configure scripts in mozilla products generate unrecognized
	# options false positives when toplevel configure passes downwards:
	export QA_CONFIGURE_OPTIONS=".*"

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
	unset DBUS_SESSION_BUS_ADDRESS \
		DISPLAY \
		ORBIT_SOCKETDIR \
		SESSION_MANAGER \
		XDG_SESSION_COOKIE \
		XAUTHORITY

	if use official-branding && ! use bindist; then
		einfo
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation and Moonchild Productions"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
	fi

	if use pgo; then
		einfo
		ewarn "You will do a double build for profile guided optimization."
		ewarn "This will result in your build taking at least twice as long as before."
	fi
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use pgo || use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi
	check-reqs_pkg_setup
}

src_configure() {
	# Basic configuration:
	mozconfig_init

	mozconfig_enable release
	mozconfig_disable updater maintenance-service \
		stylo servo webextensions

	if use official-branding; then
		mozconfig_export MOZILLA_OFFICIAL 1
		mozconfig_enable official-branding
		use bindist || mozconfig_enable private-build
	fi

	# Remove anti-features
	if use minimal; then
		mozconfig_export MOZ_DATA_REPORTING 0
		mozconfig_export MOZ_TELEMETRY_REPORTING 0
		mozconfig_export MOZ_SERVICES_HEALTHREPORT 0

		mozconfig_disable crashreporter \
			parental-controls \
			safe-browsing \
			sync \
			b2g-camera b2g-ril b2g-bt \
			mozril-geoloc \
			nfc \
			url-classifier \
			userinfo
	fi

	# Flags for system libraries
	mozconfig_use_with system-nspr
	mozconfig_use_with system-nss
	mozconfig_use_with system-icu
	mozconfig_use_with system-zlib
	mozconfig_use_with system-bzip2 system-bz2
	mozconfig_use_with system-libevent
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-png
	mozconfig_use_with system-libvpx
	mozconfig_use_enable system-sqlite
	mozconfig_use_enable system-cairo
	mozconfig_use_enable system-pixman
	mozconfig_use_enable system-ffi
	mozconfig_use_enable system-hunspell

	# Feature USE-flags
	mozconfig_use_enable devtools
	mozconfig_use_enable eme
	mozconfig_use_enable webrtc
	mozconfig_use_enable gamepad
	mozconfig_use_enable webspeech webspeech webspeechtestbackend \
		synth-speechd synth-pico
	mozconfig_use_enable accessibility

	# Widget toolkit backends
	use gtk2 && mozconfig_enable default-toolkit=cairo-gtk2
	use gtk3 && mozconfig_enable default-toolkit=cairo-gtk3

	# Graphical backend
	# WARNING: experimental; see Gentoo bug 571180
	#mozconfig_use_with egl gl-provider=EGL

	# Audio backends
	mozconfig_use_enable alsa
	mozconfig_use_enable pulseaudio
	mozconfig_use_enable jack

	# Desktop integration
	mozconfig_use_enable dbus
	mozconfig_use_enable gnome gconf
	mozconfig_use_enable gio
	mozconfig_use_enable wifi necko-wifi
	mozconfig_use_enable startup-notification

	# Debugging build options
	mozconfig_use_enable debug debug tests
	if use debug; then
		mozconfig_var MOZ_DEBUG_SYMBOLS 1
		mozconfig_enable debug-symbols=-gdwarf-2
	else
		mozconfig_var MOZ_DEBUG_SYMBOLS 0
		mozconfig_disable debug-symbols
	fi

	# Optimization/performance USE-flags
	mozconfig_enable strip install-strip
	mozconfig_use_enable gold
	mozconfig_use_enable pie
	mozconfig_use_enable jemalloc jemalloc replace-malloc
	mozconfig_use_with threads pthreads

	if use custom-optimization; then
		local optimization
		# Set optimization level based on CFLAGS
		if is-flag -O0; then
			optimization="-O0"
		elif is-flag -O4; then
			optimization="-O4"
		elif is-flag -O3; then
			optimization="-O3"
		elif is-flag -O1; then
			optimization="-O1"
		elif is-flag -Os; then
			optimization="-Os"
		else
			# Gentoo's default optimization
			optimization="-O2"
		fi

		use cpu_flags_x86_sse && optimization="${optimization} -msse"
		use cpu_flags_x86_sse2 && optimization="${optimization} -msse2"
		use cpu_flags_x86_ssse3 && optimization="${optimization} -mssse3"
		if use cpu_flags_x86_sse || cpu_flags_x86_sse2; then
			optimization="${optimization} -mfpmath=both"
		fi

		mozconfig_enable "optimize=\"${optimization}\""
	else
		# Enable Mozilla's default
		mozconfig_enable optimize
	fi

	# Strip optimization so it does not end up in compile string
	filter-flags '-O*' '-msse' '-msse2' '-mssse3' '-mfpmath=*'

	# Strip over-aggressive CFLAGS
	use custom-cflags || strip-flags

	# Allow for a proper pgo build
	if use pgo; then
		mozconfig_export MOZ_PGO 1
		mozconfig_var PROFILE_GEN_SCRIPT \
			"'EXTRA_TEST_ARGS=10 \$(MAKE) -C \$(MOZ_OBJDIR) pgo-profile-run'"
	fi

	# We need to append flags for gcc-6 support
	if [[ "$(gcc-major-version)" -ge 6 ]]; then
		append-cxxflags -fno-delete-null-pointer-checks -fno-lifetime-dse -fno-schedule-insns2
	fi

	# Add full relro support for hardened
	use hardened && append-ldflags "-Wl,-z,relro,-z,now"

	# Prevents portage from setting its own XARGS which messes with the
	# Pale Moon build system checks:
	# See: https://gitweb.gentoo.org/proj/portage.git/tree/bin/isolated-functions.sh
	mozconfig_var XARGS "$(which xargs)"
	mozconfig_var PYTHON "$(which python2)"
	mozconfig_var AUTOCONF "$(which autoconf-2.13)"
	mozconfig_var MOZ_MAKE_FLAGS "\"${MAKEOPTS}\""
	mozconfig_export MOZBUILD_STATE_PATH "${WORKDIR}/mach_state"

	# Shorten obj dir to limit some errors linked to the path size hitting
	# a kernel limit (127 chars):
	mozconfig_var MOZ_OBJDIR "@TOPSRCDIR@/o"

	# Disable mach notifications, which also cause sandbox access violations:
	mozconfig_export MOZ_NOSPAM 1

	# Apply EXTRA_ECONF entries to .mozconfig
	if [[ -n "${EXTRA_ECONF}" ]]; then
		local ac
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig "--${opt#--}"
		done
	fi

	if [[ "$(gcc-major-version)" -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	./mach configure || die
}

src_compile() {
	if use pgo; then
		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root
		addpredict /etc/gconf
	fi

	./mach build --verbose || die
}

src_install() {
	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${S}/o/dist/bin/xpcshell"

	DESTDIR="${D}" ./mach install || die

	local mozhome="/usr/lib/${PN}-$(< application/${PN}/config/version.txt)"

	# Use system-provided dictionaries
	if use system-hunspell; then
		rm -rf "${D}${mozhome}/dictionaries"
		dosym /usr/share/hunspell "${mozhome}/dictionaries"
	fi
	if use system-hyphen; then
		rm -rf "${D}${mozhome}/hyphenation"
		dosym /usr/share/hyphen "${mozhome}/hyphenation"
	fi

	# Replace duplicate binary with symlink
	# https://bugzilla.mozilla.org/show_bug.cgi?id=658850
	rm -f "${D}${mozhome}/${PN}-bin"
	dosym "${PN}" "${mozhome}/${PN}-bin"

	local size sizes icon_path icon name
	if use official-branding; then
		sizes="16 22 24 32 64 48 256"
		icon_path="${S}/application/${PN}/branding/official"
		icon="${PN}"
		name="Basilisk"
	else
		sizes="16 32 48"
		icon_path="${S}/application/${PN}/branding/unofficial"
		icon="serpent"
		name="Serpent"
	fi

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${icon}.png"
	done
	# The 128x128, 192x192, and 384x384 icons have different names
	insinto /usr/share/icons/hicolor/128x128/apps
	newins "${icon_path}/mozicon128.png" "${icon}.png"
	insinto /usr/share/icons/hicolor/192x192/apps
	newins "${icon_path}/content/about-logo.png" "${icon}.png"
	insinto /usr/share/icons/hicolor/384x384/apps
	newins "${icon_path}/content/about-logo@2x.png" "${icon}.png"
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}/content/icon48.png" "${icon}.png"

	newmenu "${S}/application/palemoon/branding/official/palemoon.desktop" "${icon}.desktop"
	sed -i -e "s:Pale Moon:${name}:" -e "s:palemoon:basilisk:" \
		-e "s@https://start.palemoon.org@about:newtab@" \
		"${D}/usr/share/applications/${icon}.desktop" || die

	# Required in order to use plugins and even run basilisk on hardened.
	pax-mark m "${D}${mozhome}"/{basilisk,plugin-container}
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
