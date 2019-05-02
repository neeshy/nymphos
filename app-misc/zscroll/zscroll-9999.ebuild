# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{2,3,4,5,6,7} )

inherit distutils-r1 git-r3

DESCRIPTION="A text scroller for panels or terminals"
HOMEPAGE="https://github.com/noctuid/zscroll"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	eapply "${FILESDIR}/${PN}-license.patch"
	if ! use zsh; then
		eapply "${FILESDIR}/${PN}-zsh.patch"
	fi
	default
}
