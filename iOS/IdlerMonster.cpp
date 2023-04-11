//
//  Monster.cpp
//  Idler
//
//  Created by Josh on 4/18/22.
//  Copyright © 2022 Josh. All rights reserved.
//

#include "IdlerMonster.h"



MonsterRegistry::MonsterRegistry()
{
	MonsterState M;
	M.Name = "Slime";
	M.BaseHP = 6;
	M.BaseXP = 10;
	M.BaseGold = 1;
	M.PerRankHP = 5;
	M.PerRankXP = 4.2;
	M.PerRankGold = 8;
	
	M.Caught = 0;
	M.Rank = 1;
	M.HP = M.BaseHP;
	M.XP = M.BaseXP;
	M.Gold = M.BaseGold;
	
	M.RankUpCount = { 0, 2, 4, 8, 16 };
	
	Data.push_back(M);
}

int MonsterRegistry::GetRandomMonsterID()
{
	return rand() % (int)Data.size();
}

void MonsterRegistry::IncreaseCaught(int Amount, int ID)
{
	MonsterState& State = Data[ID];
	
	State.Caught = State.Caught + Amount;
	
	while (State.Caught >= State.RankUpCount[State.Rank])
	{
		State.Rank++;
		State.HP = State.HP * State.PerRankHP;
		State.XP = State.XP * State.PerRankXP;
		State.Gold = State.Gold * State.PerRankGold;
	}
}



IdlerMonster::IdlerMonster()
	: WoflSprite(0, 0, -1, -1)
{
	WoflImage* Image = new WoflImage("Monster", 0, 0, 1, 1);
	AddImage(Image);
		
	SetPosition(Vector(0, 0));
	
	CurHP = MaxHP = 100;
	SubtractHP(0);
}

void IdlerMonster::InitFromState(const MonsterState& State, int RegID)
{
	RegistryID = RegID;
	CurHP = MaxHP = State.HP;
	SubtractHP(0);
}

void IdlerMonster::SubtractHP(Num Change)
{
	CurHP = std::clamp<Num>(CurHP - Change, 0, MaxHP);
	HPRatio = (float)CurHP.Ratio(MaxHP);
}
