# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"
HOMEPAGE="https://github.com/multiplexd/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="ISC"
SLOT="0"

DEPEND="virtual/yacc"

export STATE_DIR="${STATE_DIR:-/var/cache/${PN}}"

src_prepare() {
	sed -i '/^_CFLAGS=/s/ -Werror//' Makefile || die "sed failed"
	default
}

src_install() {
	dobin "${PN}"
	fperms +s "/usr/bin/${PN}"

	doman doas.1
	doman doas.conf.5

	keepdir "${STATE_DIR}"
	fperms 700 "${STATE_DIR}"
}
