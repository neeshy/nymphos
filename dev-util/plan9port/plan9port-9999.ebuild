# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs git-r3 readme.gentoo-r1

DESCRIPTION="Plan 9 from User Space"
HOMEPAGE="https://9fans.github.io/plan9port/
	https://github.com/9fans/plan9port"
EGIT_REPO_URI="https://github.com/9fans/${PN}.git"

LICENSE="9base BSD-4 MIT LGPL-2.1 BigelowHolmes"
SLOT="0"
IUSE="X truetype"

DEPEND="
	X? ( x11-apps/xauth )
	truetype? (
		media-libs/freetype
	    media-libs/fontconfig
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-noexecstack.patch"
	"${FILESDIR}/${PN}-cflags.patch"
	"${FILESDIR}/${PN}-builderr.patch"
)

S="${WORKDIR}/${MY_P}"

DOC_CONTENTS="Plan 9 from User Space has been successfully installed into
${PLAN9}. Your PLAN9 and PATH environment variables have
also been appropriately set, please use env-update and
source /etc/profile to bring that into immediate effect.

Please note that ${PLAN9}/bin has been appended to the
*end* or your PATH to prevent conflicts. To use the Plan9
versions of common UNIX tools, use the absolute path:
${PLAN9}/bin or the 9 command (eg: 9 troff)

Please report any bugs to bugs.gentoo.org, NOT Plan9Port."

PLAN9="/opt/plan9"
EPLAN9="${EPREFIX}${PLAN9}"
QA_MULTILIB_PATHS="${PLAN9}/.*/.*"

src_prepare() {
	default

	# don't hardcode /bin and /usr/bin in PATH
	sed -i '/PATH/s,/bin:/usr/bin:,,' INSTALL || die "sed on INSTALL failed"

	# don't hardcode /usr/{,local/}include and prefix /usr/include/*
	sed -Ei -e 's,-I/usr(|/local)/include ,,g' \
		-e "s,-I/usr(|/local)/include,-I${EPREFIX}/usr\1/include,g" \
		src/cmd/fontsrv/freetyperules.sh INSTALL $(find -name makefile) ||
		die "sed failed"

	# Fix paths, done in place of ./INSTALL -c
	einfo "Fixing hard-coded /usr/local/plan9 paths"
	sed -i "s,/usr/local/plan9,${EPLAN9},g" $(grep -lr /usr/local/plan9) ||
		die "sed failed"
}

src_configure() {
	local -a myconf

	if use X; then
		myconf+=( X11="${EPREFIX}/usr" WSYSTYPE=x11 )
	else
		myconf+=( WSYSTYPE=nowsys )
	fi

	if use truetype; then
		myconf+=( FONTSRV=fontsrv )
	else
		myconf+=( FONTSRV= )
	fi

	printf '%s\n' "${myconf[@]}" >> LOCAL.config ||
		die "cannot create configuration"
}

src_compile() {
	export NPROC="$(makeopts_jobs)"
	export CC9="$(tc-getCC)"

	# The INSTALL script builds mk then [re]builds everything using that
	einfo "Compiling Plan 9 from User Space can take a very long time"
	einfo "depending on the speed of your computer. Please be patient!"
	./INSTALL -b || die "Please report bugs to bugs.gentoo.org, NOT Plan9Port."
}

src_install() {
	readme.gentoo_create_doc

	# P9P's man does not handle compression
	docompress -x "${PLAN9}/man"

	# do* plays with the executable bit, and we should not modify them
	cp -a * "${ED}/${PLAN9}"

	# build the environment variables and install them in env.d
	newenvd - 60plan9 <<-EOF
		PLAN9="${EPLAN9}"
		PATH="${EPLAN9}/bin"
		ROOTPATH="${EPLAN9}/bin"
		MANPATH="${EPLAN9}/man"
	EOF
}

pkg_postinst() {
	readme.gentoo_print_elog
}
