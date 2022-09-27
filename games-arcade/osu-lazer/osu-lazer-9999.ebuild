# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="rhythm is just a *click* away!"
HOMEPAGE="https://osu.ppy.sh/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ppy/osu.git"
else
	SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/osu-${PV}"
fi

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"

RESTRICT="network-sandbox"

DEPEND="
	media-libs/libsdl2
	media-video/ffmpeg
	virtual/opengl
	virtual/dotnet-sdk"
RDEPEND="${DEPEND}"

src_compile() {
	dotnet publish osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--output output \
		--no-self-contained \
		$([[ "${PV}" = 9999 ]] || echo /property:Version="${PV}")
}

src_install() {
	newbin "${FILESDIR}/${PN}.sh" "${PN}"

	insinto "/opt/${PN}"
	doins -r output/*
	fperms +x "/opt/${PN}/osu!"

	insinto /usr/share/icons/hicolor/128x128/apps
	newins assets/lazer-nuget.png "${PN}.png"
	insinto /usr/share/icons/hicolor/1024x1024/apps
	newins assets/lazer.png "${PN}.png"
}
