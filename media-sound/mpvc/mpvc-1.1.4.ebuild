# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.20
	atty-0.2.14
	bitflags-1.3.2
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.1.13
	clap_lex-0.3.3
	colored-2.0.0
	env_logger-0.10.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	humantime-2.1.0
	io-lifetimes-1.0.9
	is-terminal-0.4.5
	itoa-1.0.6
	lazy_static-1.4.0
	libc-0.2.140
	linux-raw-sys-0.1.4
	log-0.4.17
	memchr-2.5.0
	os_str_bytes-6.5.0
	regex-1.7.3
	regex-syntax-0.6.29
	rustix-0.36.11
	ryu-1.0.13
	serde-1.0.158
	serde_json-1.0.94
	strsim-0.10.0
	termcolor-1.2.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.45.0
	windows-targets-0.42.2
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://github.com/neeshy/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="media-video/mpv"
