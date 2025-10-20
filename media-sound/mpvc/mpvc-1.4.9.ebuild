# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	bitflags@1.3.2
	bitflags@2.9.4
	clap@4.5.49
	clap_builder@4.5.49
	clap_complete@4.5.59
	clap_lex@0.7.6
	colorchoice@1.0.4
	colored@3.0.0
	env_filter@0.1.4
	env_logger@0.11.8
	fsevent-sys@4.1.0
	inotify-sys@0.1.5
	inotify@0.11.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	jiff-static@0.2.15
	jiff@0.2.15
	kqueue-sys@1.0.4
	kqueue@1.1.1
	libc@0.2.177
	log@0.4.28
	memchr@2.7.6
	mio@1.0.4
	notify-types@2.0.0
	notify@8.2.0
	once_cell_polyfill@1.70.1
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	quote@1.0.41
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	strsim@0.11.1
	syn@2.0.106
	unicode-ident@1.0.19
	utf8parse@0.2.2
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1"

inherit cargo shell-completion

DESCRIPTION="An mpc-like CLI tool for mpv"
HOMEPAGE="https://github.com/neeshy/mpvc"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )"
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
