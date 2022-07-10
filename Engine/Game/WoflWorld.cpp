//
//  WoflWorld.cpp
//  Wofl
//
//  Created by Josh on 2/16/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflWorld.h"
#include "WoflPlatform.h"
#include "WoflGame.h"
#include "WoflRenderer.h"
#include "WoflButton.h"
#include "WoflHud.h"

// singleton world
WoflWorld* WoflWorld::World = NULL;

WoflWorld::WoflWorld()
	: RootSprite(NULL)
	, Game(NULL)
{
	World = this;
			
	// initialize tick time tracker
	LastTickTime = Utils::Platform->GetTime();
	
	ViewScale = Vector(1.0f, 1.0f);
	ViewOffset = Vector(0.0f, 0.0f);
}

void WoflWorld::Tick()
{
	// calculate the time since last tick
	double CurrentTime = Utils::Platform->GetTime();
	float DeltaTime = (float)(CurrentTime - LastTickTime);
	LastTickTime = CurrentTime;

	Utils::Input->PreWorldTick(DeltaTime);
	
	if (WoflWorld::World)
	{
		// tick everything in the world
		WoflWorld::World->Visit(true, true, false,
								[=](WoflSprite* Sprite)
								{
									Sprite->Tick(DeltaTime);
									return true;
								});
	}

	// tick the game
	if (Game)
	{
		Game->Tick(DeltaTime);
		if (Game->GetHud())
		{
			Game->GetHud()->Tick(DeltaTime);			
		}
	}
	
	Utils::Input->PostWorldTick();
	
	// delete any queued sprites
	for (WoflSprite* Sprite : SpritesToDelete)
	{
		Utils::Input->SpriteRemoved(Sprite);
		delete Sprite;
	}
	
	SpritesToDelete.clear();
}

// render the world
void WoflWorld::Render()
{
	WoflRenderer::Renderer->BeginFrame();
	WoflRenderer::Renderer->DrawScene(RootSprite);

	// let the game render on top of the world
	if (Game)
	{
		WoflRenderer::Renderer->DrawScene(Game->GetHud());

		Game->PostRender();
	}
	WoflRenderer::Renderer->EndFrame();
}

void WoflWorld::Visit(bool bVisitBeforeMoving, bool bDepthFirst, bool bForCollision, const function<bool(WoflSprite*)>& VisitFunction, WoflSprite* CurrentSprite)
{
	bool bAbortedVisiting = false;
	
	// start at root
	if (CurrentSprite == nullptr)
	{
		CurrentSprite = RootSprite;
	}
	
	if (CurrentSprite != nullptr)
	{
		VisitInner(bVisitBeforeMoving, bDepthFirst, bForCollision, VisitFunction, CurrentSprite, bAbortedVisiting);
	}
}

void WoflWorld::VisitInner(bool bVisitBeforeMoving, bool bDepthFirst, bool bForCollision,
						   const function<bool(WoflSprite*)>& VisitFunction,
						   WoflSprite* CurrentSprite, bool& bAbortedVisiting)
{
	// should we call the visitor function on this node
	bool bShouldVisit = !bForCollision || CurrentSprite->HasCollision();
	
	if (bVisitBeforeMoving && bShouldVisit && !bAbortedVisiting)
	{
		// visit and stop if requested
		if (VisitFunction(CurrentSprite) == false)
		{
			bAbortedVisiting = true;
		}
	}
	
	// move on to the next one if we haven't cancelled
	if (!bAbortedVisiting)
	{
		if (bDepthFirst)
		{
			if (CurrentSprite->GetChild())
			{
				VisitInner(bVisitBeforeMoving, bDepthFirst, bForCollision, VisitFunction, CurrentSprite->GetChild(), bAbortedVisiting);
			}
			if (CurrentSprite->GetNext())
			{
				VisitInner(bVisitBeforeMoving, bDepthFirst, bForCollision, VisitFunction, CurrentSprite->GetNext(), bAbortedVisiting);
			}
		}
		else if (bDepthFirst)
		{
			if (CurrentSprite->GetNext())
			{
				VisitInner(bVisitBeforeMoving, bDepthFirst, bForCollision, VisitFunction, CurrentSprite->GetNext(), bAbortedVisiting);
			}
			if (CurrentSprite->GetChild())
			{
				VisitInner(bVisitBeforeMoving, bDepthFirst, bForCollision, VisitFunction, CurrentSprite->GetChild(), bAbortedVisiting);
			}
		}
	}

	if (!bVisitBeforeMoving && bShouldVisit && !bAbortedVisiting)
	{
		// visit and stop if requested
		if (VisitFunction(CurrentSprite) == false)
		{
			bAbortedVisiting = true;
		}
	}
}

WoflSprite* WoflWorld::HitTest(Vector ScreenLocation)
{
	// convert screenspace to local
	Vector Loc = (ScreenLocation - ViewOffset) / ViewScale;
	// printf("ScreenLoc = [%.2f, %.2f], Local = [%.2f, %2.f]\n", ScreenLocation.X, ScreenLocation.Y, Loc.X, Loc.Y);
	
	WoflSprite* HitSprite = NULL;
	
	// hit test orderand list
	WoflSprite* Roots[] = { Game->GetHud(), RootSprite };
	
	for (int Index = 0; HitSprite == nullptr && Index < ARRAY_COUNT(Roots); Index++)
	{
		// first try the Hud for clicks
		WoflWorld::World->Visit(false, true, false,
								[&](WoflSprite* Sprite)
								{
									if (Sprite->IsClickEnabled() && Sprite->HitTest(Loc))
									{
										HitSprite = Sprite;
										return false;										
									}
									return true;
								},
								Roots[Index]);
	}

	return HitSprite;
}
