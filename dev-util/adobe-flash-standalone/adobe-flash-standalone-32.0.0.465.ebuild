# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Adobe Flash Player Projector"
HOMEPAGE="
	https://www.adobe.com/products/flashplayer.html
	https://get.adobe.com/flashplayer/
	https://helpx.adobe.com/security/products/flash-player.html
"
SRC_URI="https://fpdownload.macromedia.com/pub/flashplayer/updaters/${PV%%.*}/flash_player_sa_linux.x86_64.tar.gz -> ${P}.tar.gz"

LICENSE="AdobeFlash-11.x LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/nss
	media-libs/mesa
	x11-libs/gtk+:2
"

S="${WORKDIR}"

src_install(){
	dobin flashplayer
}
