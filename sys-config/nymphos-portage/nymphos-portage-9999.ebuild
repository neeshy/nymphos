# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A portage configuration necessary for NymphOS binhosts"
HOMEPAGE="https://nymphos.ga/"

LICENSE="CC0-1.0"
SLOT="0"

S="${WORKDIR}"

src_install() {
	local repopath="$(portageq get_repo_path ${PORTAGE_CONFIGROOT} nymphos)"
	local filesdir="${repopath}/${CATEGORY}/${PN}/files"

	local file
	for file in "${filesdir}"/*; do
		dosym "${file}" "${PORTAGE_CONFIGROOT%/}/etc/portage/$(basename "${file}")"
	done
}
