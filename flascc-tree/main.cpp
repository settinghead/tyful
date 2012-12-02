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

#include <pthread.h>
#include <AS3/AS3.h>
#include <AS3/AVM2.h> // low level sync primitives
#include <stdio.h>
#include "../cpp/cpp/model/PolarCanvas.h"

static pthread_barrier_t feed_barrier;
static pthread_barrier_t slap_barrier;
static volatile long feed_tid = 0;
static volatile long slap_tid = 0;

static void *callFeed(void *arg) {
  // inline_as3("if(com.settinghead.tyful.client.model.RenderTuProxy.current) {com.settinghead.tyful.client.model.RenderTuProxy.current.handleFeeds();} else if(com.settinghead.tyful.client.algo.PolarWorker.current) {com.settinghead.tyful.client.algo.PolarWorker.current.handleFeeds();}");
  // inline_as3("if(this[\"feedRequestListener\"]) this[\"slapRequestListener\"].call(null);");
  // inline_as3("trace(com.settinghead.tyful.client.model.RenderProxy.current);");
  // inline_as3("trace(com.settinghead.tyful.client.algo.PolarWorker.current);");
  return 0;
}

static void *callSlap(void *arg) {
  // inline_as3("if(this[\"slapRequestListener\"]) this[\"slapRequestListener\"].call(null);");
  // inline_as3("trace(this[\"slapRequestListener\"]);");

    // inline_as3("if(com.settinghead.tyful.client.model.RenderProxy.current) {com.settinghead.tyful.client.model.RenderTuProxy.current.handleSlaps();} else if(com.settinghead.tyful.client.algo.PolarWorker.current) {com.settinghead.tyful.client.algo.PolarWorker.current.handleSlaps();}");
  // inline_as3("if(this[\"feedRequestListener\"]) this[\"slapRequestListener\"].call(null);");
  // inline_as3("trace(com.settinghead.tyful.client.model.RenderTuProxy.current);");
  // inline_as3("trace(com.settinghead.tyful.client.algo.PolarWorker.current);");
  return 0;
}

static void* monitorFeedThreadProc(void *arg){
  pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_req_mutex);
  printf("feed monitor thread initialized. Canvas addr: %x\n",&PolarCanvas::threadControllers);
    for(;;){
      pthread_cond_wait(&PolarCanvas::threadControllers.next_feed_req_cv, &PolarCanvas::threadControllers.next_feed_req_mutex);
    // inline_as3("this.dispatchEvent(new Event(\"feedRequest\"));");
      avm2_ui_thunk(callFeed, NULL);
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_req_mutex);
}

static void* monitorSlapThreadProc(void *arg){

    pthread_mutex_lock(&PolarCanvas::threadControllers.next_slap_req_mutex);
    printf("slap monitor thread initialized. Canvas addr: %x\n",&PolarCanvas::threadControllers);
    for(;;){
      pthread_cond_wait(&PolarCanvas::threadControllers.next_slap_req_cv, &PolarCanvas::threadControllers.next_slap_req_mutex);
    // inline_as3("this.dispatchEvent(new Event(\"slapRequest\"));");
      avm2_ui_thunk(callSlap, NULL);
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_slap_req_mutex);
}

void addFeedRequestEventListener() __attribute__((used,
	annotate("as3sig:public function addFeedRequestEventListener(listener:Function):void"),
	annotate("as3package:polartree.PolarTree")));
void addFeedRequestEventListener(){
    inline_as3("this[\"feedRequestListener\"]=listener;");
}

void addSlapRequestEventListener() __attribute__((used,
	annotate("as3sig:public function addSlapRequestEventListener(listener:Function):void"),
	annotate("as3package:polartree.PolarTree")));
void addSlapRequestEventListener(){
    inline_as3("this[\"slapRequestListener\"]=listener;");
}

int main()
{
    // pthread_t slapThread;
    // pthread_t feedThread;
  	// pthread_create(&slapThread, NULL, monitorSlapThreadProc, NULL);
  	// pthread_create(&feedThread, NULL, monitorFeedThreadProc, NULL);

    AS3_GoAsync();
}
