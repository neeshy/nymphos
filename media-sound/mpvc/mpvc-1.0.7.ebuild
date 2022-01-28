# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
	ansi_term-0.11.0
	atty-0.2.14
	bitflags-1.2.1
	clap-2.33.0
	colored-1.9.3
	hermit-abi-0.1.10
	itoa-0.4.5
	lazy_static-1.4.0
	libc-0.2.68
	mpvipc-1.1.5
	ryu-1.0.3
	serde-1.0.105
	serde_json-1.0.50
	strsim-0.8.0
	textwrap-0.11.0
	unicode-width-0.1.7
	vec_map-0.8.1
	winapi-0.3.8
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://gitlab.com/mpv-ipc/${PN}"
SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-video/mpv"

S="${WORKDIR}/${PN}-v${PV}"
