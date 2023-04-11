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
	
	vector<int> RankUpCount;
	
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
	
	int GetRandomMonsterID();
	void IncreaseCaught(int Amount, int ID);
};

class IdlerMonster : public WoflSprite
{
public:
	IdlerMonster();
	
	Num CurHP;
	Num MaxHP;
	int RegistryID;
	float HPRatio;


	void InitFromState(const MonsterState& Data, int RegID);
	void SubtractHP(Num Change);

};

