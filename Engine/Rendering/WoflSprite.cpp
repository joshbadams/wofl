//
//  WoflSprite.cpp
//  Wofl
//
//  Created by Josh on 2/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflSprite.h"
#include "WoflUtils.h"
#include "WoflWorld.h"
#include "WoflRenderer.h"
#include "WoflImage.h"



WoflSprite::WoflSprite(float X, float Y, float SizeX, float SizeY, int InTag)
	: FramesPerSecond(10.0f)
	, Frame(0)
	, AnimTime(0)
	, Tag(InTag)
	, bIsClickEnabled(false)
	, bIsFullScreenInput(false)
	, Next(NULL)
	, Child(NULL)
	, Parent(NULL)
	, CollisionRadius(0.0f)
	, CollisionLineLength(0.0f)
	, bIsAddedToWorld(false)
{
	Position.X = X;
	Position.Y = Y;

	Vector ViewSize = WoflRenderer::Renderer->GetViewSize();
	Size.X = SizeX == -1.0 ? ViewSize.X : SizeX;
	Size.Y = SizeY == -1.0 ? ViewSize.Y : SizeY;
	SetColor(WColor(1.0f, 1.0f, 1.0f, 1.0f));
}

WoflSprite::~WoflSprite()
{
	RemoveFromWorld();
}

Vector WoflSprite::GetPosition() const
{
	Vector Pos = Position;
	if (Parent)
	{
		Pos += Parent->GetPosition();
	}
	return Pos;
}

void WoflSprite::SetPosition(const Vector& NewPosition)
{
	Position = NewPosition;
	if (Parent)
	{
		Position -= Parent->GetPosition();
	}
}

void WoflSprite::SetSize(const Vector& NewSize)
{
	Size = NewSize;
}

// gets the current image to render
WoflImage* WoflSprite::GetImage() const
{
	// make sure we have somethin to return
	if (Images.size() == 0)
	{
		return NULL;
	}
	
	// return current frame of animation
	return Images[Frame];
}


void WoflSprite::AddSibling(WoflSprite* NewSprite)
{
	WoflSprite* OldNext = Next;
	Next = NewSprite;
	NewSprite->Next = OldNext;
	
	// my parent is the new guy's parent
	NewSprite->Parent = Parent;
	
	NewSprite->bIsAddedToWorld = true;
}

void WoflSprite::AddChild(WoflSprite* NewSprite, bool bAddAsFirstChild)
{
	NewSprite->Parent = this;
	
	if (Child == NULL)
	{
		Child = NewSprite;
	}
	else if (bAddAsFirstChild)
	{
		// insert as the first child
		WoflSprite* OldFirstChild = Child;
		Child = NewSprite;
		Child->AddSibling(OldFirstChild);
	}
	else
	{
		// add at the end the child's siblings
		WoflSprite* Travel = Child;
		while (Travel->Next)
		{
			Travel = Travel->Next;
		}
		Travel->Next = NewSprite;
	}

	NewSprite->bIsAddedToWorld = true;
}

void WoflSprite::RemoveFromParent()
{
	// if we are first in the child list, then just make next the child
	if (Parent && Parent->Child == this)
	{
		Parent->Child = Next;
	}
	else if (WoflWorld::Get()->GetRootSprite() == this)
	{
		// @todo, Set Next to be the Root sprite
		printf("Deleting the root sprite, but this isn't supported yet!");
	}
	// otherwise, look for our previous (simple if doubly-linked!)
	else
	{
		WoflSprite* Travel = Parent ? Parent->Child : WoflWorld::Get()->GetRootSprite();
		while (Travel && Travel->Next)
		{
			if (Travel->Next == this)
			{
				Travel->Next = Next;
				break;
			}
			Travel = Travel->Next;
		}
	}
	Next = nullptr;
	Parent = nullptr;
	bIsAddedToWorld = false;
}

void WoflSprite::SafeDelete()
{
	WoflWorld::Get()->DeleteSprite(this);
}

void WoflSprite::RemoveFromWorld()
{
	if (!bIsAddedToWorld)
	{
		return;
	}
		
	// remove it!
	
	// make sure all children are tossed
	while (Child)
	{
		Child->RemoveFromWorld();
	}

	RemoveFromParent();
}

bool WoflSprite::IsRooted()
{
	WoflSprite* Travel = this;
	while (Travel->GetParent())
	{
		Travel = Travel->GetParent();
	}
	
	return Travel == WoflWorld::Get()->GetRootSprite();
}


// allow the sprite to do per-frame processing
void WoflSprite::Tick(float DeltaTime)
{
	// with only one frame of "animation", nothing to do
	if (Images.size() == 1)
	{
		return;
	}
	
	// determine length of the animation in time
	float AnimLength = (Images.size() + 1) / FramesPerSecond;
		
	// update current time, and loop
	AnimTime += DeltaTime;
	if (AnimTime >= AnimLength)
	{
		if (AnimLoopFunc)
		{
			// if this returns true, then the anim should be stopped
			if (AnimLoopFunc(this))
			{
				// @todo - maybe make this a concept of OneShot sprites that can freeze last frame or first frame?
//				SafeDelete();
			}
		}
		AnimTime = fmodf(AnimTime, AnimLength);
	}
	
	// calculate the frame within the animation
	Frame = (int)(Images.size() * AnimTime / AnimLength);
}

void WoflSprite::SetCollisionLine(const Vector& Start, const Vector& End)
{
	CollisionLineStart = Start;
	CollisionLineNormal = (End - Start).Normal();
	CollisionLineLength = (End - Start).Length();
}

// collide a sprite against this one
// return true if it hit, and also the angle of "exit"
bool WoflSprite::RunCollision(WoflSprite* Collider, Vector& OutPosition, Vector& OutDirection)
{
	// make sure we can actually collide
	if (!HasCollision() || !Collider->HasCollision() || Collider == this)
	{
		return false;
	}

	// get collider position
	Vector ColliderCenter = Collider->GetCenter();

	// if I have a collision radius, then use circle/circle collision
	if (CollisionRadius > 0)
	{
		// get my position
		Vector MyCenter = GetCenter();
		
		Vector Dist = ColliderCenter - MyCenter;
		
		float CombinedRadius = CollisionRadius + Collider->CollisionRadius;
		
		float SquaredDistance = Dist.LengthSquared();
		if (SquaredDistance <= CombinedRadius * CombinedRadius)
		{
			// get the normal between the centers
			OutDirection = Dist.Normal();
			
			// push out from my center
			OutPosition = MyCenter + OutDirection * CombinedRadius;
			
			// let the sprite do something on collision
			OnCollision(Collider);
			
			return true;
		}
	}
	// otherwise, perform circle/line collision
	else
	{
		Vector LineToCollider = ColliderCenter - CollisionLineStart;
		
		// project onto the collision line
		float Dot = LineToCollider.Dot(CollisionLineNormal);

		// make sure we lie along the line
		if (Dot < 0.0f || Dot > CollisionLineLength)
		{
			return false;
		}
		
		// multiply that by the normal to get the perpindicular (closest) point on the line to the point
		Vector ClosestPoint = CollisionLineStart + CollisionLineNormal * Dot;
		
		float DistSq = (ColliderCenter - ClosestPoint).LengthSquared();
//printf("Dist to line = %f\n", sqrt(DistSq));
		// is it closer to the line than collision radius
		if (DistSq < Collider->CollisionRadius * Collider->CollisionRadius)
		{
			// @todo: we should really be reflecting around the line's normal (perpindicular to collisionlinenormal)
			OutDirection = (ColliderCenter - ClosestPoint).Normal();
			OutPosition = ClosestPoint + OutDirection * Collider->CollisionRadius;
			
			return true;
		}
	}
	
	return false;
}

bool WoflSprite::HitTest(const Vector& HitLoc)
{
	if (bIsFullScreenInput)
	{
		return true;
	}
	
	// get rect
	Vector TopLeft = GetPosition();
	Vector BottomRight = TopLeft + GetSize();

//	WLOG("Testing [%f,%f], against [%f,%f %f,%f]\n",
//		 HitLoc.X, HitLoc.Y,
//		 TopLeft.X, TopLeft.Y,
//		 BottomRight.X, BottomRight.Y);
	

	// simple box test
	return (HitLoc.X >= TopLeft.X && HitLoc.X <= BottomRight.X &&
			HitLoc.Y >= TopLeft.Y && HitLoc.Y <= BottomRight.Y);
}
