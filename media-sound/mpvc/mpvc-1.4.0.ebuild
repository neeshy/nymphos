# Copyright 2023 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-1.0.4
	anstream-0.3.2
	anstyle-1.0.1
	anstyle-parse-0.2.1
	anstyle-query-1.0.0
	anstyle-wincon-1.0.2
	bitflags-1.3.2
	bitflags-2.4.0
	cc-1.0.83
	cfg-if-1.0.0
	clap-4.3.23
	clap_builder-4.3.23
	clap_lex-0.5.0
	colorchoice-1.0.0
	colored-2.0.4
	crossbeam-channel-0.5.8
	crossbeam-utils-0.8.16
	env_logger-0.10.0
	errno-0.3.2
	errno-dragonfly-0.1.2
	filetime-0.2.22
	fsevent-sys-4.1.0
	hermit-abi-0.3.2
	humantime-2.1.0
	inotify-0.9.6
	inotify-sys-0.1.5
	is-terminal-0.4.9
	itoa-1.0.9
	kqueue-1.0.8
	kqueue-sys-1.0.4
	lazy_static-1.4.0
	libc-0.2.147
	linux-raw-sys-0.4.5
	log-0.4.20
	memchr-2.5.0
	mio-0.8.8
	notify-6.1.0
	redox_syscall-0.3.5
	regex-1.9.3
	regex-automata-0.3.6
	regex-syntax-0.7.4
	rustix-0.38.8
	ryu-1.0.15
	same-file-1.0.6
	serde-1.0.171
	serde_json-1.0.105
	strsim-0.10.0
	termcolor-1.2.0
	utf8parse-0.2.1
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_msvc-0.48.5
	windows_i686_gnu-0.48.5
	windows_i686_msvc-0.48.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_msvc-0.48.5"

inherit cargo

DESCRIPTION="An mpc-like cli tool for mpv"
HOMEPAGE="https://github.com/neeshy/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="media-video/mpv"

src_configure() {
	cargo_src_configure --bins --examples
}

src_install() {
	cargo_src_install
	dobin examples/mpvc-fzf
}
