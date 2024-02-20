# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anstream@0.6.12
	anstyle@1.0.6
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	bitflags@1.3.2
	bitflags@2.4.2
	cfg-if@1.0.0
	clap@4.5.1
	clap_builder@4.5.1
	clap_lex@0.7.0
	colorchoice@1.0.0
	colored@2.1.0
	crossbeam-channel@0.5.11
	crossbeam-utils@0.8.19
	env_filter@0.1.0
	env_logger@0.11.2
	filetime@0.2.23
	fsevent-sys@4.1.0
	humantime@2.1.0
	inotify@0.9.6
	inotify-sys@0.1.5
	itoa@1.0.10
	kqueue@1.0.8
	kqueue-sys@1.0.4
	lazy_static@1.4.0
	libc@0.2.153
	log@0.4.20
	memchr@2.7.1
	mio@0.8.10
	notify@6.1.1
	proc-macro2@1.0.78
	quote@1.0.35
	redox_syscall@0.4.1
	regex@1.10.3
	regex-automata@0.4.5
	regex-syntax@0.8.2
	ryu@1.0.16
	same-file@1.0.6
	serde@1.0.196
	serde_derive@1.0.196
	serde_json@1.0.113
	strsim@0.11.0
	syn@2.0.49
	unicode-ident@1.0.12
	utf8parse@0.2.1
	walkdir@2.4.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0"

inherit cargo shell-completion

DESCRIPTION="An mpc-like CLI tool for mpv"
HOMEPAGE="https://github.com/neeshy/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="media-video/mpv"

src_configure() {
	cargo_src_configure --bins --examples
}

src_install() {
	cargo_src_install
	dobin examples/mpvc-fzf

	newbashcomp "${S}/etc/mpvc.bash" mpvc
	newzshcomp "${S}/etc/mpvc.zsh" _mpvc
	dofishcomp "${S}/etc/mpvc.fish"
}
