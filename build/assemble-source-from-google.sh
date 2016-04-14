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
#		cp common-utils/*.js "${instdir}/js" || exit 1
#		cp third_party/pcsc-lite/client-side/*.js "${instdir}/js" || exit 1
		touch "${instdir}/libpcsc.js"

		# Assemble all the files into a single tree
		files=(
			common/cpp/src/google_smart_card_common/formatting.h
			common/cpp/src/google_smart_card_common/logging/function_call_tracer.cc
			common/cpp/src/google_smart_card_common/logging/function_call_tracer.h
			common/cpp/src/google_smart_card_common/logging/hex_dumping.cc
			common/cpp/src/google_smart_card_common/logging/hex_dumping.h
			common/cpp/src/google_smart_card_common/logging/logging.cc
			common/cpp/src/google_smart_card_common/logging/logging.h
			common/cpp/src/google_smart_card_common/logging/mask_dumping.h
			common/cpp/src/google_smart_card_common/messaging/message_listener.h
			common/cpp/src/google_smart_card_common/messaging/typed_message.cc
			common/cpp/src/google_smart_card_common/messaging/typed_message.h
			common/cpp/src/google_smart_card_common/messaging/typed_message_listener.h
			common/cpp/src/google_smart_card_common/messaging/typed_message_router.cc
			common/cpp/src/google_smart_card_common/messaging/typed_message_router.h
			common/cpp/src/google_smart_card_common/multi_string.cc
			common/cpp/src/google_smart_card_common/multi_string.h
			common/cpp/src/google_smart_card_common/numeric_conversions.cc
			common/cpp/src/google_smart_card_common/numeric_conversions.h
			common/cpp/src/google_smart_card_common/optional.h
			common/cpp/src/google_smart_card_common/pp_var_utils/construction.cc
			common/cpp/src/google_smart_card_common/pp_var_utils/construction.h
			common/cpp/src/google_smart_card_common/pp_var_utils/copying.cc
			common/cpp/src/google_smart_card_common/pp_var_utils/copying.h
			common/cpp/src/google_smart_card_common/pp_var_utils/debug_dump.cc
			common/cpp/src/google_smart_card_common/pp_var_utils/debug_dump.h
			common/cpp/src/google_smart_card_common/pp_var_utils/extraction.cc
			common/cpp/src/google_smart_card_common/pp_var_utils/extraction.h
			common/cpp/src/google_smart_card_common/pp_var_utils/operations.h
			common/cpp/src/google_smart_card_common/pp_var_utils/struct_converter.h
			common/cpp/src/google_smart_card_common/requesting/async_request.cc
			common/cpp/src/google_smart_card_common/requesting/async_request.h
			common/cpp/src/google_smart_card_common/requesting/async_requests_storage.cc
			common/cpp/src/google_smart_card_common/requesting/async_requests_storage.h
			common/cpp/src/google_smart_card_common/requesting/js_requester.cc
			common/cpp/src/google_smart_card_common/requesting/js_requester.h
			common/cpp/src/google_smart_card_common/requesting/remote_call_adaptor.cc
			common/cpp/src/google_smart_card_common/requesting/remote_call_adaptor.h
			common/cpp/src/google_smart_card_common/requesting/remote_call_message.cc
			common/cpp/src/google_smart_card_common/requesting/remote_call_message.h
			common/cpp/src/google_smart_card_common/requesting/request_id.h
			common/cpp/src/google_smart_card_common/requesting/request_result.cc
			common/cpp/src/google_smart_card_common/requesting/request_result.h
			common/cpp/src/google_smart_card_common/requesting/requester.cc
			common/cpp/src/google_smart_card_common/requesting/requester.h
			common/cpp/src/google_smart_card_common/requesting/requester_message.cc
			common/cpp/src/google_smart_card_common/requesting/requester_message.h
			common/cpp/src/google_smart_card_common/thread_safe_unique_ptr.h
			common/cpp/src/google_smart_card_common/unique_ptr_utils.h
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/pcsc_lite.h
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/pcsc_lite_tracing_wrapper.cc
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/pcsc_lite_tracing_wrapper.h
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/scard_debug_dump.cc
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/scard_debug_dump.h
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/scard_structs_serialization.cc
			third_party/pcsc-lite/naclport/common/src/google_smart_card_pcsc_lite_common/scard_structs_serialization.h
			third_party/pcsc-lite/naclport/cpp_client/src/google_smart_card_pcsc_lite_client/global.cc
			third_party/pcsc-lite/naclport/cpp_client/src/google_smart_card_pcsc_lite_client/global.h
			third_party/pcsc-lite/naclport/cpp_client/src/pcsc_lite_over_requester.cc
			third_party/pcsc-lite/naclport/cpp_client/src/pcsc_lite_over_requester.h
			third_party/pcsc-lite/src-1.8.15/src/error.c
		)

		for file in "${files[@]}"; do
			instfile="${instdir}/$(basename "${file}")"

			sed 's@<google_smart_card_pcsc_lite_client/*.*/@<@;s@<google_smart_card_common/*.*/@<@;s@<google_smart_card_pcsc_lite_common/*.*/@<@;/#include "config.h"/ d;s@#include "misc.h"@#include "winscard.h"@' "${file}" > "${instfile}" || exit 1
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
