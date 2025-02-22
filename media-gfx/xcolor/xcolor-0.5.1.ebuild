# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term@0.11.0
	anyhow@1.0.43
	atty@0.2.14
	autocfg@1.0.1
	bitflags@1.2.1
	cc@1.0.70
	cfg-if@1.0.0
	clap@2.33.3
	hermit-abi@0.1.19
	lazy_static@1.4.0
	libc@0.2.101
	log@0.4.14
	memchr@2.4.1
	memoffset@0.6.4
	minimal-lexical@0.1.3
	nix@0.22.1
	nom@7.0.0
	pkg-config@0.3.19
	strsim@0.8.0
	textwrap@0.11.0
	unicode-width@0.1.8
	vec_map@0.8.2
	version_check@0.9.3
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	x11@2.18.2
	xcb@0.9.0"

inherit cargo

DESCRIPTION="Lightweight color picker for X11"
HOMEPAGE="https://github.com/Soft/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcursor"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
