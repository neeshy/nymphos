# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic xdg

DESCRIPTION="Reference frontend for libretro-based emulators"
HOMEPAGE="https://www.retroarch.com/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libretro/RetroArch"
else
	SRC_URI="https://github.com/libretro/RetroArch/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/RetroArch-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="alsa +cdrom cg cpu_flags_x86_sse2 dbus drm egl ffmpeg flac gles2 gles3 gles3_1 gles3_2 jack kms libass libcaca +network openal +opengl +opengl_core osmesa parport pulseaudio qt5 sdl sdl2 sixel ssl systemd tinyalsa +truetype +udev usb v4l vulkan wayland X xrandr xinerama xv +zlib"

REQUIRED_USE="
	|| ( alsa jack pulseaudio )
	|| ( opengl vulkan sdl sdl2 libcaca sixel )
	|| ( X wayland drm kms )
	?? ( gles2 cg )
	?? ( sdl sdl2 )
	cg? ( opengl )
	egl? ( opengl )
	gles2? ( egl )
	gles3? ( gles2 )
	gles3_1? ( gles3 )
	gles3_2? ( gles3_1 )
	kms? ( drm egl )
	libass? ( ffmpeg )
	opengl_core? ( opengl )
	osmesa? ( opengl )
	ssl? ( network )
	xinerama? ( X )
	xrandr? ( X )
	xv? ( X )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	cg? ( media-gfx/nvidia-cg-toolkit )
	drm? ( x11-libs/libdrm )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	jack? ( virtual/jack )
	libass? ( media-libs/libass:= )
	libcaca? ( media-libs/libcaca )
	openal? ( media-libs/openal )
	opengl? ( media-libs/mesa[opengl] )
	osmesa? ( media-libs/mesa[osmesa] )
	pulseaudio? ( media-libs/libpulse )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl )
	sdl2? ( media-libs/libsdl2 )
	sixel? ( media-libs/libsixel )
	ssl? ( net-libs/mbedtls:= )
	systemd? ( sys-apps/systemd )
	truetype? ( media-libs/freetype:2= )
	udev? ( virtual/udev )
	usb? ( virtual/libusb:= )
	v4l? ( media-libs/libv4l:= )
	vulkan? ( media-libs/vulkan-loader[X?,wayland?] )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/libxcb
	)
	xrandr? ( x11-libs/libXrandr )
	xinerama? ( x11-libs/libXinerama )
	xv? ( x11-libs/libXv )
	zlib? ( sys-libs/zlib:= )"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-configure-params.patch" )

src_configure() {
	if use cg; then
		append-ldflags -L/opt/nvidia-cg-toolkit/"$(get_libdir)"
		append-cppflags -I/opt/nvidia-cg-toolkit/include
	fi

	econf \
		--enable-mmap \
		--enable-threads \
		--disable-audioio \
		--disable-builtinflac \
		--disable-builtinmbedtls \
		--disable-builtinzlib \
		--disable-coreaudio \
		--disable-mpv \
		--disable-oss \
		--disable-roar \
		--disable-rsound \
		--disable-vg \
		--disable-videocore \
		"$(use_enable alsa)" \
		"$(use_enable cdrom)" \
		"$(use_enable cg)" \
		"$(use_enable cpu_flags_x86_sse2 sse)" \
		"$(use_enable dbus)" \
		"$(use_enable drm plain_drm)" \
		"$(use_enable egl)" \
		"$(use_enable ffmpeg)" \
		"$(use_enable flac)" \
		"$(use_enable gles2 opengles)" \
		"$(use_enable gles3 opengles3)" \
		"$(use_enable gles3_1 opengles3_1)" \
		"$(use_enable gles3_2 opengles3_2)" \
		"$(use_enable jack)" \
		"$(use_enable kms)" \
		"$(use_enable libass ssa)" \
		"$(use_enable libcaca caca)" \
		"$(use_enable network networking)" \
		"$(use_enable openal al)" \
		"$(use_enable opengl)" \
		"$(use_enable opengl_core)" \
		"$(use_enable osmesa)" \
		"$(use_enable parport)" \
		"$(use_enable pulseaudio pulse)" \
		"$(use_enable qt5 qt)" \
		"$(use_enable sdl)" \
		"$(use_enable sdl2)" \
		"$(use_enable sixel)" \
		"$(use_enable ssl)" \
		"$(use_enable systemd)" \
		"$(use_enable tinyalsa)" \
		"$(use_enable truetype freetype)" \
		"$(use_enable udev)" \
		"$(use_enable usb libusb)" \
		"$(use_enable v4l v4l2)" \
		"$(use_enable vulkan)" \
		"$(use_enable wayland)" \
		"$(use_enable xinerama)" \
		"$(use_enable xrandr)" \
		"$(use_enable xv xvideo)" \
		"$(use_enable X x11)" \
		"$(use_enable zlib)"
}
