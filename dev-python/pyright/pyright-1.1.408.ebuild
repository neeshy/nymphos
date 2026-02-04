# Copyright 2026 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Static Type Checker for Python"
HOMEPAGE="https://microsoft.github.io/pyright/"
SRC_URI="https://github.com/microsoft/pyright/releases/download/${PV}/${PN}.tgz -> ${P}.tgz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-libs/nodejs"
BDEPEND="net-libs/nodejs[npm]"

src_unpack() {
	:
}

src_install() {
	local mynpmargs=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}/usr"
		--progress false
		--save false
		--verbose
	)

	npm "${mynpmargs[@]}" install "${DISTDIR}/${P}.tgz" || die "npm install failed"
}
