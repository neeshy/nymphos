# Copyright 2023 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="rhythm is just a *click* away!"
HOMEPAGE="https://osu.ppy.sh/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ppy/osu.git"
else
	SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/osu-${PV}"
fi

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"

RESTRICT="network-sandbox"

RDEPEND="
	media-libs/libsdl2
	media-video/ffmpeg
	virtual/dotnet-sdk:6.0
	virtual/opengl"
DEPEND="virtual/dotnet-sdk:6.0"

PATCHES=( "${FILESDIR}/${P}-online.patch" )

src_compile() {
	DOTNET_CLI_TELEMETRY_OPTOUT="1" dotnet publish osu.Desktop \
		--framework net6.0 \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--output output \
		$([[ "${PV}" = 9999 ]] || printf '/property:Version=%s' "${PV}")
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
