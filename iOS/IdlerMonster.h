//
//  Monster.hpp
//  Idler
//
//  Created by Josh on 4/18/22.
//  Copyright © 2022 Josh. All rights reserved.
//

#pragma once
#include "WoflSprite.h"
#include "Num.h"

struct MonsterData
{
	string Name;
	
	Num BaseHP;
	Num BaseXP;
	Num BaseGold;
	
	float PerRankHP;
	float PerRankXP;
	float PerRankGold;
};

struct MonsterState : MonsterData
{
	Num Caught;

	int Rank;
	Num HP;
	Num XP;
	Num Gold;
};

class MonsterRegistry
{
public:
	vector<MonsterState> Data;
	
	MonsterRegistry();
};

class IdlerMonster : public WoflSprite
{
public:
	IdlerMonster();
	
	Num CurHP;
	Num MaxHP;
	float HPRatio;


	void InitFromState(const MonsterState& Data);
	void SubtractHP(Num Change);

};

