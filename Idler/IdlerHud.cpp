//
//  IdlerHud.cpp
//  Idler
//
//  Created by Josh on 4/18/22.
//  Copyright © 2022 Josh. All rights reserved.
//

#include "IdlerHud.h"
#include "WoflButton.h"
#include "IdlerGame.h"
#include "IdProgress.h"

#define BUTTON_SIZE 100
#define LABEL_WIDTH 140
#define PADDING 20

IdlerHud::IdlerHud(class IdlerGame* InGame)
	: Game(InGame)
{
	int XOffset = 0;
	int YOffset = Size.Y - BUTTON_SIZE;

	MoneyLabel = new WoflLabel("---", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
	AddChild(MoneyLabel);
	XOffset += MoneyLabel->GetSize().X + PADDING;

	XPLabel = new WoflLabel("---", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
	AddChild(XPLabel);
	XOffset += XPLabel->GetSize().X + PADDING;

	LevelLabel = new WoflLabel("lvl", false, true, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
	LevelLabel->SetTextColor(WColor(1,0,0,1));
	AddChild(LevelLabel);
	XOffset += LevelLabel->GetSize().X + PADDING;

	YOffset = BUTTON_SIZE;
	XOffset = 0;
	
//	BuyLevelButton = new WoflButton(nullptr, "+", XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE, 0,
//									[this](WoflButton* Button) { Game->BuyLevel(Button); });
//	AddChild(BuyLevelButton);
//	XOffset += BuyLevelButton->GetSize().X + PADDING;
	
	
	WoflButton* AttackButton = new WoflButton(nullptr, "Attack", XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE, 0,
									SpriteCaptureType::RepeatCancelOnLeave,
									[this](WoflButton* Button, const Vector& Pos, int Repeat) { Game->HoldAttack(Repeat); });
	AddChild(AttackButton);
	XOffset += AttackButton->GetSize().X + PADDING;
	
	WoflButton* CatchButton = new WoflButton(nullptr, "Catch", XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE, 0,
									[this](WoflButton* Button) { Game->DoCatch(Button); });
	AddChild(CatchButton);
	XOffset += CatchButton->GetSize().X + PADDING;
	
	InfoLabel = new WoflLabel("lvl", false, true, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
	InfoLabel->SetTextColor(WColor(1,0,0,1));
	AddChild(InfoLabel);
	XOffset += InfoLabel->GetSize().X + PADDING;


	
	
	IdProgress* HP = new IdProgress(50, 800, 600, 60, "Monster");
	HP->SetValueRef(Game->GetMonsterHealthRef());
	AddChild(HP);
}

void IdlerHud::Tick(float DeltaTime)
{
	MoneyLabel->SetText(string("$") + Game->Money.ToString());
	LevelLabel->SetText(string("Lvl: ") + Game->Level.ToString());
	XPLabel->SetText(string("XP: ") + Game->XP.ToString());
	
	const MonsterState& State = Game->Reg.Data[Game->Monster->RegistryID];
	stringstream Format;
	Format << "Rank: " << State.Rank << " XP: " << State.XP.ToString() << " HP: " << State.HP.ToString() << " Gold: " << State.Gold.ToString();
	InfoLabel->SetText(Format.str());
	
	
//	BuyLevelButton->SetText("-100");
}
