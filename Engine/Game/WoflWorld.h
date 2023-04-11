//
//  WoflWorld.h
//  Wofl
//
//  Created by Josh on 2/16/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef __Wofl__WoflWorld__
#define __Wofl__WoflWorld__

#include <functional>

class WoflSprite;

class WoflWorld
{
public:

	static WoflWorld* Get();

	void SetGame(class WoflGame* InGame)
	{
		Game = InGame;
	}
	
	WoflGame* GetGame() const
	{
		return Game;
	}
	
	WoflSprite* GetRootSprite() const
	{
		return RootSprite;
	}

	void SetRootSprite(WoflSprite* NewRoot)
	{
		RootSprite = NewRoot;
	}
	
	void SetViewOffset(const Vector& Offset)
	{
		ViewOffset = Offset;
	}
	
	Vector GetViewOffset()
	{
		return ViewOffset;
	}

	void SetViewScale(const Vector& Scale)
	{
		ViewScale = Scale;
	}

	Vector GetViewScale()
	{
		return ViewScale;
	}
	
	
	
	// process the world
	void Tick();
	
	// render the world
	void Render();
	
	// perform hit test (returns the childmost sprite)
	WoflSprite* HitTest(Vector ScreenLocation);
	
	// delay delete a sprite
	void DeleteSprite(WoflSprite* Sprite)
	{
		SpritesToDelete.push_back(Sprite);
	}
	
	
	void Visit(bool bVisitBeforeMoving, bool bDepthFirst, bool bForCollision, const function<bool(WoflSprite*)>& VisitFunction, WoflSprite* CurrentSprite=nullptr);
/*
	class Iterator
	{
	public:
		Iterator(WoflSprite* Root, bool bInIsCollision)
			: Sprite(Root)
			, OriginalRoot(Root)
			, bIsCollision(bInIsCollision)
		{
			// make sure the initial sprite has collision
			if (bIsCollision && !Sprite->HasCollision())
			{
				GoNext();
			}
		}
		
		operator bool() const
		{
			return Sprite != NULL;
		}
		
		void GoNext()
		{
			do
			{
				if (Sprite->GetChild())
				{
					Sprite = Sprite->GetChild();
				}
				else if (Sprite->GetNext())
				{
					Sprite = Sprite->GetNext();
				}
				else
				{
					// pop up to the parent
					Sprite = Sprite->GetParent();
					
					// if we have gone back up past the Root, we need to stop
					if (Sprite == OriginalRoot->GetParent())
					{
						Sprite = NULL;
					}
					
					// go to it's sibling if it had one
					if (Sprite)
					{
						Sprite = Sprite->GetNext();
					}
				}
			} while (bIsCollision && Sprite && !Sprite->HasCollision());
		}
		
		void operator++()
		{
			GoNext();
		}

		
		// iterator variables
		WoflSprite* Sprite;
		
	protected:
		WoflSprite* OriginalRoot;
		
		// true if we only want collidable sprites
		bool bIsCollision;
	};
	
	Iterator GetIterator(WoflSprite* InitialSprite=NULL)
	{
		return Iterator(InitialSprite ? InitialSprite : RootSprite, false);
	}
	
	Iterator GetCollisionIterator(WoflSprite* InitialSprite=NULL)
	{
		return Iterator(InitialSprite ? InitialSprite : RootSprite, true);
	}
*/
	void DumpWorld();
	
protected:
	
	static WoflWorld* World;
	WoflWorld();

	void VisitInner(bool bVisitBeforeMoving, bool bDepthFirst, bool bForCollision,
					const function<bool(WoflSprite*)>& VisitFunction,
					WoflSprite* CurrentSprite, bool& bAbortedVisiting);

	
	// list of sprites to delete at the end of the frame
	std::vector<WoflSprite*> SpritesToDelete;
	
	WoflSprite* RootSprite;
		
	double LastTickTime;
	
	class WoflGame* Game;
	
	Vector ViewOffset, ViewScale;
};

#endif /* defined(__Wofl__WoflWorld__) */
