# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGO_PN="github.com/gokcehan/lf"

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://${EGO_PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~arm64"
	EGIT_COMMIT="r${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

LICENSE="MIT"
SLOT="0"

src_install() {
	#"${S}"/go-md2man -in src/${EGO_PN}/go-md2man.1.md -out go-md2man.1
	default
	doman "${PN}.1"
	dodoc README.md
}
