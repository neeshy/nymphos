# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.19
	anstyle@1.0.11
	anstyle-parse@0.2.7
	anstyle-query@1.1.3
	anstyle-wincon@3.0.9
	bitflags@1.3.2
	bitflags@2.9.1
	cfg-if@1.0.1
	clap@4.5.40
	clap_builder@4.5.40
	clap_complete@4.5.54
	clap_lex@0.7.5
	colorchoice@1.0.4
	colored@3.0.0
	env_filter@0.1.3
	env_logger@0.11.8
	filetime@0.2.25
	fsevent-sys@4.1.0
	inotify@0.11.0
	inotify-sys@0.1.5
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	jiff@0.2.15
	jiff-static@0.2.15
	kqueue@1.1.1
	kqueue-sys@1.0.4
	libc@0.2.174
	libredox@0.1.4
	log@0.4.27
	memchr@2.7.5
	mio@1.0.4
	notify@8.0.0
	notify-types@2.0.0
	once_cell_polyfill@1.70.1
	portable-atomic@1.11.1
	portable-atomic-util@0.2.4
	proc-macro2@1.0.95
	quote@1.0.40
	redox_syscall@0.5.13
	regex@1.11.1
	regex-automata@0.4.9
	regex-syntax@0.8.5
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	strsim@0.11.1
	syn@2.0.104
	unicode-ident@1.0.18
	utf8parse@0.2.2
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	winapi-util@0.1.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
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

src_install() {
	cargo_src_install
	dobin "examples/${PN}-fzf"

	"${ED}/usr/bin/mpvc" completion bash >etc/mpvc.bash || die "mpvc completion failed"
	"${ED}/usr/bin/mpvc" completion fish >etc/mpvc.fish || die "mpvc completion failed"
	newbashcomp "etc/${PN}.bash" "${PN}"
	newzshcomp "etc/${PN}.zsh" "_${PN}"
	dofishcomp "etc/${PN}.fish"
}
