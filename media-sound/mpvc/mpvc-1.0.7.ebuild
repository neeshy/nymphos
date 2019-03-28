# Copyright 2017-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CRATES="
	ansi_term-0.11.0
	atty-0.2.11
	bitflags-1.0.3
	clap-2.32.0
	colored-1.6.1
	dtoa-0.4.3
	itoa-0.4.2
	lazy_static-1.1.0
	libc-0.2.43
	mpvipc-1.1.5
	redox_syscall-0.1.40
	redox_termios-0.1.1
	serde-1.0.71
	serde_json-1.0.24
	strsim-0.7.0
	termion-1.5.1
	textwrap-0.10.0
	unicode-width-0.1.5
	vec_map-0.8.1
	version_check-0.1.4
	winapi-0.3.5
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://gitlab.com/mpv-ipc/mpvc"
SRC_URI="https://gitlab.com/mpv-ipc/mpvc/-/archive/v${PV}/mpvc-v${PV}.tar.gz -> ${P}.tar.gz
$(cargo_crate_uris ${CRATES})"

RESTRICT="mirror"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-video/mpv"

PATCHES=(
	"${FILESDIR}/0001-Use-1-indexing-and-fix-type-error.patch"
	"${FILESDIR}/0002-Allow-for-multiple-files-to-be-added-to-the-playlist.patch"
	"${FILESDIR}/0003-Spawn-an-mpv-instance-one-isn-t-available-and-the-ad.patch"
	"${FILESDIR}/0004-Improve-conditionals.patch"
	"${FILESDIR}/0005-Add-the-ability-to-wait-on-property-changes.patch"
)

S="${WORKDIR}/${PN}-v${PV}"
