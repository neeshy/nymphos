# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"

MY_PN=doas
MY_P=${MY_PN}-${PV}
HOMEPAGE="https://github.com/slicer69/doas"
SRC_URI="https://github.com/slicer69/${MY_PN}/archive/6.0p3.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}"/doas-6.0p3

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	virtual/yacc
	dev-libs/libbsd"

PATCHES=(
		"${FILESDIR}"/shadow.patch
)

src_prepare()
{
	default
	sed -i 's/-Werror //' Makefile || die
}

src_configure()
{
	tc-export CC AR
}
