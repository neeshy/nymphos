# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition - CLI Only"
HOMEPAGE="https://keepassxc.org/"

if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}.git"
else
	SRC_URI="https://github.com/keepassxreboot/${PN}/releases/download/${PV}/${P}-src.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="doc test yubikey"

RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	sys-libs/readline:0=
	sys-libs/zlib:=
	yubikey? (
		dev-libs/libusb:1
		sys-apps/pcsc-lite
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	dev-qt/linguist-tools:5
	doc? ( dev-ruby/asciidoctor )
"

PATCHES=( "${FILESDIR}/${P}-cli-only.patch" )

src_prepare() {
	if [[ "${PV}" != 9999 ]] && [[ ! -f .version ]] ; then
		echo "${PV}" >.version || die
	fi

	cmake_src_prepare
}

src_configure() {
	# https://github.com/keepassxreboot/keepassxc/issues/5801
	filter-flags -flto*

	local mycmakeargs=(
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
		# other means. We don't want the build system to enable it for us.
		-DWITH_CCACHE=OFF
		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_DOCS="$(usex doc)"
		-DWITH_XC_YUBIKEY="$(usex yubikey)"
	)

	cmake_src_configure
}
