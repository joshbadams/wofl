//
// Prefix header for all source files of the 'Wofl' target in the 'Wofl' project
//


#if IOS
#import <Availability.h>

#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#ifdef __OBJC__
	#import <UIKit/UIKit.h>
	#import <Foundation/Foundation.h>
#endif

#define WLOG(...) printf(__VA_ARGS__)

#endif

#if ANDROID
#include <android/log.h>
#define LOG_TAG "Wofl"
#define WLOG(...) __android_log_print(ANDROID_LOG_VERBOSE, LOG_TAG, __VA_ARGS__)
#endif

#include <string>
#include <vector>
#include <map>
#include <assert.h>
#include <math.h>

using namespace std;


#include "Utils.h"
#include "WoflMath.h"
#include "WoflFile.h"
#include "json.h"

