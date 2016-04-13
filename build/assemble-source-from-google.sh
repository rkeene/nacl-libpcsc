#! /usr/bin/env bash

# 2b98dedbf1b314ee8bfa3ac824efabee2c9b402d

ourScript="$(which "$0")"
if ! head -3 "${ourScript}" 2>/dev/null | grep 2b98dedbf1b314ee8bfa3ac824efabee2c9b402d >/dev/null; then
	echo "error: Unable to find ourselves" >&2

	exit 1
fi

cd "$(dirname "${ourScript}")" || exit 1
cd .. || exit 1

PATH="${PATH}:$(pwd)/bin"
export PATH

# Build the libpcsc we need
function assemblePCSC() {
	local version url pkg sha256
	local archive workdir

	pkg='google-chrome-smart-card-apps'
	version='20160317'
	sha256='a144a81be9fe72eb7698a7dc0c1aba6425220551cca432ba7e58984422a7cf46'

	archive="archive/${pkg}-${version}-nobinaries.zip"
	workdir="workdir-${RANDOM}${RANDOM}${RANDOM}${RANDOM}.build"

	extract "${archive}" "${workdir}" || return 1

	(
		cd "${workdir}" || exit 1

		# Copy out PC/SC headers for later use
		mkdir -p "${instdir}/include/PCSC" || exit 1
		cp third_party/pcsc-lite/src-*/src/PCSC/*.h "${instdir}/include/PCSC" || exit 1

		# Copy out JavaScript files for later use
		mkdir "${instdir}/js" || exit 1
#		cp common-utils/*.js "${instdir}/js" || exit 1
#		cp third_party/pcsc-lite/client-side/*.js "${instdir}/js" || exit 1

		# Assemble all the files into a single tree
		for file in logging.h scard_structs_serialization.h dom_requests_manager.h thread_safe_string_pool.h \
		    pp_var_utils.cc pp_var_utils.h scard_structs_serialization.cc dom_requests_manager.cc logging.cc; do
			find . -type f -name "${file}" -exec cp '{}' "${instdir}" ';'
		done
	) || return 1

	rm -rf "${workdir}"

	return 0
}

instdir="$(pwd)/pcsc/src"
rm -rf "${instdir}"
mkdir -p "${instdir}"

assemblePCSC || exit 1

exit 0
