# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature shell-completion

DESCRIPTION="Fast and secure initramfs generator"
HOMEPAGE="https://github.com/anatol/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	EGO_SUM=(
		"github.com/anatol/clevis.go v0.0.0-20241007163622-6a2093f0988d"
		"github.com/anatol/clevis.go v0.0.0-20241007163622-6a2093f0988d/go.mod"
		"github.com/anatol/devmapper.go v0.0.0-20230829043248-59ac2b9706ba"
		"github.com/anatol/devmapper.go v0.0.0-20230829043248-59ac2b9706ba/go.mod"
		"github.com/anatol/go-udev v0.0.0-20220806124306-5f28d899f64f"
		"github.com/anatol/go-udev v0.0.0-20220806124306-5f28d899f64f/go.mod"
		"github.com/anatol/luks.go v0.0.0-20240507052915-92f8bb765f98"
		"github.com/anatol/luks.go v0.0.0-20240507052915-92f8bb765f98/go.mod"
		"github.com/anatol/smart.go v0.0.0-20241007162712-be6d7524480a"
		"github.com/anatol/smart.go v0.0.0-20241007162712-be6d7524480a/go.mod"
		"github.com/anatol/tang.go v0.0.0-20241007163510-6e32b5887d69"
		"github.com/anatol/tang.go v0.0.0-20241007163510-6e32b5887d69/go.mod"
		"github.com/anatol/vmtest v0.0.0-20230711210602-87511df0d4bc"
		"github.com/anatol/vmtest v0.0.0-20230711210602-87511df0d4bc/go.mod"
		"github.com/cavaliergopher/cpio v1.0.1"
		"github.com/cavaliergopher/cpio v1.0.1/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/decred/dcrd/dcrec/secp256k1/v4 v4.3.0"
		"github.com/decred/dcrd/dcrec/secp256k1/v4 v4.3.0/go.mod"
		"github.com/dgryski/go-camellia v0.0.0-20191119043421-69a8a13fb23d"
		"github.com/dgryski/go-camellia v0.0.0-20191119043421-69a8a13fb23d/go.mod"
		"github.com/goccy/go-json v0.10.3"
		"github.com/goccy/go-json v0.10.3/go.mod"
		"github.com/google/go-tpm v0.9.1"
		"github.com/google/go-tpm v0.9.1/go.mod"
		"github.com/google/renameio/v2 v2.0.0"
		"github.com/google/renameio/v2 v2.0.0/go.mod"
		"github.com/insomniacslk/dhcp v0.0.0-20240829085014-a3a4c1f04475"
		"github.com/insomniacslk/dhcp v0.0.0-20240829085014-a3a4c1f04475/go.mod"
		"github.com/jessevdk/go-flags v1.6.1"
		"github.com/jessevdk/go-flags v1.6.1/go.mod"
		"github.com/jzelinskie/whirlpool v0.0.0-20201016144138-0675e54bb004"
		"github.com/jzelinskie/whirlpool v0.0.0-20201016144138-0675e54bb004/go.mod"
		"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
		"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
		"github.com/klauspost/compress v1.17.11"
		"github.com/klauspost/compress v1.17.11/go.mod"
		"github.com/lestrrat-go/backoff/v2 v2.0.8"
		"github.com/lestrrat-go/backoff/v2 v2.0.8/go.mod"
		"github.com/lestrrat-go/blackmagic v1.0.2"
		"github.com/lestrrat-go/blackmagic v1.0.2/go.mod"
		"github.com/lestrrat-go/httpcc v1.0.1"
		"github.com/lestrrat-go/httpcc v1.0.1/go.mod"
		"github.com/lestrrat-go/iter v1.0.2"
		"github.com/lestrrat-go/iter v1.0.2/go.mod"
		"github.com/lestrrat-go/jwx v1.2.30"
		"github.com/lestrrat-go/jwx v1.2.30/go.mod"
		"github.com/lestrrat-go/option v1.0.0/go.mod"
		"github.com/lestrrat-go/option v1.0.1"
		"github.com/lestrrat-go/option v1.0.1/go.mod"
		"github.com/pierrec/lz4/v4 v4.1.21"
		"github.com/pierrec/lz4/v4 v4.1.21/go.mod"
		"github.com/pkg/errors v0.9.1"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.6.1/go.mod"
		"github.com/stretchr/testify v1.7.1/go.mod"
		"github.com/stretchr/testify v1.9.0"
		"github.com/stretchr/testify v1.9.0/go.mod"
		"github.com/tmc/scp v0.0.0-20170824174625-f7b48647feef"
		"github.com/tmc/scp v0.0.0-20170824174625-f7b48647feef/go.mod"
		"github.com/u-root/uio v0.0.0-20240224005618-d2acac8f3701"
		"github.com/u-root/uio v0.0.0-20240224005618-d2acac8f3701/go.mod"
		"github.com/ulikunitz/xz v0.5.12"
		"github.com/ulikunitz/xz v0.5.12/go.mod"
		"github.com/vishvananda/netlink v1.3.0"
		"github.com/vishvananda/netlink v1.3.0/go.mod"
		"github.com/vishvananda/netns v0.0.4"
		"github.com/vishvananda/netns v0.0.4/go.mod"
		"github.com/xi2/xz v0.0.0-20171230120015-48954b6210f8"
		"github.com/xi2/xz v0.0.0-20171230120015-48954b6210f8/go.mod"
		"github.com/yookoala/realpath v1.0.0"
		"github.com/yookoala/realpath v1.0.0/go.mod"
		"golang.org/x/crypto v0.28.0"
		"golang.org/x/crypto v0.28.0/go.mod"
		"golang.org/x/net v0.30.0"
		"golang.org/x/net v0.30.0/go.mod"
		"golang.org/x/sys v0.2.0/go.mod"
		"golang.org/x/sys v0.10.0/go.mod"
		"golang.org/x/sys v0.26.0"
		"golang.org/x/sys v0.26.0/go.mod"
		"golang.org/x/term v0.25.0"
		"golang.org/x/term v0.25.0/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
		"gopkg.in/yaml.v3 v3.0.1"
		"gopkg.in/yaml.v3 v3.0.1/go.mod"
	)

	go-module_set_globals

	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="man"

BDEPEND="man? ( app-text/ronn-ng )"

PATCHES=(
	"${FILESDIR}/${PN}-fix-lib-path.patch"
	"${FILESDIR}/${PN}-fix-console-font-path.patch"
)

src_compile() {
	if use man; then
		ronn docs/manpage.md || die "ronn failed"
	fi

	cd generator || die "cd failed"
	ego build

	cd ../init || die "cd failed"
	ego build
}

src_install() {
	newbin generator/generator booster
	exeinto /usr/lib/booster
	doexe init/init
	insinto /etc
	: | newins - booster.yaml
	use man && newman docs/manpage.1 booster.1
	newbashcomp contrib/completion/bash booster
}

pkg_postinst() {
	optfeature "emergency shell at boot time" sys-apps/busybox[static]
	optfeature "clevis Yubikey challenge-response support" sys-auth/yubikey-personalization-gui
	optfeature "systemd-cryptenroll with FIDO2" sys-apps/systemd[fido2]
}
