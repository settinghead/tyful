/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 * 
 * This file is not intended to be easily readable and contains a number of 
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG 
 * interface file instead. 
 * ----------------------------------------------------------------------------- */
/* -----------------------------------------------------------------------------
 *  This section contains generic SWIG labels for method/variable
 *  declarations/attributes, and other compiler dependent labels.
 * ----------------------------------------------------------------------------- */

/* template workaround for compilers that cannot correctly implement the C++ standard */
#ifndef SWIGTEMPLATEDISAMBIGUATOR
# if defined(__SUNPRO_CC) && (__SUNPRO_CC <= 0x560)
#  define SWIGTEMPLATEDISAMBIGUATOR template
# elif defined(__HP_aCC)
/* Needed even with `aCC -AA' when `aCC -V' reports HP ANSI C++ B3910B A.03.55 */
/* If we find a maximum version that requires this, the test would be __HP_aCC <= 35500 for A.03.55 */
#  define SWIGTEMPLATEDISAMBIGUATOR template
# else
#  define SWIGTEMPLATEDISAMBIGUATOR
# endif
#endif

/* inline attribute */
#ifndef SWIGINLINE
# if defined(__cplusplus) || (defined(__GNUC__) && !defined(__STRICT_ANSI__))
#   define SWIGINLINE inline
# else
#   define SWIGINLINE
# endif
#endif

/* attribute recognised by some compilers to avoid 'unused' warnings */
#ifndef SWIGUNUSED
# if defined(__GNUC__)
#   if !(defined(__cplusplus)) || (__GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4))
#     define SWIGUNUSED __attribute__ ((__unused__)) 
#   else
#     define SWIGUNUSED
#   endif
# elif defined(__ICC)
#   define SWIGUNUSED __attribute__ ((__unused__)) 
# else
#   define SWIGUNUSED 
# endif
#endif

#ifndef SWIG_MSC_UNSUPPRESS_4505
# if defined(_MSC_VER)
#   pragma warning(disable : 4505) /* unreferenced local function has been removed */
# endif 
#endif

#ifndef SWIGUNUSEDPARM
# ifdef __cplusplus
#   define SWIGUNUSEDPARM(p)
# else
#   define SWIGUNUSEDPARM(p) p SWIGUNUSED 
# endif
#endif

/* internal SWIG method */
#ifndef SWIGINTERN
# define SWIGINTERN static SWIGUNUSED
#endif

/* internal inline SWIG method */
#ifndef SWIGINTERNINLINE
# define SWIGINTERNINLINE SWIGINTERN SWIGINLINE
#endif

/* exporting methods */
#if (__GNUC__ >= 4) || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4)
#  ifndef GCC_HASCLASSVISIBILITY
#    define GCC_HASCLASSVISIBILITY
#  endif
#endif

#ifndef SWIGEXPORT
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   if defined(STATIC_LINKED)
#     define SWIGEXPORT
#   else
#     define SWIGEXPORT __declspec(dllexport)
#   endif
# else
#   if defined(__GNUC__) && defined(GCC_HASCLASSVISIBILITY)
#     define SWIGEXPORT __attribute__ ((visibility("default")))
#   else
#     define SWIGEXPORT
#   endif
# endif
#endif

/* calling conventions for Windows */
#ifndef SWIGSTDCALL
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   define SWIGSTDCALL __stdcall
# else
#   define SWIGSTDCALL
# endif 
#endif

/* Deal with Microsoft's attempt at deprecating C standard runtime functions */
#if !defined(SWIG_NO_CRT_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_CRT_SECURE_NO_DEPRECATE)
# define _CRT_SECURE_NO_DEPRECATE
#endif

/* Deal with Microsoft's attempt at deprecating methods in the standard C++ library */
#if !defined(SWIG_NO_SCL_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_SCL_SECURE_NO_DEPRECATE)
# define _SCL_SECURE_NO_DEPRECATE
#endif



#include <stdlib.h>
#include <string.h>
#include "AS3/AS3.h"
#define swig_as3(X) inline_as3("import com.adobe.flascc.swig.*; " X)


/* Contract support */

#define SWIG_contract_assert(expr, msg) if (!(expr)) {int msglen = strlen(msg);__asm__ volatile ("throw new Exception(CModule.readString(%0, %1))": : "r"(msg), "r"(msglen));}



#include <stdint.h>   
#include "../cpp/cpp/polartreeapi.h"


#include <stdint.h>		// Use the C99 official header

__attribute__((annotate("as3sig:public function _wrap_initCanvas():int")))
void _wrap_initCanvas() {
  void *result ;
  
  result = (void *)initCanvas();
  {
    AS3_DeclareVar(asresult, int);
    AS3_CopyScalarToVar(asresult, result);
  }
  {
    AS3_ReturnAS3Var(asresult);
  }
}


__attribute__((annotate("as3sig:public function _wrap_setPerseverance(canvas:int, perseverance:int):void")))
void _wrap_setPerseverance() {
  void *arg1 = (void *) 0 ;
  int arg2 ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  {
    AS3_GetScalarFromVar(arg2, perseverance);
  }
  setPerseverance(arg1,arg2);
  {
    
  }
  {
    AS3_ReturnAS3Var(undefined);
  }
}


__attribute__((annotate("as3sig:public function _wrap_slapShape(canvas:int, pixels:int, width:int, height:int):int")))
void _wrap_slapShape() {
  void *arg1 = (void *) 0 ;
  unsigned int *arg2 = (unsigned int *) 0 ;
  int arg3 ;
  int arg4 ;
  SlapInfo *result ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  {
    AS3_GetScalarFromVar(arg2, pixels);
  }
  {
    AS3_GetScalarFromVar(arg3, width);
  }
  {
    AS3_GetScalarFromVar(arg4, height);
  }
  result = (SlapInfo *)slapShape(arg1,arg2,arg3,arg4);
  {
    AS3_DeclareVar(asresult, int);
    AS3_CopyScalarToVar(asresult, result);
  }
  {
    AS3_ReturnAS3Var(asresult);
  }
}


__attribute__((annotate("as3sig:public function _wrap_getStatus(canvas:int):int")))
void _wrap_getStatus() {
  void *arg1 = (void *) 0 ;
  int result ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  result = (int)getStatus(arg1);
  {
    AS3_DeclareVar(asresult, int);
    AS3_CopyScalarToVar(asresult, result);
  }
  {
    AS3_ReturnAS3Var(asresult);
  }
}


__attribute__((annotate("as3sig:public function _wrap_setStatus(canvas:int, status:int):void")))
void _wrap_setStatus() {
  void *arg1 = (void *) 0 ;
  int arg2 ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  {
    AS3_GetScalarFromVar(arg2, status);
  }
  setStatus(arg1,arg2);
  {
    
  }
  {
    AS3_ReturnAS3Var(undefined);
  }
}


__attribute__((annotate("as3sig:public function _wrap_getShrinkage(canvas:int):Number")))
void _wrap_getShrinkage() {
  void *arg1 = (void *) 0 ;
  double result ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  result = (double)getShrinkage(arg1);
  {
    AS3_DeclareVar(asresult, Number);
    AS3_CopyScalarToVar(asresult, result);
  }
  {
    AS3_ReturnAS3Var(asresult);
  }
}


__attribute__((annotate("as3sig:public function _wrap_appendLayer(canvas:int, pixels:int, colorPixels:int, width:int, height:int):void")))
void _wrap_appendLayer() {
  void *arg1 = (void *) 0 ;
  unsigned int *arg2 = (unsigned int *) 0 ;
  unsigned int *arg3 = (unsigned int *) 0 ;
  int arg4 ;
  int arg5 ;
  
  {
    AS3_GetScalarFromVar(arg1, canvas);
  }
  {
    AS3_GetScalarFromVar(arg2, pixels);
  }
  {
    AS3_GetScalarFromVar(arg3, colorPixels);
  }
  {
    AS3_GetScalarFromVar(arg4, width);
  }
  {
    AS3_GetScalarFromVar(arg5, height);
  }
  appendLayer(arg1,arg2,arg3,arg4,arg5);
  {
    
  }
  {
    AS3_ReturnAS3Var(undefined);
  }
}


