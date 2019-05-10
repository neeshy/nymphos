# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGO_PN="github.com/gokcehan/${PN}"

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://${EGO_PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit golang-vcs
else
	KEYWORDS="amd64 arm arm64"
	EGIT_COMMIT="r${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

LICENSE="MIT"
SLOT="0"
IUSE="optimize examples"

DEPEND="
	dev-go/termbox-go
	dev-go/go-runewidth
"

src_compile() {
	if use optimize; then
		export CGO_ENABLED="0"
		EGO_BUILD_FLAGS="-ldflags=-s"
	fi
	golang-build_src_compile
}

src_install() {
	dobin "${PN}"
	doman "src/${EGO_PN}/${PN}.1"
	dodoc "src/${EGO_PN}/README.md"
	if use examples; then
		docinto examples
		dodoc "src/${EGO_PN}/etc/"{lf.fish,lf.vim,lfcd.fish,lfcd.sh,lfrc.example}
	fi
}
