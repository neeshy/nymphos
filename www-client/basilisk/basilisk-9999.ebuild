# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

REQUIRED_BUILDSPACE='9G'
GCC_SUPPORTED_VERSIONS="4.9 5.4 7.3 8.2 8.3"

inherit basilisk git-r3 eutils flag-o-matic pax-utils

DESCRIPTION="Basilisk Web Browser"
HOMEPAGE="https://www.basilisk-browser.org/"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="
	+official-branding
	-optimize-with-cflags
	+privacy
	+optimize cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_ssse3
	debug -valgrind +shared-js +jemalloc threads
	gold
	+pie
	+alsa
	dbus
	-pgo
	-stylo
	-necko-wifi
	-webrtc
	-gamepad
	-webspeech
	-accessibility
	+gtk2 -gtk3
	pulseaudio
	+devtools
	+gconf
	-system-nspr -system-icu -system-hunspell -system-ffi
	-system-sqlite -system-cairo -system-pixman -system-libevent
	-system-vpx -system-compress -system-images -system-nss
"

EGIT_REPO_URI="https://github.com/MoonchildProductions/UXP.git"

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="Basilisk-release"
	KEYWORDS=""
else
	GIT_TAG="PM${PV}_Release"
	KEYWORDS="~amd64 ~x86"
	src_unpack() {
		git-r3_fetch ${EGIT_REPO_URI} refs/tags/${GIT_TAG}
		git-r3_checkout
	}
fi

RESTRICT="mirror"

DEPEND="
	>=sys-devel/autoconf-2.13:2.1
	dev-lang/python:2.7
	>=dev-lang/perl-5.6
	dev-lang/yasm
"

RDEPEND="
	app-arch/zip
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/fontconfig
	virtual/ffmpeg[x264]
	x11-libs/libXt

	optimize? ( sys-libs/glibc )
	valgrind? ( dev-util/valgrind )
	shared-js? ( virtual/libffi )

	dbus?
	(
		>=sys-apps/dbus-0.60
		>=dev-libs/dbus-glib-0.60
	)

	gconf? ( gnome-base/gconf )

	gtk2? ( >=x11-libs/gtk+-2.18.0:2 )
	gtk3? ( >=x11-libs/gtk+-3.4.0:3 )

	pulseaudio? ( media-sound/pulseaudio )

	necko-wifi? ( net-wireless/wireless-tools )

	system-cairo? ( x11-libs/cairo )
	system-compress?
	(
		>=sys-libs/zlib-1.2.3
		app-arch/bzip2
	)
	system-images?
	(
		media-libs/libjpeg-turbo
		media-libs/libpng:*[apng]
	)
	system-libevent? ( dev-libs/libevent )
	system-nss? ( >=dev-libs/nss-3.28.3 )
	system-pixman? ( x11-libs/pixman )
	system-sqlite? ( >=dev-db/sqlite-3.13.0[secure-delete] )
	system-vpx? ( >=media-libs/libvpx-1.5.0 )
	system-ffi? ( dev-ruby/ffi )
	system-nspr? ( dev-libs/nspr )
	system-hunspell? ( app-text/hunspell )
	system-icu? ( dev-libs/icu )
"

REQUIRED_USE="
	optimize? ( !debug )
	jemalloc? ( !valgrind )
	^^ ( gtk2 gtk3 )
	necko-wifi? ( dbus )
"

src_prepare() {
	# Ensure that our plugins dir is enabled by default:
	#sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
	#	"${S}/xpcom/io/nsAppFileLocationProvider.cpp" \
	#	|| die "sed failed to replace plugin path for 32bit!"
	#sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
	#	"${S}/xpcom/io/nsAppFileLocationProvider.cpp" \
	#	|| die "sed failed to replace plugin path for 64bit!"

	default
}

src_configure() {
	# Basic configuration:
	mozconfig_init

	mozconfig_enable release strip

	mozconfig_disable updater install-strip

	if use privacy; then
		mozconfig_disable eme
		mozconfig_disable parental-controls
		mozconfig_disable safe-browsing
		mozconfig_disable b2g-camera
		mozconfig_disable b2g-ril
		mozconfig_disable b2g-bt
		mozconfig_disable mozril-geoloc
		mozconfig_disable nfc
		mozconfig_disable synth-pico
		mozconfig_disable url-classifier
		mozconfig_disable userinfo
	fi

	if use official-branding; then
		official-branding_warning
		mozconfig_enable official-branding
		mozconfig_enable private-build
	fi

	# System-* flags
	# Some options aren't in configure.in anymore (e.g. webp, spelling)
	if use system-nspr; then
		mozconfig_with system-nspr
	fi

	if use system-icu; then
		mozconfig_with system-icu
	fi

	if use system-compress; then
		mozconfig_with system-zlib
		mozconfig_with system-bz2
	fi

	if use system-libevent; then
		mozconfig_with system-libevent
	fi

	if use system-nss; then
		mozconfig_with system-nss
	fi

	if use system-images; then
		mozconfig_with system-jpeg
		mozconfig_with system-png
	fi

	if use system-vpx; then
		mozconfig_with system-libvpx
	fi

	if use system-sqlite; then
		mozconfig_enable system-sqlite
	fi

	if use system-cairo; then
		mozconfig_enable system-cairo
	fi

	if use system-pixman; then
		mozconfig_enable system-pixman
	fi

	if use system-ffi; then
		mozconfig_enable system-ffi
	fi

	if use system-hunspell; then
		mozconfig_enable system-hunspell
	fi

	# Common flags
	if use optimize; then
		#O='-O2'
		#O='-O3'
		#if use cpu_flags_x86_ssse3; then
		#	O="${O} -mssse3 -mfpmath=both"
		#fi

		#if ! use cpu_flags_x86_ssse3 &&
		#use cpu_flags_x86_sse && use cpu_flags_x86_sse2; then
		#	O="${O} -msse2 -mfpmath=sse"
		#fi
		mozconfig_enable "optimize=\"${CFLAGS}\""
		#filter-flags '-O*' '-msse2' '-mssse3' '-mfpmath=*'
	else
		mozconfig_disable optimize
	fi

	if use threads; then
		mozconfig_with pthreads
	fi

	if use debug; then
		mozconfig_var MOZ_DEBUG_SYMBOLS 1
		mozconfig_enable "debug-symbols=\"-gdwarf-2\""
	else
		mozconfig_disable debug
		mozconfig_disable debug-symbols
		mozconfig_disable parental-controls
		mozconfig_disable tests
		mozconfig_disable crashreporter
	fi

	if ! use stylo; then
		mozconfig_disable stylo
	fi

	if use alsa; then
		mozconfig_enable alsa
	fi

	if use gold; then
		mozconfig_enable gold
	fi

	if use pie; then
		mozconfig_enable pie
	fi

	if ! use webrtc; then
		mozconfig_disable webrtc
	fi

	if ! use gamepad; then
		mozconfig_disable gamepad
	fi

	if ! use webspeech; then
		mozconfig_disable webspeech
		mozconfig_disable webspeechtestbackend
		mozconfig_disable synth-speechd
	fi

	if ! use accessibility; then
		mozconfig_disable accessibility
	fi

	if ! use shared-js; then
		mozconfig_disable shared-js
	fi

	if use jemalloc; then
		mozconfig_enable jemalloc
	fi

	if use valgrind; then
		mozconfig_enable valgrind
	fi

	if ! use dbus; then
		mozconfig_disable dbus
	fi

	if use gtk2; then
		mozconfig_enable default-toolkit=\"cairo-gtk2\"
	fi

	if use gtk3; then
		mozconfig_enable default-toolkit=\"cairo-gtk3\"
	fi

	if ! use necko-wifi; then
		mozconfig_disable necko-wifi
	fi

	if ! use pulseaudio; then
		mozconfig_disable pulseaudio
	fi

	if use devtools; then
		mozconfig_enable devtools
	fi

	if ! use gconf; then
		mozconfig_disable gconf
	fi

	# Enabling this causes xpcshell to hang during the packaging process,
	# so disabling it until the cause can be tracked down. It most likely
	# has something to do with the sandbox since the issue goes away when
	# building with FEATURES="-sandbox -usersandbox".
	mozconfig_disable precompiled-startupcache

	# Mainly to prevent system's NSS/NSPR from taking precedence over
	# the built-in ones:
	append-ldflags -Wl,-rpath="$EPREFIX/usr/$(get_libdir)/basilisk"

	export MOZBUILD_STATE_PATH="${WORKDIR}/mach_state"
	mozconfig_var PYTHON $(which python2)
	mozconfig_var AUTOCONF $(which autoconf-2.13)
	mozconfig_var MOZ_MAKE_FLAGS "\"${MAKEOPTS}\""

	# Shorten obj dir to limit some errors linked to the path size hitting
	# a kernel limit (127 chars):
	mozconfig_var MOZ_OBJDIR "@TOPSRCDIR@/o"

	# Disable mach notifications, which also cause sandbox access violations:
	export MOZ_NOSPAM=1

	# Security settings lifted from arch PKGBUILD
	export MOZ_DATA_REPORTING=0
	export MOZILLA_OFFICIAL=1
	export MOZ_TELEMETRY_REPORTING=0
	export MOZ_ADDON_SIGNING=1
	export MOZ_CRASHREPORTER=0
	export MOZ_REQUIRE_SIGNING=0
	export MOZ_SERVICES_HEALTHREPORT=0

	if use pgo; then
		# Doubt this works lol
		export MOZ_PGO=1
	fi


}

src_compile() {
	# Prevents portage from setting its own XARGS which messes with the
	# Pale Moon build system checks:
	# See: https://gitweb.gentoo.org/proj/portage.git/tree/bin/isolated-functions.sh
	export XARGS="$(which xargs)"

	python2 mach build || die
}

src_install() {
	# obj_dir changes depending on arch, compiler, etc:
	local obj_dir="$(echo */config.log)"
	obj_dir="${obj_dir%/*}"

	# Disable MPROTECT for startup cache creation:
	pax-mark m "${obj_dir}"/dist/bin/xpcshell

	# Set the backspace behaviour to be consistent with the other platforms:
	set_pref "browser.backspace_action" 0

	# Gotta create the package, unpack it and manually install the files
	# from there not to miss anything (e.g. the statusbar extension):
	einfo "Creating the package..."
	python2 mach package || die
	local extracted_dir="${T}/package"
	mkdir -p "${extracted_dir}"
	cd "${extracted_dir}"
	einfo "Extracting the package..."
	find "${S}/${obj_dir}/dist/" -name "*.bz2" -printf "${S}/${obj_dir}/dist/%P" | xargs tar xjpf
	einfo "Installing the package..."
	local dest_libdir="/usr/$(get_libdir)"
	mkdir -p "${D}/${dest_libdir}"
	cp -rL "${PN}" "${D}/${dest_libdir}"
	dosym "${dest_libdir}/${PN}/${PN}" "/usr/bin/${PN}"
	einfo "Done installing the package."

	# Until JIT-less builds are supported,
	# also disable MPROTECT on the main executable:
	pax-mark m "${D}/${dest_libdir}/${PN}/"{basilisk,basilisk-bin,plugin-container}

	# Install icons and .desktop for menu entry:
	install_branding_files
}
