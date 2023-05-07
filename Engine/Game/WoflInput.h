//
//  WoflInput.h
//  Wofl
//
//  Created by Josh on 2/22/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//


#pragma once
#pragma clang system_header

#include WOFL_INC(Math)

#define WOFL_MAX_FINGERS 5

class WoflSprite;

enum class KeyType
{
	Down,
	Repeat,
	Up,
};

struct KeyEvent
{
	int KeyCode;
	char Char;
	KeyType Type;
};

enum class TouchType
{
	Begin,
	Update,
	End,
};

struct TouchEvent
{
	int FingerIndex;
	float X, Y;
	TouchType Type;
};

class WoflInput
{
public:
	WoflInput()
	{
		// register ourself
		Utils::Input = this;
	}
	
	virtual void AddTouch(int FingerIndex, float X, float Y, TouchType Type)
	{
		TouchEvent Event = { FingerIndex, X, Y, Type };
		QueuedTouches.push_back(Event);
	}
	
	virtual void AddKey(int KeyCode, char Char, KeyType Type)
	{
		QueuedKeys.push_back({KeyCode, Char, Type});
	}
	
	virtual void PreWorldTick(float DeltaTime);
	virtual void PostWorldTick()
	{
		QueuedTouches.clear();
	}
	
	virtual void SpriteRemoved(WoflSprite* Sprite);

protected:
	
	// touches pushed from platform
	vector<TouchEvent> QueuedTouches;
	vector<KeyEvent> QueuedKeys;

	enum class CapturedTouchPhase
	{
		None,
		Captured,
		WaitingForEnd,
	};
	
	struct CapturedTouch
	{
		class WoflSprite* Sprite = nullptr;
//		int FingerIndex = -1;
		CapturedTouchPhase Phase = CapturedTouchPhase::None;
		Vector Location;
		double LastRepeatTime;
		int RepeatCount = 0;
	};
	CapturedTouch CapturedTouches[WOFL_MAX_FINGERS];
};
