# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	atty-0.2.14
	bitflags-1.3.2
	cfg-if-1.0.0
	clap-2.34.0
	colored-1.9.3
	hermit-abi-0.1.19
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.125
	log-0.4.17
	mpvipc-1.1.9
	ryu-1.0.10
	serde-1.0.137
	serde_json-1.0.81
	strsim-0.8.0
	textwrap-0.11.0
	unicode-width-0.1.9
	vec_map-0.8.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://gitlab.com/mpv-ipc/${PN}"
SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-video/mpv"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	pushd "${WORKDIR}/cargo_home/gentoo/mpvipc-1.1.9"
	eapply "${FILESDIR}/mpvipc-1.1.9-append-play.patch"
	popd
	default
}
