# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.15
	anstyle@1.0.8
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.3
	bitflags@1.3.2
	bitflags@2.6.0
	cfg-if@1.0.0
	clap@4.5.13
	clap_builder@4.5.13
	clap_complete@4.5.12
	clap_lex@0.7.2
	colorchoice@1.0.2
	colored@2.1.0
	crossbeam-channel@0.5.13
	crossbeam-utils@0.8.20
	env_filter@0.1.0
	env_logger@0.11.5
	filetime@0.2.23
	fsevent-sys@4.1.0
	humantime@2.1.0
	inotify@0.9.6
	inotify-sys@0.1.5
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	kqueue@1.0.8
	kqueue-sys@1.0.4
	lazy_static@1.5.0
	libc@0.2.155
	log@0.4.22
	memchr@2.7.4
	mio@0.8.11
	notify@6.1.1
	proc-macro2@1.0.86
	quote@1.0.36
	redox_syscall@0.4.1
	regex@1.10.5
	regex-automata@0.4.7
	regex-syntax@0.8.4
	ryu@1.0.18
	same-file@1.0.6
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.121
	strsim@0.11.1
	syn@2.0.72
	unicode-ident@1.0.12
	utf8parse@0.2.2
	walkdir@2.5.0
	wasi-0.11.0+wasi-snapshot@preview1
	winapi-util@0.1.8
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6"

inherit cargo shell-completion

DESCRIPTION="An mpc-like CLI tool for mpv"
HOMEPAGE="https://github.com/neeshy/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-video/mpv"

src_configure() {
	cargo_src_configure --bins --examples
}

src_compile() {
	cargo_src_compile

	target/release/mpvc completion bash >etc/mpvc.bash || die "mpvc completion failed"
	target/release/mpvc completion fish >etc/mpvc.fish || die "mpvc completion failed"
}

src_install() {
	cargo_src_install
	dobin "examples/${PN}-fzf"

	newbashcomp "etc/${PN}.bash" "${PN}"
	newzshcomp "etc/${PN}.zsh" "_${PN}"
	dofishcomp "etc/${PN}.fish"
}
