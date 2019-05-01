# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font toolchain-funcs xdg-utils

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="mirror://gnu/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="bold fontforge utils"

DEPEND="
	fontforge? (
		app-text/bdf2psf
		dev-lang/perl
		dev-perl/GD[png(-)]
		media-gfx/fontforge
		x11-apps/bdftopcf
	)
	bold? (
		app-text/mkbold-mkitalic
		x11-apps/bdftopcf
	)
"
RDEPEND="
	utils? (
		dev-lang/perl
		dev-perl/GD[png(-)]
	)
"

src_prepare() {
	sed -i -e 's/install -s/install/' src/Makefile || die
	default
}

src_compile() {
	if use fontforge || use utils; then
		if use bold; then
			dir="font/compiled"
		fi
		tc-export CC
		xdg_environment_reset
		makeargs=(
			CFLAGS="${CFLAGS}"
			BUILDFONT=$(usex fontforge 1 '')
		)
		emake  "${makeargs[@]}"
	elif use bold; then
		dir="font/precompiled"
	fi
	use bold && zcat "${dir}/${P}.bdf.gz" | mkbold | \
		bdftopcf | gzip > "${dir}/${PN}-bold.pcf.gz"
}

src_install() {
	makeargs+=(
		DESTDIR="${ED%/}"
		PCFDEST="${ED%/}${FONTDIR}"
		TTFDEST="${ED%/}${FONTDIR}"
		USRDIR=usr
	)
	use utils || makeargs+=( -C font )
	emake "${makeargs[@]}" install

	if use bold; then
		insinto "${FONTDIR}"
		if [[ -d font/compiled ]]; then
			dir="font/compiled"
		else
			dir="font/precompiled"
		fi
		doins "${dir}/${PN}-bold.pcf.gz"
	fi

	font_xfont_config
	font_fontconfig
}
