# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake desktop git-r3 wrapper xdg

DESCRIPTION="A fork of StepMania 5.1, improved for the post-ITG community"
HOMEPAGE="https://www.itgmania.com/"
EGIT_REPO_URI="https://github.com/itgmania/itgmania.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-3+ CC-BY-NC-4.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cpu_flags_x86_sse2 crash-handler gles2 +gtk jack lights lto oss pulseaudio xinerama xrandr"
REQUIRED_USE="|| ( alsa oss pulseaudio jack )"

RDEPEND="
	media-libs/glu
	media-libs/mesa[opengl]
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	|| ( dev-lang/nasm dev-lang/yasm )
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:3 )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/libpulse )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-libjpeg-turbo-CMAKE_BUILD_TYPE_UC.patch"
	"${FILESDIR}/${PN}-install-sm5-songs.patch"
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
		-DWITH_GLES2="$(usex gles2)"
		-DWITH_GTK3="$(usex gtk)"
		-DWITH_PARALLEL_PORT="$(usex lights)"
		-DWITH_CRASH_HANDLER="$(usex crash-handler)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	make_wrapper "${PN}" "/opt/${PN}/${PN}"
	domenu "${PN}.desktop"
	newicon -s 48 Data/icon.png "${PN}.png"
	newicon -s scalable Data/logo.svg "${PN}.svg"
}
