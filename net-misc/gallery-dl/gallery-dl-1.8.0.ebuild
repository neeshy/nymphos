# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="Command-line program to download image-galleries and -collections from several image hosting sites"
HOMEPAGE="https://github.com/mikf/gallery-dl"
SRC_URI="https://github.com/mikf/gallery-dl/releases/download/v1.8.0/gallery_dl-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/gallery_dl-${PV}"
