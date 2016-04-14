#include <ppapi/cpp/core.h>
#include <ppapi/cpp/instance.h>
#include "global.h"

static google_smart_card::TypedMessageRouter tmr;

void pcscNaClInit(pp::Instance *instance, pp::Core *core) {
	new google_smart_card::PcscLiteOverRequesterGlobal(&tmr, instance, core);

	return;
}

bool pcscNaClHandleMessage(const pp::Var &message) {
	return(tmr.OnMessageReceived(message));
}
