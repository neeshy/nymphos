# Copyright 1999-2021 Gentoo Authors
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

	src_compile () {
		gen/build.sh || die
	}
else
	EGO_SUM=(
		"github.com/gdamore/encoding v1.0.0"
		"github.com/gdamore/encoding v1.0.0/go.mod"
		"github.com/gokcehan/tcell/v2 v2.2.1-0.20210329222449-4dd2d52e83ef"
		"github.com/gokcehan/tcell/v2 v2.2.1-0.20210329222449-4dd2d52e83ef/go.mod"
		"github.com/lucasb-eyer/go-colorful v1.0.3"
		"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
		"github.com/mattn/go-runewidth v0.0.10"
		"github.com/mattn/go-runewidth v0.0.10/go.mod"
		"github.com/rivo/uniseg v0.1.0"
		"github.com/rivo/uniseg v0.1.0/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/term v0.0.0-20201210144234-2321bbc49cbf/go.mod"
		"golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d"
		"golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d/go.mod"
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

	src_compile () {
		version="r${PV}" gen/build.sh || die
	}
fi

LICENSE="MIT"
SLOT="0"

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README.md
	docinto examples
	dodoc etc/{lf.{csh,vim},lfcd.{,c}sh,lfrc.example}

	insinto /usr/share/bash-completion/completions
	newins etc/lf.bash lf
	insinto /usr/share/zsh/site-functions
	newins etc/lf.zsh _lf
	insinto /usr/share/fish/vendor_completions.d
	doins etc/lf.fish
	insinto /usr/share/fish/vendor_functions.d
	doins etc/lfcd.fish
}
