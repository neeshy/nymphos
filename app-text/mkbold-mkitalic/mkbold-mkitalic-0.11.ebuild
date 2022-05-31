# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Make X11 BDF fonts bold and/or italic"
HOMEPAGE="https://hp.vector.co.jp/authors/VA013651/freeSoftware/${PN}.html"
SRC_URI="https://hp.vector.co.jp/authors/VA013651/lib/${P}.tar.bz2"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	dodoc README ALGORITHM
}
