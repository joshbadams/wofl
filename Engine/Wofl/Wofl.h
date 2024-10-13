//
//  Wofl.h
//  Wofl
//
//  Created by Josh Adams on 4/9/23.
//  Copyright © 2023 Josh. All rights reserved.
//

#if __OBJC__
#import <Foundation/Foundation.h>

//! Project version number for Wofl.
FOUNDATION_EXPORT double WoflVersionNumber;

//! Project version std::string for Wofl.
FOUNDATION_EXPORT const unsigned char WoflVersionString[];

#endif

// In this header, you should import all the public headers of your framework using statements like #import <Wofl/PublicHeader.h>

#if WINDOWS
#include "WoflStandardIncludes.h"
#else

// @todo move to WoflFrameworkIncludes.h or something?
#define IOS 1

#include <Wofl/WoflPrefix.h>

#include <Wofl/WoflApp.h>
#include <Wofl/WoflButton.h>
#include <Wofl/WoflGame.h>
#include <Wofl/WoflHud.h>
#include <Wofl/WoflInput.h>
#include <Wofl/WoflWorld.h>


#include <Wofl/WoflUtils.h>
#include <Wofl/WoflFile.h>
#include <Wofl/WoflMath.h>
#include <Wofl/WoflPlatform.h>

#include <Wofl/WoflRenderer.h>
#include <Wofl/WoflLabel.h>
#include <Wofl/WoflImage.h>
#include <Wofl/WoflAtlases.h>

#endif
