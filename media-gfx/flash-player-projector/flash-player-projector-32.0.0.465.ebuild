# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Adobe Flash Player Projector"
HOMEPAGE="https://www.adobe.com/support/flashplayer/debug_downloads.html"

AF_URI="https://fpdownload.macromedia.com/pub/flashplayer/updaters/${PV%%.*}"
SRC_URI="
	!debug? (
		${AF_URI}/flash_player_sa_linux.x86_64.tar.gz -> flash_player_sa_linux-${PV}-x86_64.tar.gz
	)
	debug? (
		${AF_URI}/flash_player_sa_linux_debug.x86_64.tar.gz -> flash_player_sa_linux_debug-${PV}-x86_64.tar.gz
	)
"

LICENSE="AdobeFlash-11.x LGPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug"

RDEPEND="
	dev-libs/nss
	media-libs/mesa
	x11-libs/gtk+:2
"

S="${WORKDIR}"

src_install(){
	if use debug; then
		dobin flashplayerdebugger
	else
		dobin flashplayer
	fi
}
