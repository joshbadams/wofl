//
//  iOSPlatform.h
//  Wofl
//
//  Created by Josh on 2/23/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include "WoflPlatform.h"

class AndroidPlatform : public WoflPlatform
{
public:
	
	AndroidPlatform()
		: WoflPlatform()
	{
//		StartTime = [NSDate timeIntervalSinceReferenceDate];
	}
	
	virtual double GetTime() override
	{
		return 0;
//		return [NSDate timeIntervalSinceReferenceDate] - StartTime;
	}
	
protected:
	
	// this is "time 0" for the booted game
//	NSTimeInterval StartTime;
};
