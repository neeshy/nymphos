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

pozconfig_init() {
	cat << EOF > "${S}/.mozconfig"
ac_add_options --enable-application=browser
ac_add_options --prefix=/usr
EOF
}

pozconfig() {
	echo "ac_add_options --${1}-${2}" >> "${S}/.mozconfig"
}

pozconfig_loop() {
	local prefix="${1}"
	shift

	for option in "${@}"; do
		pozconfig "${prefix}" "${option}"
	done
}

pozconfig_usex() {
	local prefix="$(usex "${3}" "${1}" "${2}")"
	shift 2

	if [[ "${#}" -gt 1 ]]; then
		shift
	fi

	pozconfig_loop "${prefix}" "${@}"
}

pozconfig_enable() {
	pozconfig_loop enable "${@}"
}

pozconfig_disable() {
	pozconfig_loop disable "${@}"
}

pozconfig_with() {
	pozconfig_loop with "${@}"
}

pozconfig_without() {
	pozconfig_loop without "${@}"
}

pozconfig_use_enable() {
	pozconfig_usex {en,dis}able "${@}"
}

pozconfig_use_with() {
	pozconfig_usex with{,out} "${@}"
}

pozconfig_var() {
	echo "mk_add_options ${1}=${2}" >> "${S}/.mozconfig"
}

pozconfig_export() {
	echo "export ${1}=${2}" >> "${S}/.mozconfig"
}
