
#include "IdlerGame.h"
#include "IdlerHud.h"
#include "IdlerMonster.h"
#include "WoflWorld.h"

WoflGame* GlobalGameInitialization()
{
	return new IdlerGame();
}

IdlerGame::IdlerGame()
	: WoflGame("Idler")
{
	Num A(69000010);
	A.Print();
	Num B(1200);
	B.Print();
	Num C(22222);
	C.Print();
	Num D(22000000);
	D.Print();
	Num E(22000000000ull);
	E.Print();
	Num F(22000000000000ull);
	F.Print();
	Num G(22000000000000000ull);
	G.Print();
	Num H(220000000000000000ull);
	H.Print();
	Num I(223333333333333333ull);
	I.Print();
	Num J(1000000000);//000000000000ull);
	J.Print();
	J.Units += 5;
	J.Print();
	printf("---------------------------\n");
	Num Sum;
//	Sum = B + C;
//	Sum.Print();
//	Sum = H + B;
//	Sum.Print();
//	Sum = H + H;
//	Sum.Print();
//	Sum = H + H + H;
//	Sum.Print();
//	Sum = H + H + H + H +H+ H+ H+ H+ H+ H;
//	Sum.Print();
//
	Num Mul;
//	Num Mul = B * 1000;
//	Mul.Print();
//	Mul = B * 2;
//	Mul.Print();
//	Mul = B * C;
//	Mul.Print();
//	Mul = H * B;
//	Mul.Print();
//	Mul = H * H;
//	Mul.Print();
	Mul = H * J;
	Mul = Mul * H;
	Mul.Print();

	Num A1(2000, 5);
	A1.Print();
	Num A2(2, 15);
	A2.Print();
	Num A3(2000, 0);
	A3.Print();

	
	Money = Num(1000);
	Level = 1;
		
	Monster = new IdlerMonster();
	WoflWorld::World->SetRootSprite(Monster);

	StartNewMonster();
	
	Hud = new IdlerHud(this);
}

void IdlerGame::Tick(float DeltaTime)
{
//	Money = Money * 1.05;
}

void IdlerGame::StartNewMonster()
{
	int Index = rand() % (int)Reg.Data.size();
	const MonsterState& State = Reg.Data[Index];
	
	Monster->InitFromState(State);
}

void IdlerGame::DoAttack(WoflButton* Button)
{
	Monster->SubtractHP(Level);
//	if (Monster->CurHP == 0)
	{
//		XP = XP + Monster->XP;
	}
}

void IdlerGame::HoldAttack(int RepeatCount)
{
	if (RepeatCount >= 0)
	{
		Monster->SubtractHP(Level);
		if (Monster->CurHP == 0)
		{
			XP = XP + 5;
			StartNewMonster();
		}
	}
}

void IdlerGame::DoCatch(WoflButton* Button)
{
	Money = Money + 20;
}

void IdlerGame::BuyLevel(WoflButton* Button)
{
	if (Money > 99)
	{
		Level = Level + 1;
		Money = Money - 100;
	}
}


float* IdlerGame::GetMonsterHealthRef()
{
	return &Monster->HPRatio;
}








