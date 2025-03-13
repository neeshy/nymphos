# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"

inherit cmake desktop wrapper xdg

MY_PV="d55acb1ba26f1c5b5e3048d6d6c0bd116625216f"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Advanced rhythm game. Designed for both home and arcade use."
HOMEPAGE="https://www.stepmania.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/${PN}/${PN}/commit/3fef5ef60b7674d6431f4e1e4ba8c69b0c21c023.patch -> ${PN}-ffmpeg_build_fix.patch
	https://github.com/${PN}/${PN}/commit/e0d2a5182dcd855e181fffa086273460c553c7ff.patch -> ${PN}-ffmpeg_crash_fix.patch"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cpu_flags_x86_sse2 crash-handler ffmpeg gles2 +gtk jack lights lto +mp3 network +ogg oss pulseaudio sdl wav xinerama xrandr"
REQUIRED_USE="|| ( alsa oss pulseaudio jack )"

RDEPEND="
	dev-libs/jsoncpp:=
	dev-libs/libpcre:=
	dev-libs/libtomcrypt:=
	dev-libs/libtommath
	media-libs/glew:=
	media-libs/glu
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/mesa[opengl]
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	gtk? ( x11-libs/gtk+:3 )
	jack? ( virtual/jack )
	mp3? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	pulseaudio? ( media-sound/libpulse )
	sdl? ( media-libs/libsdl2 )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${DISTDIR}/${PN}-ffmpeg_build_fix.patch"
	"${DISTDIR}/${PN}-ffmpeg_crash_fix.patch"
	"${FILESDIR}/${PN}-ffmpeg-7.patch"
	"${FILESDIR}/${PN}-ffmpeg-remove-asm-requirement.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt
		-DWITH_FULL_RELEASE=yes
		-DWITH_PORTABLE_TOMCRYPT=no
		-DWITH_LTO="$(usex lto)"
		-DWITH_XINERAMA="$(usex xinerama)"
		-DWITH_XRANDR="$(usex xrandr)"
		-DWITH_ALSA="$(usex alsa)"
		-DWITH_OSS="$(usex oss)"
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		-DWITH_JACK="$(usex jack)"
		-DWITH_FFMPEG="$(usex ffmpeg)"
		-DWITH_MP3="$(usex mp3)"
		-DWITH_OGG="$(usex ogg)"
		-DWITH_WAV="$(usex wav)"
		-DWITH_GLES2="$(usex gles2)"
		-DWITH_SDL="$(usex sdl)"
		-DWITH_GTK3="$(usex gtk)"
		-DWITH_NETWORKING="$(usex network)"
		-DWITH_PARALLEL_PORT="$(usex lights)"
		-DWITH_CRASH_HANDLER="$(usex crash-handler)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
		-DWITH_SYSTEM_FFMPEG=yes
		-DWITH_SYSTEM_MAD=yes
		-DWITH_SYSTEM_OGG=yes
		-DWITH_SYSTEM_JPEG=yes
		-DWITH_SYSTEM_PNG=yes
		-DWITH_SYSTEM_GLEW=yes
		-DWITH_SYSTEM_TOMMATH=yes
		-DWITH_SYSTEM_TOMCRYPT=yes
		-DWITH_SYSTEM_JSONCPP=yes
		-DWITH_SYSTEM_PCRE=yes
		-DWITH_SYSTEM_ZLIB=yes
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	make_wrapper "${PN}" "/opt/${PN}-5.1/${PN}"
	domenu "${PN}.desktop"
	local size
	for size in 16 22 24 32 36 48 64 72 96 128 192 256; do
		doicon -s "${size}" "icons/hicolor/${size}x${size}/apps/${PN}-ssc.png"
	done
	doicon -s scalable "icons/hicolor/scalable/apps/${PN}-ssc.svg"
}
