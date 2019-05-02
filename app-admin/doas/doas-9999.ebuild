# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils toolchain-funcs git-r3

[[ -z "${DOAS_STATE_DIR}" ]] && DOAS_STATE_DIR="/var/cache/${PN}"

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"
HOMEPAGE="https://github.com/multiplexd/doas"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static"

DEPEND="${RDEPEND}
	virtual/yacc
	sys-libs/glibc"

src_compile() {
	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="-DDOAS_STATE_DIR=\\\"${DOAS_STATE_DIR}\\\" ${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	fowners root:root "/usr/bin/${PN}"
	fperms +s "/usr/bin/${PN}"

	doman doas.1
	doman doas.conf.5

	keepdir "${DOAS_STATE_DIR}"
	fowners root:root "${DOAS_STATE_DIR}"
	fperms 700 "${DOAS_STATE_DIR}"
}
