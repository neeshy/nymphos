# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/doronbehar/termbox-go v0.0.0-20191006141301-8c9470559e05"
	"github.com/doronbehar/termbox-go v0.0.0-20191006141301-8c9470559e05/go.mod"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mattn/go-runewidth v0.0.4/go.mod"
	"gopkg.in/djherbis/times.v1 v1.2.0"
	"gopkg.in/djherbis/times.v1 v1.2.0/go.mod"
)

go-module_set_globals

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://github.com/gokcehan/${PN}"
SRC_URI="${HOMEPAGE}/archive/r${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${PN}-r${PV}"

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
