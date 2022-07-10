//
//  WoflPlatform.h
//  Wofl
//
//  Created by Josh on 2/23/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_WoflPlatform_h
#define Wofl_WoflPlatform_h

class WoflPlatform
{
public:
	WoflPlatform()
	{
		Utils::Platform = this;
	}

	// get game time in seconds
	virtual double GetTime() = 0;
};

#endif

