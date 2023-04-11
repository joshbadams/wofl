//
//  Player.cpp
//  Wofl
//
//  Created by Josh on 2/16/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "MPlayer.h"
#include "WoflWorld.h"


#define GRAVITY 120
#define MAX_VELOCITY 200


MPlayer::MPlayer()
	: WoflSprite(200, 60, 16, 16)
{
	WoflImage* Image = new WoflImage("seal1", 0, 0, 1.0f, 1.0f);
	WoflImage* Image2 = new WoflImage("seal2", 0, 0, 1.0f, 1.0f);
	WoflImage* Image3 = new WoflImage("seal3", 0, 0, 1.0f, 1.0f);
	AddImage(Image);
	AddImage(Image2);
	AddImage(Image3);
	
//	WoflSprite* Child = new WoflSprite(0, 0, 16, 16);
//	Child->AddImage(Image);
//	AddChild(Child);
//
//	Child = new WoflSprite(32, 0, 16, 16);
//	Child->AddImage(Image);
//	AddChild(Child);
	
	Velocity = Vector(20, 30);
	
	// enable collision!
	SetCollisionRadius(8.0f);
}

void MPlayer::Tick(float DeltaTime)
{
	WoflSprite::Tick(DeltaTime);
	
	//DeltaTime *= 0.2;
	// get recent touches
	vector<TouchEvent> Touches = Utils::Input->GetTouches();
	
	// process each one
	for (int Index = 0; Index < Touches.size(); Index++)
	{
		if (Touches[Index].Type != TouchType::End)
		{
			Position = Vector(Touches[Index].X - Size.X / 2.0, Touches[Index].Y - Size.Y / 2.0);
			Velocity = Vector(0.0f, 0.0f);
		}
	}
	
	Position += Velocity * DeltaTime;
		
	// run collisions
	WoflWorld::Get()->Visit(true, true, true,
							[=](WoflSprite* Sprite)
							{
								Vector OutPosition, OutDirection;
								if (Sprite->RunCollision(this, OutPosition, OutDirection))
								{
									// get original velocity magnitude
									float OldVel = Velocity.Length();
									
									// set new velocity
									Velocity = OutDirection * OldVel;
									
									SetCenter(OutPosition);
									
									return false;
								}
								return true;
							});
	
	Velocity.Y += GRAVITY * DeltaTime;
	
	// max out the new velocty
	float VelSquared = Velocity.LengthSquared();
	if (VelSquared > MAX_VELOCITY * MAX_VELOCITY)
	{
		Velocity = Velocity.Normal() * MAX_VELOCITY;
	}
	
	//	printf("CurVel = %f\n", Velocity.Length());
}
