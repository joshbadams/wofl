//
//  iOSSupport.cpp
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflUtils.h"
#include "WoflApp.h"
#include "WindowsFile.h"
#include "WindowsInput.h"
#include "WindowsPlatform.h"
#include "WindowsRenderer.h"

void WoflApplication::InitializePlatform()
{
	static WindowsFile Singleton_WindowsFile;
	static WindowsInput Singleton_WindowsInput;
	static WindowsPlatform Singleton_WindowsPlatform;
	static WindowsRenderer Singleton_WindowsRenderer;
}
