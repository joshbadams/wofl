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
	M.BaseXP = 1;
	M.BaseGold = 1;
	M.PerRankHP = 1.1;
	M.PerRankXP = 1.05;
	M.PerRankGold = 1.09;
	
	M.Caught = 0;
	M.Rank = 1;
	M.HP = M.BaseHP;
	M.XP = M.BaseXP;
	M.Gold = M.BaseGold;
	
	Data.push_back(M);
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

void IdlerMonster::InitFromState(const MonsterState& State)
{
	CurHP = MaxHP = State.HP;
}

void IdlerMonster::SubtractHP(Num Change)
{
	CurHP = std::clamp<Num>(CurHP - Change, 0, MaxHP);
	HPRatio = (float)CurHP.Ratio(MaxHP);
}
