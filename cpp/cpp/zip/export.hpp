#ifndef _MICROZIP_EXPORT_HPP_
#define _MICROZIP_EXPORT_HPP_

#ifdef _WIN32

    #ifdef MICROZIP_EXPORTS
    #define MICROZIP_API __declspec(dllexport)
    #else
    #define MICROZIP_API __declspec(dllimport)
    #endif

    #define MICROZIP_CLASS_API

    #pragma warning(disable: 4290)

#elif defined(__GNUC__) && (__GNUC__>=4) && defined(__USE_DYLIB_VISIBILITY__)

    #ifdef MICROZIP_EXPORTS
    #define MICROZIP_API __attribute__ ((visibility("default")))
    #define MICROZIP_CLASS_API __attribute__ ((visibility("default")))
    #else
    #define MICROZIP_API
    #define MICROZIP_CLASS_API
    #endif

#else

    #define MICROZIP_API
    #define MICROZIP_CLASS_API

#endif

#endif //_MICROZIP_EXPORT_HPP_
