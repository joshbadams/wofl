
#pragma once
#include "WoflGame.h"
#include "Num.h"
#include "WoflButton.h"
#include "IdlerMonster.h"

class IdlerGame : public WoflGame
{
public:
	IdlerGame();
	
	virtual void Tick(float DeltaTime) override;

	virtual class WoflHud* GetHud() override
	{
		return (class WoflHud*)Hud;
	}

//	void DoAttack(WoflButton* Button);
	void HoldAttack(int RepeatCount);
	void DoCatch(WoflButton* Button);
	void BuyLevel(WoflButton* Button);
	
private:
	Num Money;
	Num XP;
	Num XPTarget;
	Num Level;
	

	float* GetMonsterHealthRef();
	
private:
	friend class IdlerHud;
	
	class IdlerHud* Hud;
	class IdlerMonster* Monster;
	
	MonsterRegistry Reg;

	void StartNewMonster();
	void KillMonster();
	void CatchMonster();

};

