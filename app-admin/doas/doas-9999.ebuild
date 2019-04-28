# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils toolchain-funcs git-2

[[ -z "${DOAS_STATE_DIR}" ]] && DOAS_STATE_DIR="/var/cache/${PN}"

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"

HOMEPAGE="https://github.com/multiplexd/doas"
SRC_URI=""
EGIT_REPO_URI="https://github.com/multiplexd/doas"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static"

DEPEND="${RDEPEND}
	virtual/yacc
	sys-libs/glibc"

src_prepare() {
	default
}

DDOAS_STATE_DIR='-DDOAS_STATE_DIR=\"/var/cache/doas\"'

src_compile() {
	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${DDOAS_STATE_DIR} ${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	insinto /usr/bin
	doins ${PN}
	fowners root:root /usr/bin/${PN}
	fperms 6755 /usr/bin/${PN}

	doman doas.1
	doman doas.conf.5

	keepdir "${DOAS_STATE_DIR}"
	fowners root:root "${DOAS_STATE_DIR}"
	fperms 0700 "${DOAS_STATE_DIR}"
}
