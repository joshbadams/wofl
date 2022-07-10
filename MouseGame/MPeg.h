//
//  MPeg.h
//  Wofl
//
//  Created by Josh on 6/30/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef __Wofl__MPeg__
#define __Wofl__MPeg__

#include "WoflSprite.h"

class MPeg : public WoflSprite
{
public:
	
	// constructor
	MPeg(float CenterX, float CenterY);

	// get info
	float GetRadius()
	{
		return Radius;
	}
	
	virtual void OnCollision(WoflSprite* Collider) override;

protected:
	// collision size of the peg
	float Radius;
};


#endif /* defined(__Wofl__MPeg__) */
