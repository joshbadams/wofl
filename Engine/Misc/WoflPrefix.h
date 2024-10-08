//
// Prefix header for all source files of the 'Wofl' target in the 'Wofl' project
//

#define IS_WOFL_LIBRARY 1
#define IS_WOFL_FRAMEWORK IOS

#if IOS

#import <Availability.h>
#import <TargetConditionals.h>

#if __OBJC__
#import <Foundation/Foundation.h>
#if TARGET_OS_MAC
	#import <AppKit/AppKit.h>
#else
	#import <UIKit/UIKit.h>
	#ifndef __IPHONE_5_0
	#warning "This project uses features only available in iOS SDK 5.0 and later."
	#endif
#endif

#define IS_WOFL_LIBRARY 1

#endif

#define WLOG(...) printf(__VA_ARGS__)

#endif

#if ANDROID
#include <android/log.h>
#define LOG_TAG "Wofl"
#define WLOG(...) __android_log_print(ANDROID_LOG_VERBOSE, LOG_TAG, __VA_ARGS__)
#endif

#if WINDOWS
#define WLOG(...) printf(__VA_ARGS__)
#endif

#define PREPROCESSOR_TO_STRING(x) PREPROCESSOR_TO_STRING_INNER(x)
#define PREPROCESSOR_TO_STRING_INNER(x) #x

#define PREPROCESSOR_JOIN(x, y) PREPROCESSOR_JOIN_INNER(x, y)
#define PREPROCESSOR_JOIN_INNER(x, y) x##y

#if IS_WOFL_FRAMEWORK
#define WOFL_INC(Header) <PREPROCESSOR_JOIN(Wofl/Wofl, Header).h>
#define WOFL_JSON <Wofl/json.h>
#else
#define WOFL_INC(Header) PREPROCESSOR_TO_STRING(PREPROCESSOR_JOIN(Wofl, Header).h)
#define WOFL_JSON "json.h"
#endif

#include <vector>
#include <string>
#include <map>
#include <assert.h>
#include <math.h>
#include <functional>


#include WOFL_INC(Utils)
#include WOFL_INC(Math)
#include WOFL_INC(File)
#include WOFL_JSON
