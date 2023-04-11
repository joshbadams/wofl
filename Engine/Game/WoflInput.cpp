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
	// process each one
	for (const TouchEvent& Touch : QueuedTouches)
	{
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

