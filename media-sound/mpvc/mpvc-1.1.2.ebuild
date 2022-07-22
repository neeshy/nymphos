# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	clap-3.2.14
	clap_lex-0.2.4
	colored-2.0.0
	hashbrown-0.12.3
	hermit-abi-0.1.19
	indexmap-1.9.1
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.126
	log-0.4.17
	mpvipc-1.2.2
	os_str_bytes-6.2.0
	ryu-1.0.10
	serde-1.0.140
	serde_json-1.0.82
	strsim-0.10.0
	termcolor-1.1.3
	textwrap-0.15.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://gitlab.com/mpv-ipc/${PN}"
SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-video/mpv"

PATCHES=(
	"${FILESDIR}/${P}-1-one-indexing.patch"
	"${FILESDIR}/${P}-2-improve-conditionals.patch"
	"${FILESDIR}/${P}-3-playlist-multiple-files.patch"
	"${FILESDIR}/${P}-4-spawn-mpv.patch"
	"${FILESDIR}/${P}-5-wait-for-prop.patch"
	"${FILESDIR}/${P}-6-macros.patch"
	"${FILESDIR}/${P}-7-append-play.patch"
	"${FILESDIR}/${P}-8-update-mpvipc.patch"
)

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	pushd "${WORKDIR}/cargo_home/gentoo/mpvipc-1.2.2"
	eapply "${FILESDIR}/mpvipc-1.2.2-append-play.patch"
	popd
	default
}
