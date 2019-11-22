# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )

inherit git-r3 distutils-r1

DESCRIPTION="OpenMW Mod Manager"
HOMEPAGE="https://gitlab.com/portmod/portmod/wikis/home"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.com/portmod/portmod.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
app-arch/patool
sys-apps/bubblewrap
dev-python/ddt
dev-python/black
dev-python/pyyaml
dev-python/colorama
dev-python/appdirs
dev-python/GitPython
dev-python/RestrictedPython
dev-python/progressbar2"
RDEPEND="${DEPEND}"

