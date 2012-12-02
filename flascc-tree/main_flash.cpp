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
extern "C" {
#include "sys/thr.h"
}
#include <AS3/AS3.h>
#include <Flash++.h>
#include <stdio.h>
#include "../cpp/cpp/model/PolarCanvas.h"
using namespace AS3::ui;

static pthread_barrier_t feed_barrier;
static pthread_barrier_t slap_barrier;
static volatile long feed_tid = 0;
static volatile long slap_tid = 0;

static var feedChannelMessageEventListenerProc(void *arg, var as3Args)
{
  flash::events::Event event = flash::events::Event(as3Args[0]); // event
  flash::system::MessageChannel msgChan = flash::system::MessageChannel(event->target); // event.target
  var msg = msgChan->receive();
  int timestamp = _int(msg)->valueOf();
  inline_as3("if(this[\"feedRequestListener\"]) this[\"feedRequestListener\"].call(null);");
  printf("feed req event dispatched.\n");
  return internal::_undefined;
}

static var slapChannelMessageEventListenerProc(void *arg, var as3Args)
{
  flash::events::Event event = flash::events::Event(as3Args[0]); // event
  flash::system::MessageChannel msgChan = flash::system::MessageChannel(event->target); // event.target
  var msg = msgChan->receive();
  int timestamp = _int(msg)->valueOf();
  inline_as3("if(this[\"slapRequestListener\"]) this[\"slapRequestListener\"].call(null);");
  inline_as3("trace(this[\"slapRequestListener\"]);");
  printf("slap req event dispatched.\n");
  return internal::_undefined;
}

static void* monitorFeedThreadProc(void *arg){
  long id;

  thr_self(&id);
  feed_tid = id;

  pthread_barrier_wait(&feed_barrier); // wait for main to pick up tid
  pthread_barrier_wait(&feed_barrier); // wait for main to create messageChannel

  flash::system::Worker worker = internal::get_Worker();
  flash::system::MessageChannel msgChan = worker->getSharedProperty("com.settinghead.tyful.client.feedMessageChannel");
  msgChan->addEventListener("channelMessage", Function::_new(feedChannelMessageEventListenerProc, NULL));

  pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_req_mutex);
  printf("feed monitor thread initialized. Canvas addr: %x\n",&PolarCanvas::threadControllers);
    for(;;){
      pthread_cond_wait(&PolarCanvas::threadControllers.next_feed_req_cv, &PolarCanvas::threadControllers.next_feed_req_mutex);
    // inline_as3("this.dispatchEvent(new Event(\"feedRequest\"));");
      msgChan->send(_int::_new(1)); // send slap signal

    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_req_mutex);
}

static void* monitorSlapThreadProc(void *arg){
  long id;

  thr_self(&id);
  slap_tid = id;

  pthread_barrier_wait(&slap_barrier); // wait for main to pick up tid
  pthread_barrier_wait(&slap_barrier); // wait for main to create messageChannel

  flash::system::Worker worker = internal::get_Worker();
  flash::system::MessageChannel msgChan = worker->getSharedProperty("com.settinghead.tyful.client.slapMessageChannel");

  msgChan->addEventListener("channelMessage", Function::_new(slapChannelMessageEventListenerProc, NULL));
    pthread_mutex_lock(&PolarCanvas::threadControllers.next_slap_req_mutex);
    printf("slap monitor thread initialized. Canvas addr: %x\n",&PolarCanvas::threadControllers);
    for(;;){
      pthread_cond_wait(&PolarCanvas::threadControllers.next_slap_req_cv, &PolarCanvas::threadControllers.next_slap_req_mutex);
    // inline_as3("this.dispatchEvent(new Event(\"slapRequest\"));");
      msgChan->send(_int::_new(1)); // send slap signal
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
    // We still need a main function for the SWC. this function must be called
    // so that all the static init code is executed before any library functions
    // are used.
    //
    // The main function for a library must throw an exception so that it does
    // not return normally. Returning normally would cause the static
    // destructors to be executed leaving the library in an unuseable state.
	// srand ( time(NULL) );

  pthread_barrier_init(&feed_barrier, NULL, 2);
  pthread_barrier_init(&slap_barrier, NULL, 2);

  	pthread_t thread;
  	pthread_create(&thread, NULL, monitorSlapThreadProc, NULL);
  	pthread_create(&thread, NULL, monitorFeedThreadProc, NULL);

    pthread_barrier_wait(&feed_barrier); // wait for tid to get initialized
    pthread_barrier_wait(&slap_barrier); // wait for tid to get initialized

  flash::system::Worker selfWorker = internal::get_Worker();
  flash::system::Worker feedWorker = internal::get_Worker(feed_tid);
  flash::system::Worker slapWorker = internal::get_Worker(slap_tid);
  flash::system::MessageChannel feedMsgChan = feedWorker->createMessageChannel(selfWorker);
  flash::system::MessageChannel slapMsgChan = slapWorker->createMessageChannel(selfWorker);
  feedMsgChan->addEventListener("channelMessage", Function::_new(feedChannelMessageEventListenerProc, NULL));
  slapMsgChan->addEventListener("channelMessage", Function::_new(slapChannelMessageEventListenerProc, NULL));

  feedWorker->setSharedProperty("com.settinghead.tyful.client.feedMessageChannel", feedMsgChan);
  slapWorker->setSharedProperty("com.settinghead.tyful.client.slapMessageChannel", slapMsgChan);

  pthread_barrier_wait(&feed_barrier); // thread can now hook up to message channel
  pthread_barrier_wait(&slap_barrier); // thread can now hook up to message channel


    AS3_GoAsync();
}
