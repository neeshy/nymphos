# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop

DESCRIPTION="Advanced rhythm game, designed for both home and arcade use"
HOMEPAGE="http://www.stepmania.com/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
elif [[ "${PV}" = *_beta* ]]; then
	MY_PV="${PV/_beta/-b}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT default-songs? ( CC-BY-NC-4.0 )"
SLOT="0"
IUSE="doc +default-songs lto +xinerama alsa oss pulseaudio jack ffmpeg +mp3 +ogg wav +jpeg gles2 +gtk networking parport tty crash-handler cpu_flags_x86_sse2"
REQUIRED_USE="|| ( alsa oss pulseaudio jack )"

RDEPEND="
	app-arch/bzip2
	dev-libs/libpcre
	sys-libs/zlib
	virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libva
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	xinerama? ( x11-libs/libXinerama )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( virtual/ffmpeg )
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/pango
	)
	jack? ( media-sound/jack-audio-connection-kit )
	mp3? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_configure() {
	# Minimaid tries to use pre-built static libraries (x86 only, often fails to link)
	# TTY input fails to compile
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt
		-DWITH_FULL_RELEASE=NO
		-DWITH_LTO="$(usex lto)"
		-DWITH_GPL_LIBS=YES
		-DWITH_PROFILING=NO
		-DWITH_XINERAMA="$(usex xinerama)"
		-DWITH_ALSA="$(usex alsa)"
		-DWITH_OSS="$(usex oss)"
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		-DWITH_JACK="$(usex jack)"
		-DWITH_FFMPEG="$(usex ffmpeg)"
		-DWITH_SYSTEM_FFMPEG="$(usex ffmpeg)"
		-DWITH_MP3="$(usex mp3)"
		-DWITH_OGG="$(usex ogg)"
		-DWITH_WAV="$(usex wav)"
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_GLES2="$(usex gles2)"
		-DWITH_GTK2="$(usex gtk)"
		-DWITH_PORTABLE_TOMCRYPT=YES
		-DWITH_NETWORKING="$(usex networking)"
		-DWITH_PARALLEL_PORT="$(usex parport)"
		-DWITH_TTY="$(usex tty)"
		-DWITH_CRASH_HANDLER="$(usex crash-handler)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
		-DWITH_MINIMAID=NO
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newbin "${FILESDIR}/${P}.sh" "${PN}"
	domenu "${PN}.desktop"
	local size
	for size in 16 22 24 32 36 48 64 72 96 128 192 256; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		doins "icons/hicolor/${size}x${size}/apps/${PN}-ssc.png"
	done
	insinto /usr/share/icons/hicolor/scalable/apps
	doins "icons/hicolor/scalable/apps/${PN}-ssc.svg"
}
