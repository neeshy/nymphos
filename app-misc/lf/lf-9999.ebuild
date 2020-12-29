# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://github.com/gokcehan/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	EGO_SUM=(
		"github.com/gdamore/encoding v1.0.0"
		"github.com/gdamore/encoding v1.0.0/go.mod"
		"github.com/gdamore/tcell/v2 v2.0.0"
		"github.com/gdamore/tcell/v2 v2.0.0/go.mod"
		"github.com/lucasb-eyer/go-colorful v1.0.3"
		"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
		"github.com/mattn/go-runewidth v0.0.7/go.mod"
		"github.com/mattn/go-runewidth v0.0.9"
		"github.com/mattn/go-runewidth v0.0.9/go.mod"
		"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756"
		"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
		"golang.org/x/text v0.3.0"
		"golang.org/x/text v0.3.0/go.mod"
		"gopkg.in/djherbis/times.v1 v1.2.0"
		"gopkg.in/djherbis/times.v1 v1.2.0/go.mod"
	)

	go-module_set_globals

	SRC_URI="${HOMEPAGE}/archive/r${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${PN}-r${PV}"
fi

LICENSE="MIT"
SLOT="0"

src_compile () {
	go build || die
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README.md
	docinto examples
	dodoc etc/{lf.{csh,vim},lfcd.{,c}sh,lfrc.example}

	insinto /usr/share/zsh/site-functions
	newins etc/lf.zsh _lf
	insinto /usr/share/fish/vendor_completions.d
	doins etc/lf.fish
	insinto /usr/share/fish/vendor_functions.d
	doins etc/lfcd.fish
}
