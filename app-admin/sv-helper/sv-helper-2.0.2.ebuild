# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Helper for runit-as-pid1 systems"
HOMEPAGE="https://github.com/rubyists/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-process/runit"

src_install() {
	exeinto /bin
	newexe sv-helper.sh sv-helper
	newexe rsvlog.sh rsvlog
	for cmd in svls sv-{list,find,enable,disable,start,stop,restart}; do
		dosym sv-helper "/bin/${cmd}"
	done
	dodoc README.md
}
