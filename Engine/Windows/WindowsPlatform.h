//
//  iOSPlatform.h
//  Wofl
//
//  Created by Josh on 2/23/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include <windows.h>
#include "WoflPlatform.h"

class WindowsPlatform : public WoflPlatform
{
public:
	
	WindowsPlatform()
		: WoflPlatform()
	{
		QueryPerformanceCounter(&StartTime);
		QueryPerformanceFrequency(&Frequency);
	}
	
	virtual double GetTime() override
	{
		LARGE_INTEGER Now;
		QueryPerformanceCounter(&Now);
		return (Now.QuadPart - StartTime.QuadPart) / (double)Frequency.QuadPart;
	}
	
protected:
	LARGE_INTEGER StartTime, Frequency;
};
