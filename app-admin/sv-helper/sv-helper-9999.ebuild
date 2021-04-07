# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Helper for runit-as-pid1 systems"
HOMEPAGE="https://github.com/rubyists/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="sys-process/runit"

src_install() {
	newbin sv-helper.sh sv-helper
	newbin rsvlog.sh rsvlog
	for cmd in svls sv-{list,find,enable,disable,start,stop,restart}; do
		dosym sv-helper "/usr/bin/${cmd}"
	done
	dodoc README.md
}
