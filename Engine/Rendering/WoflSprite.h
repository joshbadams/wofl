//
//  WoflSprite.h
//  Wofl
//
//  Created by Josh on 2/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

class WoflRenderer;
class WoflImage;

enum class SpriteCaptureType
{
	// doesn't capture, just click once and then ignore input until lift
	SingleClick,
	// captures input, cancel repeat when finger is no longer touching sprite
	RepeatCancelOnLeave,
	// captures input, cancel repeat when finger is lifted, even if it leaves the sprite
	RpeeatCancelOnLift,
	// captures input, cancel repeat finger moves at all
	RepeatCancelOnMove,
};


class WoflSprite
{
public:
	
	WoflSprite(float X, float Y, float SizeX, float SizeY, int Tag=0);
	virtual ~WoflSprite();
	
	WoflSprite* GetNext() const
	{
		return Next;
	}
	
	WoflSprite* GetChild() const
	{
		return Child;
	}

	WoflSprite* GetParent() const
	{
		return Parent;
	}

	void AddSibling(WoflSprite* NewSprite);
	void AddChild(WoflSprite* NewSprite, bool bAddAsFirstChild=false);
	void RemoveFromParent();
	void RemoveFromWorld();
	
	bool IsRooted();

	
	// collision functionality
	void SetCollisionRadius(float InCollisionRadius)
	{
		CollisionRadius = InCollisionRadius;
	}
	void SetCollisionLine(const Vector& Start, const Vector& End);
	
	bool HasCollision() const
	{
		return CollisionRadius != 0.0f || CollisionLineLength != 0.0f;
	}
	
	// collide a sprite against this one
	// return true if it hit, pushed out location, and direction it was pushed out
	bool RunCollision(WoflSprite* Collider, Vector& OutLocation, Vector& OutDirection);

	// allows for subclasses to handle being hit
	virtual void OnCollision(WoflSprite* Collider)
	{
		
	}
	
	// tags
	void SetTag(int InTag)
	{
		Tag = InTag;
	}
	
	int GetTag()
	{
		return Tag;
	}
	
	// get final position and size, including the parents
	virtual Vector GetPosition() const;
	virtual Vector GetRelativePosition() const
	{
		return Position;
	}
	virtual Vector GetSize() const
	{
		return Size;
	}
	
	Vector GetCenter() const
	{
		return GetPosition() + GetSize() * 0.5;
	}
	
	void SetSize(const Vector& NewSize);
	void SetPosition(const Vector& NewPosition);
	void SetRelativePosition(const Vector& NewRelativePosition)
	{
		Position = NewRelativePosition;
	}
	void SetCenter(const Vector& NewCenterPosition)
	{
		SetPosition(NewCenterPosition - Size * 0.5f);
	}
	
	// adds a frame of aniumation (or single sprite, etc)
	void AddImage(WoflImage* Image)
	{
		Images.push_back(Image);
	}
	void ClearImages()
	{
		Images.clear();
	}
	
	void SetFramesPerSecond(float InFramesPerSecond)
	{
		FramesPerSecond = InFramesPerSecond;
	}
	
	void SetColor(const WColor& InColor)
	{
		Color = InColor;
	}
	
	const WColor& GetColor()
	{
		return Color;
	}
	
	void SetClickEnabled(bool bInClickEnabled)
	{
		bIsClickEnabled = bInClickEnabled;
	}
	bool IsClickEnabled()
	{
		return bIsClickEnabled;
	}
	
	// gets the current image to render
	virtual WoflImage* GetImage() const;

	// allow a subclass to perform any custom rendering before normal rendering
	// return true if the sprite is rendered and default rendering should not occur
	virtual bool CustomPreRender()
	{
		return false;
	}

	// allow a subclass to perform any custom rendering
	// return value is ignored
	virtual void CustomRender()
	{
	}

	// allow a subclass to perform any custom rendering after its children were rendererd
	// return value is ignored
	virtual void CustomPostChildrenRender()
	{
	}

	
	// allow the sprite to do per-frame processing
	virtual void Tick(float DeltaTime);
	
	
	// casting
	virtual class WoflButton* AsButton() { return nullptr; }
	virtual class WoflLabel* AsLabel() { return nullptr; }
	
	// called even for capturing/repeating sprites, this is the first click of the sprite
	virtual void OnClick()
	{
	}
	
	// RepeatIndex: 0 is first, > 0 is repeat, < 0 is end)
	virtual void OnInput(const Vector& ScreenLocation, int RepeatIndex)
	{
	}

	// called when key events happen, if this returns true, then it won't go up the sprite hierarchy
	virtual bool OnKey(const KeyEvent& Event)
	{
		return false;
	}
	

	virtual SpriteCaptureType GetCaptureType()
	{
		// default to just single click
		return SpriteCaptureType::SingleClick;
	}
	
	virtual float GetInitialRepeatDelay() { return 0.5f; }
	virtual float GetSecondaryRepeatDelay() { return 0.1f; }
	
	// defaults to simple Box test
	virtual bool HitTest(const Vector& HitLoc);

protected:
	
	// animation frames
	std::vector<WoflImage*> Images;
	float FramesPerSecond;
	int Frame;
	float AnimTime;
	
	// game defined tag
	int Tag;
	
	// clickable
	bool bIsClickEnabled;

	Vector Position;
	Vector Size;
	WColor Color;

	// next sprite in the list
	WoflSprite* Next;
	// first child
	WoflSprite* Child;
	// parent sprite (for first child)
	WoflSprite* Parent;
	
	// collision info
	float CollisionRadius;
	Vector CollisionLineStart, CollisionLineNormal;
	float CollisionLineLength;
	
	// tracks if it's in the world or not
	bool bIsAddedToWorld;
};
