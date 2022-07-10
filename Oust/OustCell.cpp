//
//  OustCell.cpp
//  Wofl
//
//  Created by Josh on 1/21/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#include "OustCell.h"
#include "OustGame.h"

OustCell::OustCell(float XLoc, float YLoc, int CellIndex, int X, int Y, int EdgeSize, int NumItems, int NumAcross)
	: WoflSprite(XLoc, YLoc, CELL_SIZE, CELL_SIZE, Tag_Cell)
	, Color(0)
{
	WoflImage* WhiteHex = new WoflImage("Hex", 0.0, 0.0, 1.0, 1.0);
	AddImage(WhiteHex);
	
	if (Y < EdgeSize - 1)
	{
		Neighbors[NW] = (Y > 0 && X > 0) ? CellIndex - NumItems : -1;
		Neighbors[NE] = (Y > 0 && X < NumItems - 1) ? CellIndex - (NumItems - 1) : -1;
		Neighbors[SW] = CellIndex + NumItems;
		Neighbors[SE] = CellIndex + NumItems + 1;
	}
	else if (Y == EdgeSize - 1)
	{
		Neighbors[NW] = (X > 0) ? CellIndex - NumItems: -1;
		Neighbors[NE] = (X < NumItems - 1) ? CellIndex - (NumItems - 1) : -1;
		Neighbors[SW] = (Y < NumAcross - 1 && X > 0) ? CellIndex + (NumItems - 1): -1;
		Neighbors[SE] = (Y < NumAcross - 1 && X < NumItems - 1) ? CellIndex + NumItems : -1;
	}
	else
	{
		Neighbors[NW] = CellIndex - (NumItems + 1);
		Neighbors[NE] = CellIndex - NumItems;
		Neighbors[SW] = (Y < NumAcross - 1 && X > 0) ? CellIndex + (NumItems - 1): -1;
		Neighbors[SE] = (Y < NumAcross - 1 && X < NumItems - 1) ? CellIndex + NumItems : -1;
	}
	
	Neighbors[W] = (X > 0) ? CellIndex - 1 : -1;
	Neighbors[E] = (X < NumItems - 1) ? CellIndex + 1 : -1;
	
}



OustCell* OustCell::GetNeighbor(int Dir)
{
	// get the global index of the cell
	int Index = Neighbors[Dir];
	if (Index == -1)
	{
		return NULL;
	}
	
	// count until we find the cell
	WoflSprite* Travel = GetParent()->GetChild();
	for (int Count = 0; Count < Index; Count++)
	{
		Travel = Travel->GetNext();
	}
	
	// assume typecast is safe
	return (OustCell*)Travel;
}

void OustCell::MakeSets(int MatchColor, int RecursionLevel, vector<CellSet*>& SetList, CellSet* AddToSet)
{
	// this is always in the set
	AddToSet->push_back(this);
	
	// allocate space if needed
	for (int Dir = 0; Dir < NumDirections; Dir++)
	{
		if (Neighbors[Dir] != -1)
		{
			OustCell* Neighbor = GetNeighbor(Dir);
			if (Neighbor->Color == 0)
			{
				// do nothing for white neighbors
			}
			else if (Neighbor->Color == MatchColor)
			{
				// add to the desired set if it doesn't already exist
				if(std::find(AddToSet->begin(), AddToSet->end(), Neighbor) == AddToSet->end())
				{
					// if it doesn't already exist, recurse on it
					Neighbor->MakeSets(MatchColor, 0, SetList, AddToSet);
				}
			}
			else
			{
				// this is an enemy neighbor, figure out what to do with it
				if (RecursionLevel == 0)
				{
					// at level 0, we start making enemy groups
					// at level 1, we ignore enemies
					bool bAlreadyAdded = NO;
					for (size_t GroupIndex = 1; GroupIndex < SetList.size(); GroupIndex++)
					{
						CellSet* EnemyGroup = SetList[GroupIndex];
						if(std::find(EnemyGroup->begin(), EnemyGroup->end(), Neighbor) != EnemyGroup->end())
						{
							bAlreadyAdded = YES;
							break;
						}
					}
					// because we are doing a depth first search, if the cell isn't already
					// added to a group, then we must make a new group and add it's neighbors
					if (!bAlreadyAdded)
					{
						CellSet* NewSet = new CellSet;
						SetList.push_back(NewSet);
						
						// recurse!
						Neighbor->MakeSets(Neighbor->Color, 1, SetList, NewSet);
					}
				}
			}
		}
	}
}

bool OustCell::IsCapturingPlacement(vector<CellSet*>& SetList, int FriendlyColor)
{
	// can only play on white
	if (Color != 0)
	{
		return false;
	}
	
	// this is the set of friendly cells connected to this cell
	CellSet* PrimarySet = new CellSet;
	SetList.push_back(PrimarySet);
	
	// gather friendlies
	MakeSets(FriendlyColor, 0, SetList, PrimarySet);
		
	bool bCanCapture = true;

	// if there is only the friendly set, then it's not capturing, and
	// is not a valid move
	if (SetList.size() == 1)
	{
		bCanCapture = false;
	}
	else
	{
		// now check all of the sets to see if we captured!
		size_t PrimarySetCount = 0;
		for (vector<CellSet*>::iterator It = SetList.begin(); It != SetList.end(); It++)
		{
			CellSet* Set = *It;
			if (PrimarySetCount == 0)
			{
				PrimarySetCount = Set->size();
				printf("PrimaySetCount = %d\n", (int)PrimarySetCount);
			}
			else
			{
				// if an enemy group is same size or bigger than friendly group, then we fail to capture
				printf("NonSetCount = %d\n", (int)Set->size());
				if (Set->size() >= PrimarySetCount)
				{
					bCanCapture = false;
					break;
				}
			}
		}
	}
		
	return bCanCapture;
	
}

// A non-capturing placement is a placement that only
// touches enemy or empty cells. Cannot touch friendly cells.
bool OustCell::IsNonCapturingPlacement(int FriendlyColor)
{
	// can only play on white
	if (Color != 0)
	{
		return false;
	}
	
	for (int Dir = 0; Dir < NumDirections; Dir++)
	{
		if (Neighbors[Dir] != -1)
		{
			OustCell* Neighbor = GetNeighbor(Dir);
			if (Neighbor->Color == FriendlyColor)
			{
				return false;
			}
		}
	}
	
	return true;
}

EPlayType OustCell::AttemptCapture(int FriendlyColor)
{
	if (IsNonCapturingPlacement(FriendlyColor))
	{
		// we take it over, but end turn now
		SetColor(FriendlyColor);
		return NonCapturing;
	}
	
	// this will gather groups of cells
	vector<CellSet*> SetList;

	bool bIsCapturing = IsCapturingPlacement(SetList, FriendlyColor);
	
	if (bIsCapturing)
	{
		// we captured, so we need to flip lots!
		SetColor(FriendlyColor);
		
		// now capture all the enemies, but it's still the capturers turn!
		for (size_t SetIndex = 1; SetIndex < SetList.size(); SetIndex++)
		{
			CellSet* Set = SetList[SetIndex];
			for (CellSet::iterator It = Set->begin(); It != Set->end(); It++)
			{
				(*It)->SetColor(0);
			}
		}
	}
	
	// free all temp sets
	for (vector<CellSet*>::iterator It = SetList.begin(); It != SetList.end(); It++)
	{
		delete *It;
	}

	return bIsCapturing ? Capturing : Invalid;
}

void OustCell::SetColor(int NewColor)
{
	Color = NewColor;
	
	WoflImage* NewHex = new WoflImage(
	  NewColor == 0 ? "Hex" : NewColor == 1 ? "RedHex" : "BlueHex",
	  0.0, 0.0, 1.0, 1.0);
	
	ClearImages();
	AddImage(NewHex);

}

