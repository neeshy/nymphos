# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module desktop shell-completion xdg

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://github.com/gokcehan/lf"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}

	src_compile () {
		gen/build.sh || die "build failed"
	}
else
	EGO_SUM=(
		"github.com/djherbis/times v1.6.0"
		"github.com/djherbis/times v1.6.0/go.mod"
		"github.com/fsnotify/fsnotify v1.9.0"
		"github.com/fsnotify/fsnotify v1.9.0/go.mod"
		"github.com/gdamore/encoding v1.0.1"
		"github.com/gdamore/encoding v1.0.1/go.mod"
		"github.com/gdamore/tcell/v2 v2.9.0"
		"github.com/gdamore/tcell/v2 v2.9.0/go.mod"
		"github.com/lucasb-eyer/go-colorful v1.2.0"
		"github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
		"github.com/mattn/go-runewidth v0.0.16"
		"github.com/mattn/go-runewidth v0.0.16/go.mod"
		"github.com/rivo/uniseg v0.2.0/go.mod"
		"github.com/rivo/uniseg v0.4.7"
		"github.com/rivo/uniseg v0.4.7/go.mod"
		"github.com/yuin/goldmark v1.4.13/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
		"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
		"golang.org/x/mod v0.8.0/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
		"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
		"golang.org/x/net v0.6.0/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
		"golang.org/x/sync v0.1.0/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
		"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
		"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
		"golang.org/x/sys v0.0.0-20220615213510-4f61da869c0c/go.mod"
		"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
		"golang.org/x/sys v0.5.0/go.mod"
		"golang.org/x/sys v0.35.0"
		"golang.org/x/sys v0.35.0/go.mod"
		"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
		"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
		"golang.org/x/term v0.5.0/go.mod"
		"golang.org/x/term v0.34.0"
		"golang.org/x/term v0.34.0/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.3/go.mod"
		"golang.org/x/text v0.3.7/go.mod"
		"golang.org/x/text v0.7.0/go.mod"
		"golang.org/x/text v0.14.0/go.mod"
		"golang.org/x/text v0.28.0"
		"golang.org/x/text v0.28.0/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
		"golang.org/x/tools v0.1.12/go.mod"
		"golang.org/x/tools v0.6.0/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	)

	go-module_set_globals

	SRC_URI="${HOMEPAGE}/archive/r${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	S="${WORKDIR}/${PN}-r${PV}"
	KEYWORDS="~amd64"

	src_compile () {
		version="r${PV}" gen/build.sh || die "build failed"
	}
fi

LICENSE="MIT"
SLOT="0"

src_install() {
	dobin lf
	doman lf.1
	dodoc README.md
	docinto examples
	dodoc etc/{lf.{csh,nu,vim},lfcd.{{,c}sh,nu},lfrc.example}

	newbashcomp etc/lf.bash lf
	bashcomp_alias lf lfcd
	newzshcomp etc/lf.zsh _lf
	dofishcomp etc/lf.fish
	insinto /usr/share/fish/vendor_functions.d
	doins etc/lfcd.fish

	domenu lf.desktop
}
