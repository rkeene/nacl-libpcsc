#include <ppapi/cpp/core.h>
#include <ppapi/cpp/instance.h>

#include <unistd.h>

#include "pcsc_nacl_global.h"
#include "dom_requests_manager.h"
#include "pcsc_nacl.h"

static DomRequestsManager *pcscNaClDRM = NULL;

void pcscNaClInit(pp::Instance *instance, pp::Core *core, const char *smartcardManagerAppId, const char *clientId) {
	DomRequestsManager::PpDelegateImpl *drmDelegateImpl;
	PcscNacl *pcsc_nacl;

	if (smartcardManagerAppId == NULL) {
		smartcardManagerAppId = "khpfeaanjngmcnplbdlpegiifgpfgdco";
	}

	if (clientId == NULL) {
		clientId = "UNKNOWN";
	}

	if (pcscNaClDRM == NULL) {
		drmDelegateImpl = new DomRequestsManager::PpDelegateImpl(instance, core);
	
		pcscNaClDRM = new DomRequestsManager("pcsc-nacl", drmDelegateImpl);
	}

	pcsc_nacl = new PcscNacl(pcscNaClDRM, smartcardManagerAppId, clientId);

	if (!pcsc_nacl->Initialize()) {
		return;
	}

	SetPcscNaclGlobalInstance(pcsc_nacl);

	return;
}

bool pcscNaClHandleMessage(const pp::Var &message) {
	return(pcscNaClDRM->HandleMessage(message));
}
