/// Copyright (c) 2012 The Native Client Authors. All rights reserved.
/// Use of this source code is governed by a BSD-style license that can be
/// found in the LICENSE file.
///
/// @file tyful_nacl_client.cc
/// This example demonstrates loading, running and scripting a very simple NaCl
/// module.  To load the NaCl module, the browser first looks for the
/// CreateModule() factory method (at the end of this file).  It calls
/// CreateModule() once to load the module code from your .nexe.  After the
/// .nexe code is loaded, CreateModule() is not called again.
///
/// Once the .nexe code is loaded, the browser than calls the CreateInstance()
/// method on the object returned by CreateModule().  It calls CreateInstance()
/// each time it encounters an <embed> tag that references your NaCl module.
///
/// The browser can talk to your NaCl module via the postMessage() Javascript
/// function.  When you call postMessage() on your NaCl module from the browser,
/// this becomes a call to the HandleMessage() method of your pp::Instance
/// subclass.  You can send messages back to the browser by calling the
/// PostMessage() method on your pp::Instance.  Note that these two methods
/// (postMessage() in Javascript and PostMessage() in C++) are asynchronous.
/// This means they return immediately - there is no waiting for the message
/// to be handled.  This has implications in your program design, particularly
/// when mutating property values that are exposed to both the browser and the
/// NaCl module.

#include <cstdio>
#include <string>
#include <sstream>
#include "ppapi/cpp/instance.h"
#include "ppapi/cpp/module.h"
#include "ppapi/cpp/graphics_2d.h"
#include "ppapi/cpp/image_data.h"
#include "ppapi/cpp/var.h"
#include "ppapi/cpp/var_array_buffer.h"
#include "../cpp/cpp/polartreeapi.h"
#include "../cpp/cpp/model/PolarCanvas.h"
#include "../cpp/cpp/model/structs.h"
#include <ppapi/cpp/completion_callback.h>
#include "ppapi/utility/completion_callback_factory.h"
#include <iostream>
#include <pthread.h>
#include <cstring>


namespace {
// The expected string sent by the browser.
// const char* const kUpdateTemplateMethodId = "updateTemplate";
// const char* const kStartRenderMethodId = "startRender";
// const char* const kPauseRenderMethodId = "pauseRender";
// const char* const kFeedShapeMethodId = "feedShape";
// const char* const kUpdatePerseveranceMethodId = "updatePerseverance";
// static const char kMessageArgumentSeparator = ':';

  const int kUpdateTemplateMethodId = 0;
  const int kStartRenderMethodId = 1;
  // const int kPauseRenderMethodId = 2;
  const int kFeedShapeMethodId = 3;
  const int kUpdatePerseveranceMethodId = 4;

  const char* kUpdateTemplateMethodPrefix = "updateTemplate:";
  const char* kStartRenderMethodPrefix = "startRender:";
  // const char* kPauseRenderMethodPrefix = "pauseRender:";
  const char* kFeedShapeMethodPrefix = "feedShape:";
  const char* kUpdatePerseveranceMethodPrefix = "updatePerseverance:";
  const char* kFixShapeMethodPrefix = "fixShape:";

  const char* kSlapMethodPrefix = "slapShape";
  const char* kinitCompletePrefix = "initComplete";
  const char* kTemplateDataReceivedPrefix = "templateDataReceived";
  const char* kFeedMeMethodPrefix = "feedMe";

// The string sent back to the browser upon receipt of a message
// containing "hello".
} // namespace

/// The Instance class.  One of these exists for each instance of your NaCl
/// module on the web page.  The browser will ask the Module object to create
/// a new Instance for each occurence of the <embed> tag that has these
/// attributes:
///     type="application/x-nacl"
///     src="tyful_nacl_client.nmf"
/// To communicate with the browser, you must override HandleMessage() for
/// receiving messages from the browser, and use PostMessage() to send messages
/// back to the browser.  Note that this interface is asynchronous.

class TyfulNaclCoreInstance : public pp::Instance {

private:
  int status;
  int width, height, sid;
  double shrinkage;
  pthread_t       checkRenderRoutineThread;
  pthread_t       feedRoutineThread;
  // bool check_threads_running;

public:
  /// The constructor creates the plugin-side instance.
  /// @param[in] instance the handle to the browser-side plugin instance.
  explicit TyfulNaclCoreInstance(PP_Instance instance) : pp::Instance(instance)
  ,factory_(this)
  // ,check_threads_running(false)
  {
  }
  virtual ~TyfulNaclCoreInstance() {
  }

  // Create the 'worker thread'.
  bool Init(uint32_t argc, const char* argn[], const char* argv[]) {
    pthread_create(&feedRoutineThread, NULL, &feedShapes, this);
    pthread_create(&checkRenderRoutineThread, NULL, &checkAndRenderSlaps, this);
    return true;
  }
  string* messageToPost;
  pp::CompletionCallbackFactory<TyfulNaclCoreInstance> factory_;

  static void *checkAndRenderSlaps(void* core){
    printf("Slap checker thread started\n.");
    pthread_mutex_lock(&PolarCanvas::threadControllers.next_slap_req_mutex);
    while(true){
      // try{
        pthread_cond_wait(&PolarCanvas::threadControllers.next_slap_req_cv, &PolarCanvas::threadControllers.next_slap_req_mutex);
        SlapInfo* placement;
        while((placement=getNextSlap())!=NULL){
          // std::stringstream ss(std::stringstream::in | std::stringstream::out);
          // ss << kSlapMethodPrefix << ":" << placement->sid << "," << placement->location.x << "," << placement->location.y << "," 
            // << placement->rotation << "," << placement->layer << ","
            // << placement->color << placement->failureCount << endl;
          char msg[1024];
          snprintf( msg, sizeof(msg), "%s:%d,%d,%d,%f,%d,%u,%d", 
            kSlapMethodPrefix, placement->sid,(int)placement->location.x, (int)placement->location.y,
            placement->rotation,placement->layer,placement->color,placement->failureCount);

          // ((TyfulNaclCoreInstance*)core)->PostMessage(pp::Var(ss.str()));
          // ((TyfulNaclCoreInstance*)core)->messageToPost = &ss.str();
          printf("Slap: %s\n",(char *)msg);
          pp::CompletionCallback cc = ((TyfulNaclCoreInstance*)core)->factory_.NewCallback(&TyfulNaclCoreInstance::PostStringToBrowser,(char *)msg);
          // pp::CompletionCallback cc(((TyfulNaclCoreInstance*)core)->PostStringToBrowser, ss.str().c_str());
          pp::Module::Get()->core()->CallOnMainThread(0, cc, 0);
        }
      // }catch(int e){
        // cout << "An exception occurred. Exception Nr. " << e << endl;
      // }
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_slap_req_mutex);
    return NULL;
  }

  void* PostStringToBrowser(
    int32_t result, 
    std::string data_to_send) {
    PostMessage(pp::Var(data_to_send));
    return 0;
  }

  static void *feedShapes(void* core){
    printf("FeedShape checker thread started\n.");
    TyfulNaclCoreInstance* event_instance = static_cast<TyfulNaclCoreInstance*>(core);

    pthread_mutex_lock(&PolarCanvas::threadControllers.next_feed_req_mutex);
    while(true){
      pthread_cond_wait(&PolarCanvas::threadControllers.next_feed_req_cv, &PolarCanvas::threadControllers.next_feed_req_mutex);
      // try{
      // for(int i=PolarCanvas::current->pendingShapes->size()&&getStatus()>0;i<10;i++){
        // std::stringstream ss(std::stringstream::in | std::stringstream::out);
        // ss << kFeedMeMethodPrefix << ":" << 1 << "," << getShrinkage() <<","<< endl;
        char msg[1024];
        snprintf( msg, sizeof(msg), "%s:%d,%f\0", kFeedMeMethodPrefix, 1, getShrinkage());

        // printf("server: %s\n",ss.str().c_str());
        // ((TyfulNaclCoreInstance*)core)->PostMessage(pp::Var(ss.str()));
        // struct PP_CompletionCallback cb;
        // cb = PP_MakeCompletionCallback(PostCompletionCallback, strdup(ss.str().c_str()));
        pp::CompletionCallback cc = ((TyfulNaclCoreInstance*)core)->factory_.NewCallback(&TyfulNaclCoreInstance::PostStringToBrowser,(char *)msg);
        // pp::CompletionCallback cc(((TyfulNaclCoreInstance*)core)->PostStringToBrowser, ss.str().c_str());
        pp::Module::Get()->core()->CallOnMainThread(0, cc, 0);
        
      // }
      // }
      // catch(int e){
        // cout << "An exception occurred. Exception Nr. " << e << endl;
      // }
    }
    pthread_mutex_unlock(&PolarCanvas::threadControllers.next_feed_req_mutex);
    return NULL;
  }
  
  /// Handler for messages coming in from the browser via postMessage().  The
  /// @a var_message can contain anything: a JSON string; a string that encodes
  /// method names and arguments; etc.  For example, you could use
  /// JSON.stringify in the browser to create a message that contains a method
  /// name and some parameters, something like this:
  ///   var json_message = JSON.stringify({ "myMethod" : "3.14159" });
  ///   nacl_module.postMessage(json_message);
  /// On receipt of this message in @a var_message, you could parse the JSON to
  /// retrieve the method name, match it to a function call, and then call it
  /// with the parameter.
  /// @param[in] var_message The message posted by the browser.
  virtual void HandleMessage(const pp::Var& var_message) {
    if(var_message.is_string()){
      std::string message = var_message.AsString();
      printf("String command received: %s\n",message.c_str());
      if(message.find(kUpdateTemplateMethodPrefix) == 0){
        status = kUpdateTemplateMethodId;
        char * pch;
        size_t pos = message.find_first_of(':')+1;
        pch = strtok ((char*)message.substr(pos).c_str(),",");
        width = ::atoi(pch);
        pch = strtok (NULL, ",");
        height = ::atoi(pch);
        initCanvas();
        char msg[1024];
          snprintf( msg, sizeof(msg), "%s:",kinitCompletePrefix);
        PostMessage(pp::Var(msg));

      }
      else if(message.find(kStartRenderMethodPrefix) == 0){
        status = kStartRenderMethodId;
        // if(!check_threads_running){
        //   check_threads_running = true;
        // }
        startRendering();
        printf("startrendering command complete.\n");
      }
      else if(message.find(kFeedShapeMethodPrefix) == 0){
        try{
        status = kFeedShapeMethodId;
          char * pch;
        size_t pos = message.find_first_of(':')+1;
          pch = strtok ((char*)message.substr(pos).c_str(),",");
          sid = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          width = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          height = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          shrinkage = ::atof(pch);
        }
        catch(int e){
          printf("Exception!!! No. $d", e);
        }
          // printf("Ready to receive shape bytes. Width: %d, height: %d\n",width,height);
      }
      else if(message.find(kFixShapeMethodPrefix) == 0){
        char * pch;
        size_t pos = message.find_first_of(':')+1;
          pch = strtok ((char*)message.substr(pos).c_str(),",");
          int sid = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          int x = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          int y = ::atoi(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          double rotation = ::atof(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          double scaleX = ::atof(pch);
          pch = strtok (NULL, ",");
          if(pch==NULL) return;
          double scaleY = ::atof(pch);
          setFixedShape(sid,x,y,rotation,scaleX,scaleY);
      }
    }
    else if (var_message.is_array_buffer()){
      pp::VarArrayBuffer buffer_data(var_message);
      uint32_t* buffer = static_cast<uint32_t*>(buffer_data.Map());
      if (status==kUpdateTemplateMethodId) {
      // The argument to getUrl is everything after the first ':'.
          // std::string templateData_str = message.substr(sep_pos + 1);
          // std::string data_str = base64_decode(templateData_str);
          // PostMessage(buffer_data);
          //         printf("%u,%u,%u,%u, len: %d",
          //   buffer[0],
          //   buffer[1],
          //   buffer[2],
          //   buffer[3],
          //   buffer_data.ByteLength());
        if(width>0 && height>0)
          appendLayer(buffer,NULL,width,height,true,true);
        buffer_data.Unmap();
        char msg[1024];
        snprintf( msg, sizeof(msg), "%s:",kTemplateDataReceivedPrefix);
        PostMessage(pp::Var(msg));
      }
      else if (status==kFeedShapeMethodId){
        feedShape(buffer,width,height,sid,true,true,shrinkage);
      }
    }
    else return;
  }
};


/// The Module class.  The browser calls the CreateInstance() method to create
/// an instance of your NaCl module on the web page.  The browser creates a new
/// instance for each <embed> tag with type="application/x-nacl".
class TyfulNaclCoreModule : public pp::Module {
public:
  TyfulNaclCoreModule() : pp::Module() {}
  virtual ~TyfulNaclCoreModule() {}

  /// Create and return a TyfulNaclCoreInstance object.
  /// @param[in] instance The browser-side instance.
  /// @return the plugin-side instance.
  virtual pp::Instance* CreateInstance(PP_Instance instance) {
    return new TyfulNaclCoreInstance(instance);
  }
};

namespace pp {
/// Factory function called by the browser when the module is first loaded.
/// The browser keeps a singleton of this module.  It calls the
/// CreateInstance() method on the object you return to make instances.  There
/// is one instance per <embed> tag on the page.  This is the main binding
/// point for your NaCl module with the browser.
  Module* CreateModule() {
    return new TyfulNaclCoreModule();
  }
}  // namespace pp


