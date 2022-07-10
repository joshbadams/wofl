//
//  SPlayer.cpp
//  Wofl
//
//  Created by Josh on 2/9/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#include "SPlayer.h"
#include "ScrollyGame.h"

#define JUMP_VELOCITY 400
#define ACCELERATION  600

SPlayer::SPlayer(float X, float Y)
	: WoflSprite(X, Y, 128, 64, Tag_Player)
	, Velocity(0)
	, Acceleration(ACCELERATION)
	, GroundLevel(Y)

{
	WoflImage* Image1 = new WoflImage("Player1", 1.0, 0, -1.0f, 1.0f);
	WoflImage* Image2 = new WoflImage("Player2", 1.0, 0, -1.0f, 1.0f);
	WoflImage* Image3 = new WoflImage("Player3", 1.0, 0, -1.0f, 1.0f);
	AddImage(Image1);
	AddImage(Image2);
	AddImage(Image3);
}

void SPlayer::Tick(float DeltaTime)
{
	Vector Pos = GetPosition();

//	if (Velocity != 0)
	{
		Pos.Y += Velocity * DeltaTime;
		if (Pos.Y < GroundLevel)
		{
			Pos.Y = GroundLevel;
			Velocity = 0;
		}
		else
		{
			Velocity -= Acceleration * DeltaTime;
		}
		
		// move to final spot
		SetPosition(Pos);
	}
	
	// get recent touches
	vector<TouchEvent> Touches = Utils::Input->GetTouches();
	
	// process each one
	for (int Index = 0; Index < Touches.size(); Index++)
	{
		if (Touches[Index].Type != TouchType::End && Pos.Y == GroundLevel)
		{
			Velocity = JUMP_VELOCITY;
		}
	}
	
	Utils::Input->Flush();
}
