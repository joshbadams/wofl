//
//  WoflInput.cpp
//  Wofl
//
//  Created by Josh on 2/22/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflInput.h"
#include "WoflWorld.h"
#include "WoflSprite.h"

void WoflInput::PreWorldTick(float DeltaTime)
{
	for (const KeyEvent& KeyEvent : QueuedKeys)
	{
		if (OnPreInputFunc && OnPreInputFunc(&KeyEvent, nullptr) == true)
		{
			continue;
		}
		
		if (KeyEvent.KeyCode != WoflKeys::None && KeyCapturedSprite != nullptr)
		{
			if (KeyCapturedSprite->IsRooted())
			{
				KeyCapturedSprite->OnKey(KeyEvent);
			}
			
			if (KeyEvent.Type == KeyType::Down)
			{
				WLOG("Increment capure\n");
				CapturedKeysDown++;
			}
			if (KeyEvent.Type == KeyType::Up)
			{
				WLOG("Decrement capure\n");
				CapturedKeysDown--;
			}
			
			if (CapturedKeysDown == 0)
			{
				WLOG("clearning capture\n");
				KeyCapturedSprite = nullptr;
			}
		}
		else if (KeyEvent.Type == KeyType::Down)
		{
			WoflWorld::Get()->VisitEx(true, false, nullptr, [this, &KeyEvent](WoflSprite* Sprite)
				{
					bool bWasHandled = Sprite->OnKey(KeyEvent);
					if (bWasHandled)
					{
						WLOG("setting capture\n");
						if (KeyEvent.KeyCode != WoflKeys::None)
						{
							KeyCapturedSprite = Sprite;
							CapturedKeysDown++;
						}
					}
					return !bWasHandled;
				});
		}
	}
	QueuedKeys.clear();
	
	// process each one
	for (const TouchEvent& Touch : QueuedTouches)
	{
		if (OnPreInputFunc && OnPreInputFunc(nullptr, &Touch) == true)
		{
			continue;
		}
		
		CapturedTouch& Capture = CapturedTouches[Touch.FingerIndex];

		Vector PrevLocation = Capture.Location;
		Capture.Location = Vector(Touch.X, Touch.Y);
		if (Touch.Type == TouchType::Begin)
		{
			WoflSprite* HitSprite = WoflWorld::Get()->HitTest(Capture.Location);
			Capture.Sprite = HitSprite;
			Capture.LastRepeatTime = 0.0;
			Capture.RepeatCount = 0;
			
			if (HitSprite)
			{
				HitSprite->OnClick();
				HitSprite->OnInput(Capture.Location, 0);
				
				if (HitSprite->GetCaptureType() == SpriteCaptureType::SingleClick)
				{
					Capture.Phase = CapturedTouchPhase::WaitingForEnd;
				}
				else
				{
					Capture.Phase = CapturedTouchPhase::Captured;
				}
			}
		}
		else if (Touch.Type == TouchType::End)
		{
			// find the captured touch and uncapture
			Capture.Phase = CapturedTouchPhase::None;
			if (Capture.Sprite != nullptr && Capture.Phase == CapturedTouchPhase::Captured)
			{
				// let go of the touch
				Capture.Sprite->OnInput(Capture.Location, -1);
			}
			Capture.Sprite = nullptr;
		}
		else
		{
			// cancel if move needs to cancel
			if (Capture.Sprite &&
				Capture.Phase == CapturedTouchPhase::Captured &&
				Capture.Sprite->GetCaptureType() == SpriteCaptureType::RepeatCancelOnMove)
			{
				Capture.Sprite->OnInput(Capture.Location, -1);
				Capture.Phase = CapturedTouchPhase::WaitingForEnd;
				Capture.Sprite = nullptr;
			}
		}
	}
	
	// now look at all captures and send messages
	for (CapturedTouch& Capture : CapturedTouches)
	{
		if (Capture.Phase == CapturedTouchPhase::Captured)
		{
			Capture.LastRepeatTime += DeltaTime;
			
			while (true)
			{
				const float Delay = (Capture.RepeatCount == 0) ? Capture.Sprite->GetInitialRepeatDelay() :
					Capture.Sprite->GetSecondaryRepeatDelay();
				
				if (Capture.LastRepeatTime > Delay)
				{
					Capture.Sprite->OnInput(Capture.Location, ++Capture.RepeatCount);
					Capture.LastRepeatTime -= Delay;
				}
				else
				{
					break;
				}
			}
				
			if (Capture.Sprite->GetCaptureType() == SpriteCaptureType::RepeatCancelOnLeave)
			{
				if (!Capture.Sprite->HitTest(Capture.Location))
				{
					Capture.Phase = CapturedTouchPhase::WaitingForEnd;
					Capture.Sprite = nullptr;
				}
			}
		}
	}
}

void WoflInput::SpriteRemoved(WoflSprite* Sprite)
{
	for (CapturedTouch& Capture : CapturedTouches)
	{
		if (Capture.Sprite == Sprite)
		{
			Capture.Phase = CapturedTouchPhase::WaitingForEnd;
			Capture.Sprite = nullptr;
		}
	}
}

