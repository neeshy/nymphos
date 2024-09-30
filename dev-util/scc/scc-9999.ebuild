# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A very fast accurate code counter"
HOMEPAGE="https://github.com/boyter/scc"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	EGO_SUM=(
		"github.com/boyter/gocodewalker v1.3.3"
		"github.com/boyter/gocodewalker v1.3.3/go.mod"
		"github.com/boyter/gocodewalker v1.3.4"
		"github.com/boyter/gocodewalker v1.3.4/go.mod"
		"github.com/coreos/go-systemd/v22 v22.5.0/go.mod"
		"github.com/cpuguy83/go-md2man/v2 v2.0.4/go.mod"
		"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964"
		"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/godbus/dbus/v5 v5.0.4/go.mod"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/inconshreveable/mousetrap v1.1.0"
		"github.com/inconshreveable/mousetrap v1.1.0/go.mod"
		"github.com/json-iterator/go v1.1.12"
		"github.com/json-iterator/go v1.1.12/go.mod"
		"github.com/mattn/go-colorable v0.1.12/go.mod"
		"github.com/mattn/go-colorable v0.1.13"
		"github.com/mattn/go-colorable v0.1.13/go.mod"
		"github.com/mattn/go-isatty v0.0.14/go.mod"
		"github.com/mattn/go-isatty v0.0.16/go.mod"
		"github.com/mattn/go-isatty v0.0.19"
		"github.com/mattn/go-isatty v0.0.19/go.mod"
		"github.com/mattn/go-runewidth v0.0.15"
		"github.com/mattn/go-runewidth v0.0.15/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
		"github.com/modern-go/reflect2 v1.0.2"
		"github.com/modern-go/reflect2 v1.0.2/go.mod"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/rivo/uniseg v0.2.0/go.mod"
		"github.com/rivo/uniseg v0.4.7"
		"github.com/rivo/uniseg v0.4.7/go.mod"
		"github.com/rs/xid v1.5.0/go.mod"
		"github.com/rs/zerolog v1.30.0"
		"github.com/rs/zerolog v1.30.0/go.mod"
		"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
		"github.com/spf13/cobra v1.8.1"
		"github.com/spf13/cobra v1.8.1/go.mod"
		"github.com/spf13/pflag v1.0.5"
		"github.com/spf13/pflag v1.0.5/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.3.0"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"golang.org/x/crypto v0.26.0"
		"golang.org/x/crypto v0.26.0/go.mod"
		"golang.org/x/sync v0.8.0"
		"golang.org/x/sync v0.8.0/go.mod"
		"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
		"golang.org/x/sys v0.0.0-20210927094055-39ccf1dd6fa6/go.mod"
		"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
		"golang.org/x/sys v0.6.0/go.mod"
		"golang.org/x/sys v0.23.0"
		"golang.org/x/sys v0.23.0/go.mod"
		"golang.org/x/text v0.17.0"
		"golang.org/x/text v0.17.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v2 v2.4.0"
		"gopkg.in/yaml.v2 v2.4.0/go.mod"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
	)

	go-module_set_globals

	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

src_compile() {
	ego build
}

src_install() {
	dobin scc
	dodoc {README,LANGUAGES}.md
}
