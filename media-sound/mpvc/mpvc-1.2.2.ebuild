# Copyright 2023 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-1.0.1
	anstream-0.3.1
	anstyle-1.0.0
	anstyle-parse-0.2.0
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	atty-0.2.14
	bitflags-1.3.2
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.2.7
	clap_builder-4.2.7
	clap_lex-0.4.1
	colorchoice-1.0.0
	colored-2.0.0
	crossbeam-channel-0.5.8
	crossbeam-utils-0.8.15
	env_logger-0.10.0
	errno-0.3.1
	errno-dragonfly-0.1.2
	filetime-0.2.21
	fsevent-sys-4.1.0
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	humantime-2.1.0
	inotify-0.9.6
	inotify-sys-0.1.5
	io-lifetimes-1.0.10
	is-terminal-0.4.7
	itoa-1.0.6
	kqueue-1.0.7
	kqueue-sys-1.0.3
	lazy_static-1.4.0
	libc-0.2.142
	linux-raw-sys-0.3.4
	log-0.4.17
	memchr-2.5.0
	mio-0.8.6
	notify-5.1.0
	redox_syscall-0.2.16
	regex-1.8.1
	regex-syntax-0.7.1
	rustix-0.37.15
	ryu-1.0.13
	same-file-1.0.6
	serde-1.0.163
	serde_json-1.0.96
	strsim-0.10.0
	termcolor-1.2.0
	utf8parse-0.2.1
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://github.com/neeshy/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="media-video/mpv"
