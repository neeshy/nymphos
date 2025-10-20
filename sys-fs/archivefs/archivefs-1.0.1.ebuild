# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	ansi_term@0.12.1
	anyhow@1.0.75
	atty@0.2.14
	bitflags@1.3.2
	byteorder@1.5.0
	clap@2.34.0
	daemonize@0.5.0
	either@1.9.0
	env_logger@0.8.4
	hermit-abi@0.1.19
	humantime@2.1.0
	libc@0.2.150
	log@0.4.20
	memchr@2.6.4
	once_cell@1.18.0
	pin-project-lite@0.2.13
	polyfuse-kernel@0.1.0
	polyfuse@0.4.1
	proc-macro2@1.0.69
	quote@1.0.33
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	relative-path@1.9.0
	strsim@0.8.0
	syn@1.0.109
	syn@2.0.39
	synstructure@0.12.6
	termcolor@1.3.0
	termios@0.3.3
	textwrap@0.11.0
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	unicode-ident@1.0.12
	unicode-width@0.1.11
	unicode-xid@0.2.4
	vec_map@0.8.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	zerocopy-derive@0.2.0
	zerocopy@0.3.0"

inherit cargo

DESCRIPTION="A read-only FUSE filesystem for mounting compressed archives, inspired by archivemount"
HOMEPAGE="https://github.com/bugnano/archivefs"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" BSD MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man"

BDEPEND="man? ( app-text/asciidoc )"

src_compile() {
	cargo_src_compile
	if use man; then
		a2x -f manpage "doc/${PN}.1.adoc" || die "a2x failed"
	fi
}

src_install() {
	cargo_src_install
	use man && doman "doc/${PN}.1"
}
