//
//  OustCell.h
//  Wofl
//
//  Created by Josh on 1/21/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#pragma once

#include "WoflSprite.h"

#define CELL_SIZE	80.0f
#define HEX_MULT	0.71132486540519

enum EDirection
{
	NW,
	NE,
	E,
	SE,
	SW,
	W,
	
	NumDirections
};

enum EPlayType
{
	Invalid,
	Capturing,
	NonCapturing,
};


// a temporary set of cells that we collect in another set
typedef vector<class OustCell*> CellSet;

class OustCell : public WoflSprite
{
public:
	OustCell(float XLoc, float YLoc, int InIndex, int CellX, int CellY, int EdgeSize, int NumItems, int NumAcross);

	// this is the entry point for the game trying to capture a (clicked on) cell
	// returns what happened (Capturing move, non-capturing move, or invalid)
	EPlayType AttemptCapture(int FriendlyColor);
	
protected:
	int CellIndex, Color;
	int Neighbors[NumDirections];

	
	OustCell* GetNeighbor(int Dir);
	
	// Recursively gather set of cells matching the color
	void MakeSets(int FriendlyColor, int RecursionLevel, vector<CellSet*>& SetList, CellSet* AddToSet);

	bool IsCapturingPlacement(vector<CellSet*>& SetList, int FriendlyColor);
	
	// A non-capturing placement is a placement that only
	// touches enemy or empty cells. Cannot touch friendly cells.
	bool IsNonCapturingPlacement(int FriendlyColor);
	
	// change color of cell
	void SetColor(int NewColor);
};
