//
//  FHFish.hpp
//  Wofl
//
//  Created by Josh on 6/19/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflSprite.h"


enum class EFishType : int
{
	OrangeRoughy,
	FangTooth,
	
	
	Max
};



class FHFish : public WoflSprite
{
public:

	struct FHFishInfo
	{
		// the name of the graphic
		const char* ImageName;
		// how much does it cost to buy
		int Cost;
		// size on screen
		int Width;
		int Height;
	};
	static FHFishInfo FishInfos[];
	
	
	FHFish(EFishType Type, const Vector& InRoomSize);

protected:
	
	void NewVelocity();
	
	// currently moving speed
	Vector Vel;
	Vector RoomSize;
};
