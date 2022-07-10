//
//  iOSPlatform.h
//  Wofl
//
//  Created by Josh on 2/23/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_iOSPlatform_h
#define Wofl_iOSPlatform_h

#include "WoflPlatform.h"

class iOSPlatform : public WoflPlatform
{
public:
	
	iOSPlatform()
		: WoflPlatform()
	{
		StartTime = [NSDate timeIntervalSinceReferenceDate];
	}
	
	virtual double GetTime() override
	{
		return [NSDate timeIntervalSinceReferenceDate] - StartTime;
	}
	
protected:
	
	// this is "time 0" for the booted game
	NSTimeInterval StartTime;
};

#endif
