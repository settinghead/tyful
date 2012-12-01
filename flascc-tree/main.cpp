/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "AS3/AS3.h"
#include <Flash++.h>
#include <pthread.h>
#include "../cpp/cpp/model/PolarCanvas.h"
extern "C" {
#include "sys/thr.h"
}

static pthread_barrier_t barrier;
static volatile long tid = 0;

using namespace AS3::local;

static var monitorSlapThreadProc(void *arg){

	pthread_barrier_wait(&barrier); // wait for main to pick up tid
	pthread_barrier_wait(&barrier); // wait for main to create messageChannel
	
	pthread_t thread;

	flash::system::Worker worker = internal::get_Worker();
	flash::system::MessageChannel msgChan = worker->getSharedProperty("com.mycompany.messageChannel");


	PolarCanvas* canvas = PolarCanvas::current;
	pthread_mutex_lock(&canvas->next_slap_mutex);
    for(;;){
        pthread_cond_wait(&canvas->next_slap_cv, &canvas->next_slap_mutex);
        msgChan->send(_int::_new(0)); // send current timestamp
    }
    pthread_mutex_unlock(&canvas->next_slap_mutex);
}

void setCallbackFunction() __attribute__((used,
	annotate("as3sig:public function setCallbackFunction(_callback:Function):void"),
	annotate("as3package:polartree.PolarTree")));
void setCallbackFunction(){
    inline_as3("callback = _callback;");
}


static var channelMessageEventListenerProc(void *arg, var as3Args)
{
  inline_as3("if(callback!=null) {callback.call();}");
  return internal::_undefined;
}

int main()
{
    // We still need a main function for the SWC. this function must be called
    // so that all the static init code is executed before any library functions
    // are used.
    //
    // The main function for a library must throw an exception so that it does
    // not return normally. Returning normally would cause the static
    // destructors to be executed leaving the library in an unuseable state.
	srand ( time(NULL) );

    inline_as3("var callback:Function = null;");


	pthread_barrier_init(&barrier, NULL, 2);

  	pthread_t thread;

	pthread_barrier_wait(&barrier); // wait for tid to get initialized

	flash::system::Worker selfWorker = internal::get_Worker();
	flash::system::Worker otherWorker = internal::get_Worker(tid);
	flash::system::MessageChannel msgChan = otherWorker->createMessageChannel(selfWorker);
	otherWorker->setSharedProperty("com.mycompany.messageChannel", msgChan);

	pthread_barrier_wait(&barrier); // thread can now hook up to message channel

	msgChan->addEventListener("channelMessage", Function::_new(channelMessageEventListenerProc, NULL));

    AS3_GoAsync();
}
