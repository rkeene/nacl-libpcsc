#ifndef PCSC_NACL_H
#define PCSC_NACL_H 1
#ifdef __cplusplus
#include <ppapi/cpp/core.h>
#include <ppapi/cpp/instance.h>

void pcscNaClInit(pp::Instance *instance, pp::Core *core, const char *smartcardManagerAppId, const char *clientId);
bool pcscNaClHandleMessage(const pp::Var &message);

#endif
#endif
