# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"
HOMEPAGE="https://github.com/multiplexd/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="ISC"
SLOT="0"

DEPEND="virtual/yacc"

export STATE_DIR="${STATE_DIR:-/var/cache/${PN}}"

src_install() {
	dobin "${PN}"
	fperms +s "/usr/bin/${PN}"

	doman "${PN}.1" "${PN}.conf.5"

	keepdir "${STATE_DIR}"
	fperms 700 "${STATE_DIR}"
}
