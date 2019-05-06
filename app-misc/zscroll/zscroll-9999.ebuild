# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{2,3,4,5,6,7} )

inherit distutils-r1

DESCRIPTION="A text scroller for panels or terminals"
HOMEPAGE="https://github.com/noctuid/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="zsh-completion"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	eapply "${FILESDIR}/${PN}-license.patch"
	if ! use zsh-completion; then
		eapply "${FILESDIR}/${PN}-zsh.patch"
	fi
	default
}
