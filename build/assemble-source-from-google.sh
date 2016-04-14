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
		rm -f "${instdir}/libpcsc.js"
		files=(
			third_party/closure-library/src-20160208/closure/goog/base.js
			third_party/closure-library/src-20160208/closure/goog/math/integer.js
			common/js/src/fixed-size-integer.js
			third_party/closure-library/src-20160208/closure/goog/debug/error.js
			third_party/closure-library/src-20160208/closure/goog/dom/nodetype.js
			third_party/closure-library/src-20160208/closure/goog/string/string.js
			third_party/closure-library/src-20160208/closure/goog/asserts/asserts.js
			third_party/closure-library/src-20160208/closure/goog/array/array.js
			third_party/closure-library/src-20160208/closure/goog/functions/functions.js
			third_party/closure-library/src-20160208/closure/goog/math/math.js
			third_party/closure-library/src-20160208/closure/goog/iter/iter.js
			third_party/closure-library/src-20160208/closure/goog/json/json.js
			third_party/closure-library/src-20160208/closure/goog/object/object.js
			third_party/closure-library/src-20160208/closure/goog/structs/structs.js
			third_party/closure-library/src-20160208/closure/goog/structs/map.js
			common/js/src/logging/debug-dump.js
			third_party/closure-library/src-20160208/closure/goog/dom/tagname.js
			third_party/closure-library/src-20160208/closure/goog/dom/tags.js
			third_party/closure-library/src-20160208/closure/goog/string/typedstring.js
			third_party/closure-library/src-20160208/closure/goog/string/const.js
			third_party/closure-library/src-20160208/closure/goog/html/safestyle.js
			third_party/closure-library/src-20160208/closure/goog/html/safestylesheet.js
			third_party/closure-library/src-20160208/closure/goog/fs/url.js
			third_party/closure-library/src-20160208/closure/goog/i18n/bidi.js
			third_party/closure-library/src-20160208/closure/goog/html/safeurl.js
			third_party/closure-library/src-20160208/closure/goog/html/trustedresourceurl.js
			third_party/closure-library/src-20160208/closure/goog/labs/useragent/util.js
			third_party/closure-library/src-20160208/closure/goog/labs/useragent/browser.js
			third_party/closure-library/src-20160208/closure/goog/html/safehtml.js
			third_party/closure-library/src-20160208/closure/goog/html/safescript.js
			third_party/closure-library/src-20160208/closure/goog/html/uncheckedconversions.js
			third_party/closure-library/src-20160208/closure/goog/structs/collection.js
			third_party/closure-library/src-20160208/closure/goog/structs/set.js
			third_party/closure-library/src-20160208/closure/goog/labs/useragent/engine.js
			third_party/closure-library/src-20160208/closure/goog/labs/useragent/platform.js
			third_party/closure-library/src-20160208/closure/goog/useragent/useragent.js
			third_party/closure-library/src-20160208/closure/goog/debug/debug.js
			third_party/closure-library/src-20160208/closure/goog/debug/logrecord.js
			third_party/closure-library/src-20160208/closure/goog/debug/logbuffer.js
			third_party/closure-library/src-20160208/closure/goog/debug/logger.js
			third_party/closure-library/src-20160208/closure/goog/debug/relativetimeprovider.js
			third_party/closure-library/src-20160208/closure/goog/debug/formatter.js
			third_party/closure-library/src-20160208/closure/goog/log/log.js
			third_party/closure-library/src-20160208/closure/goog/structs/circularbuffer.js
			common/js/src/logging/log-buffer.js
			third_party/closure-library/src-20160208/closure/goog/debug/console.js
			common/js/src/logging/logging.js
			common/js/src/random.js
			third_party/closure-library/src-20160208/closure/goog/disposable/idisposable.js
			third_party/closure-library/src-20160208/closure/goog/disposable/disposable.js
			third_party/closure-library/src-20160208/closure/goog/promise/thenable.js
			third_party/closure-library/src-20160208/closure/goog/async/freelist.js
			third_party/closure-library/src-20160208/closure/goog/async/workqueue.js
			third_party/closure-library/src-20160208/closure/goog/debug/entrypointregistry.js
			third_party/closure-library/src-20160208/closure/goog/async/nexttick.js
			third_party/closure-library/src-20160208/closure/goog/async/run.js
			third_party/closure-library/src-20160208/closure/goog/promise/resolver.js
			third_party/closure-library/src-20160208/closure/goog/promise/promise.js
			third_party/closure-library/src-20160208/closure/goog/events/browserfeature.js
			third_party/closure-library/src-20160208/closure/goog/events/eventid.js
			third_party/closure-library/src-20160208/closure/goog/events/event.js
			third_party/closure-library/src-20160208/closure/goog/events/eventtype.js
			third_party/closure-library/src-20160208/closure/goog/reflect/reflect.js
			third_party/closure-library/src-20160208/closure/goog/events/browserevent.js
			third_party/closure-library/src-20160208/closure/goog/events/listenable.js
			third_party/closure-library/src-20160208/closure/goog/events/listener.js
			third_party/closure-library/src-20160208/closure/goog/events/listenermap.js
			third_party/closure-library/src-20160208/closure/goog/events/events.js
			third_party/closure-library/src-20160208/closure/goog/events/eventtarget.js
			third_party/closure-library/src-20160208/closure/goog/timer/timer.js
			third_party/closure-library/src-20160208/closure/goog/messaging/messagechannel.js
			third_party/closure-library/src-20160208/closure/goog/messaging/abstractchannel.js
			common/js/src/messaging/message-channel-pinging.js
			common/js/src/messaging/typed-message.js
			common/js/src/messaging/port-message-channel.js
			common/js/src/nacl-module/nacl-module-log-messages-receiver.js
			common/js/src/nacl-module/nacl-module-messaging-channel.js
			third_party/closure-library/src-20160208/closure/goog/dom/browserfeature.js
			third_party/closure-library/src-20160208/closure/goog/dom/safe.js
			third_party/closure-library/src-20160208/closure/goog/math/coordinate.js
			third_party/closure-library/src-20160208/closure/goog/math/size.js
			third_party/closure-library/src-20160208/closure/goog/dom/dom.js
			common/js/src/nacl-module/nacl-module.js
			common/js/src/requesting/remote-call-message.js
			common/js/src/requesting/request-handler.js
			common/js/src/requesting/requester-message.js
			common/js/src/requesting/request-receiver.js
			common/js/src/requesting/requester.js
			third_party/closure-library/src-20160208/closure/goog/structs/queue.js
			third_party/pcsc-lite/naclport/common/src/constants.js
			third_party/pcsc-lite/naclport/js_client/src/api.js
			third_party/pcsc-lite/naclport/js_client/src/context.js
			third_party/pcsc-lite/naclport/cpp_client/src/nacl-client-request-handler.js
			third_party/pcsc-lite/naclport/cpp_client/src/nacl-client-backend.js
		)
		cat "${files[@]}" | sed '
			/^ *goog\.require(/ d;
			s@^goog\.DEPENDENCIES_ENABLED = .*$@goog.DEPENDENCIES_ENABLED = false;@
		' > "${instdir}/libpcsc.js.new" || exit 1
		mv "${instdir}/libpcsc.js.new" "${isntdir}/libpcsc.js" || exit 1

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
