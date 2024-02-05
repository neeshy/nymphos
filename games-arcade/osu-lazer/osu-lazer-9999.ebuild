# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a *click* away!"
HOMEPAGE="https://osu.ppy.sh/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ppy/osu.git"
	DOTNET_VERSION="8.0"
else
	SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
	DOTNET_VERSION="6.0"
	KEYWORDS="amd64"
	PATCHES=( "${FILESDIR}/${P}-online.patch" )
	S="${WORKDIR}/osu-${PV}"
fi

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"

RESTRICT="network-sandbox"

DEPEND="virtual/dotnet-sdk:${DOTNET_VERSION}"
RDEPEND="${DEPEND}
	media-libs/libsdl2
	media-video/ffmpeg
	virtual/opengl"

src_compile() {
	local mydotnetargs=()
	[[ "${PV}" = 9999 ]] || mydotnetargs+=(/property:Version="${PV}")
	DOTNET_CLI_TELEMETRY_OPTOUT="1" dotnet publish osu.Desktop \
		--framework "net${DOTNET_VERSION}" \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--output output \
		"${mydotnetargs[@]}"
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
