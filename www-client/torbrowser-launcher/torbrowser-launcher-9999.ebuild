# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A program to download, update, and run the Tor Browser Bundle"
HOMEPAGE="https://gitlab.torproject.org/tpo/applications/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="apparmor"

RESTRICT="test"

RDEPEND="
	app-crypt/gpgme[python,${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},widgets]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	apparmor? ( sys-libs/libapparmor )"
DEPEND="dev-python/distro[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all

	# delete apparmor profiles
	if ! use apparmor; then
		rm -r "${D}/etc/apparmor.d" || die "Failed to remove apparmor profiles"
		rmdir "${D}/etc" || die "Failed to remove empty directory"
	fi
}
