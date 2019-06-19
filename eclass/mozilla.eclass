inherit check-reqs gnome2-utils fdo-mime

EXPORT_FUNCTIONS pkg_pretend pkg_preinst pkg_postinst pkg_postrm pkg_setup


###
# Package
###

mozilla_pkg_pretend() {
	# Ensure that we have enough disk space to compile:
	CHECKREQS_DISK_BUILD="${REQUIRED_BUILDSPACE}"
	check-reqs_pkg_setup
}

mozilla_pkg_preinst() {
	gnome2_icon_savelist
}

mozilla_pkg_postinst() {
	# Update mimedb for the new .desktop file:
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

mozilla_pkg_postrm() {
	gnome2_icon_cache_update
}

mozilla_pkg_setup() {
	# Nested configure scripts in mozilla products generate unrecognized
	# options false positives when toplevel configure passes downwards:
	export QA_CONFIGURE_OPTIONS=".*"
}

###
# Configuration
###

mozconfig_init() {
	cat << EOF > "${S}/.mozconfig"
ac_add_options --enable-application=browser
ac_add_options --prefix=/usr
EOF
}

mozconfig() {
	echo "ac_add_options --${1}-${2}" >> "${S}/.mozconfig"
}

mozconfig_loop() {
	local prefix="${1}"
	shift

	for option in "${@}"; do
		mozconfig "${prefix}" "${option}"
	done
}

mozconfig_usex() {
	local prefix="$(usex "${3}" "${1}" "${2}")"
	shift 2

	if [[ "${#}" -gt 1 ]]; then
		shift
	fi

	mozconfig_loop "${prefix}" "${@}"
}

mozconfig_enable() {
	mozconfig_loop enable "${@}"
}

mozconfig_disable() {
	mozconfig_loop disable "${@}"
}

mozconfig_with() {
	mozconfig_loop with "${@}"
}

mozconfig_without() {
	mozconfig_loop without "${@}"
}

mozconfig_use_enable() {
	mozconfig_usex {en,dis}able "${@}"
}

mozconfig_use_with() {
	mozconfig_usex with{,out} "${@}"
}

mozconfig_var() {
	echo "mk_add_options ${1}=${2}" >> "${S}/.mozconfig"
}

mozconfig_export() {
	echo "export ${1}=${2}" >> "${S}/.mozconfig"
}
