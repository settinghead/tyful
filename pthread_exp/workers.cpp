// Illustration of worker to thread relationship

#include <pthread.h>
#include <string.h>
extern "C" {
#include <sys/thr.h> // BSD-like thread calls
}

#include <AS3/AS3.h>
#include <AS3/AVM2.h> // low level sync primitives

#include <sstream>

// declare an AS3 var -- will be worker-local (not thread-local!)
package_as3(
"public var fun:Function;"
);

const int sNumThreads = 10;
pthread_t sThreads[sNumThreads];
volatile long sThreadIds[sNumThreads];
volatile long main_tid;

// this function returns a strdup-ed string instead of printing directly
// because it will be called by avm2_ui_thunk where C I/O is unsafe
static void *assign(void *arg) {
  inline_as3("this[\"abc\"]=2222;");
  return 0;
}

static void *print(void *arg) {
  int val;
  inline_as3("var abc:int = this[\"abc\"];");
  AS3_GetScalarFromVar(val, abc); 
  printf("Val: %d\n",val);
  return 0;
}


static void *threadProc(void *arg) {
  inline_as3("this[\"abc\"]=3333;");
  avm2_self_msleep((void*)&main_tid, 10);
  avm2_thr_impersonate(main_tid,print,NULL);
  avm2_wake((void*)&main_tid);
  // printf("thread. main id is %d\n",main_tid);
  // avm2_ui_thunk(print, NULL);
  return NULL;
}


int main() {
  long mid;
  thr_self(&mid);
  printf("main_tid: %d\n",mid);
  main_tid = mid;

  inline_as3("this[\"abc\"]=8888;");
  inline_as3("var af:Function = function(){};");

  avm2_ui_thunk(assign, NULL);
  avm2_ui_thunk(print, NULL);

  for(int i = 0; i < sNumThreads; i++)
    pthread_create(sThreads + i, NULL, threadProc, (void *)i);
  for(int i = 0; i < sNumThreads; i++)
    pthread_join(sThreads[i], NULL);

  AS3_GoAsync();

  return 0;
}
