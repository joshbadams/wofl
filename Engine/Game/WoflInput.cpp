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
#include "WoflGame.h"

void WoflInput::PreWorldTick(float DeltaTime)
{
	for (const KeyEvent& KeyEvent : QueuedKeys)
	{
		if (OnPreInputFunc && OnPreInputFunc(&KeyEvent, nullptr) == true)
		{
			continue;
		}
		
		if (KeyEvent.KeyCode != WoflKeys::None && (KeyCapturedSprite != nullptr || bKeyCapturedByGame))
		{
			if (bKeyCapturedByGame)
			{
				WoflWorld::Get()->GetGame()->OnGlobalKey(KeyEvent);
			}
			else if (KeyCapturedSprite->IsRooted())
			{
				KeyCapturedSprite->OnKey(KeyEvent);
			}
			
			if (KeyEvent.Type == KeyType::Down)
			{
//				WLOG("Increment capure\n");
				CapturedKeysDown++;
			}
			if (KeyEvent.Type == KeyType::Up)
			{
//				WLOG("Decrement capure\n");
				CapturedKeysDown--;
			}
			
			if (CapturedKeysDown == 0)
			{
//				WLOG("clearning capture\n");
				KeyCapturedSprite = nullptr;
				bKeyCapturedByGame = false;
			}
		}
		else if (KeyEvent.Type == KeyType::Down)
		{
			if (WoflWorld::Get()->GetGame()->OnGlobalKey(KeyEvent))
			{
				bKeyCapturedByGame = true;
				CapturedKeysDown++;
			}
			else
			{
//				WLOG("Depth firwt, top down:\n");
//				WoflWorld::Get()->Visit(true, true, false,	[](WoflSprite* Sprite)
//				{
//					int D = Sprite->GetDepth();
//					for (int i = 0; i < D; i++) WLOG("  ");
//					WLOG("%s\n", Sprite->Describe().c_str());
//					return true;
//				});
				//WLOG("Depth firwt, bottom up:\n");
				//WoflWorld::Get()->Visit(false, true, false,	[](WoflSprite* Sprite)
				//{
				//	int D = Sprite->GetDepth();
				//	for (int i = 0; i < D; i++) WLOG("  ");
				//	WLOG("%s\n", Sprite->Describe().c_str());
				//	return true;
				//});
//				WLOG("Breadth firwt, top down:\n");
//				WoflWorld::Get()->Visit(true, false, false, [](WoflSprite* Sprite)
//				{
//					int D = Sprite->GetDepth();
//					for (int i = 0; i < D; i++) WLOG("  ");
//					WLOG("%s\n", Sprite->Describe().c_str());
//					return true;
//				});
//				WLOG("Breadth firwt, bottom up:\n");
//				WoflWorld::Get()->Visit(false, false, false, [](WoflSprite* Sprite)
//				{
//					int D = Sprite->GetDepth();
//					for (int i = 0; i < D; i++) WLOG("  ");
//					WLOG("%s\n", Sprite->Describe().c_str());
//					return true;
//				});
//
//				
//				
				WoflWorld::Get()->Visit(false, true, false,	[this, &KeyEvent](WoflSprite* Sprite)
					{
					
						bool bWasHandled = Sprite->OnKey(KeyEvent);
						if (bWasHandled)
						{
							//						WLOG("setting capture\n");
							if (KeyEvent.KeyCode != WoflKeys::None)
							{
								KeyCapturedSprite = Sprite;
								CapturedKeysDown++;
							}
						}
						return !bWasHandled;
					},
					nullptr);
			}
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
			
//			WLOG("loc %d %d\n", (int)Capture.Location.X, (int)Capture.Location.Y);
			
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

