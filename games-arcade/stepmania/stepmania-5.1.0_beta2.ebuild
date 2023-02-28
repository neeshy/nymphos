# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

MY_PV="${PV/_beta/-b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Advanced rhythm game, designed for both home and arcade use"
HOMEPAGE="https://www.stepmania.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT default-songs? ( CC-BY-NC-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cpu_flags_x86_sse2 crash-handler +default-songs doc ffmpeg gles2 +gtk jack lto +mp3 networking +ogg oss parport pulseaudio tty wav +xinerama"
REQUIRED_USE="|| ( alsa oss pulseaudio jack )"

RDEPEND="
	app-arch/bzip2
	dev-libs/libpcre
	media-libs/glew:=
	media-libs/libjpeg-turbo
	media-libs/libva
	media-libs/mesa[gles2?]
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg )
	gtk? ( x11-libs/gtk+:2 )
	jack? ( media-sound/jack-audio-connection-kit )
	mp3? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	pulseaudio? ( media-sound/pulseaudio )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	ffmpeg? ( || ( dev-lang/nasm dev-lang/yasm ) )"

PATCHES=(
	"${FILESDIR}/${PN}-include-time.patch"
	"${FILESDIR}/${PN}-select-audio-backends.patch"
)

S="${WORKDIR}/${MY_P}"

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
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newbin "${FILESDIR}/${PN}.sh" "${PN}"
	domenu "${PN}.desktop"
	local size
	for size in 16 22 24 32 36 48 64 72 96 128 192 256; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		doins "icons/hicolor/${size}x${size}/apps/${PN}-ssc.png"
	done
	insinto /usr/share/icons/hicolor/scalable/apps
	doins "icons/hicolor/scalable/apps/${PN}-ssc.svg"
}
