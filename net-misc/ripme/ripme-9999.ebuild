# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Downloads albums in bulk"
HOMEPAGE="https://github.com/ripmeapp2/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	PATCHES=( "${FILESDIR}/${P}-gradle.patch" )
fi

LICENSE="MIT"
SLOT="0"

RESTRICT="network-sandbox"

RDEPEND="virtual/jre"

src_compile() {
	./gradlew \
		--info \
		--stacktrace \
		--no-daemon \
		--build-cache \
		--gradle-user-home "${T}/gradle_user_home" \
		--project-cache-dir "${T}/gradle_project_cache" \
		clean build -x test || die "gradle failed"
}

src_install() {
	local ver
	if [[ "${PV}" = 9999 ]]; then
		ver="$(git describe --tags --exclude latest-main | sed -E 's/-g([a-f0-9]+)$/-\1/g')"
	else
		ver="${PV}"
	fi

	newbin "${FILESDIR}/${PN}.sh" "${PN}"

	insinto "/opt/${PN}"
	newins "build/libs/${PN}-${ver}.jar" "${PN}.jar"
}
