//
//  FHMainHud.cpp
//  Wofl
//
//  Created by Josh on 6/17/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "FHMainHud.h"
#include "WoflButton.h"
#include "FHGame.h"
#include "FHRoom.h"
#include "FHBuilding.h"

#define BUTTON_SIZE 48
#define LABEL_WIDTH 100


FHMainHud::FHMainHud(class FHGame* InGame)
	: Game(InGame)
{
	int XOffset = 0;
	int YOffset = Size.Y - BUTTON_SIZE;

	// Gems
	{
		WoflSprite* Icon = new WoflSprite(XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE);
		Icon->AddImage(new WoflImage("gems"));
		AddChild(Icon);
		XOffset += Icon->GetSize().X;
		
		GemsLabel = new WoflLabel("---", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
		AddChild(GemsLabel);
		XOffset += GemsLabel->GetSize().X;
	}

	// Food
	{
		WoflSprite* Icon = new WoflSprite(XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE);
		Icon->AddImage(new WoflImage("food"));
		AddChild(Icon);
		XOffset += Icon->GetSize().X;
		
		FoodLabel = new WoflLabel("---", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
		AddChild(FoodLabel);
		XOffset += FoodLabel->GetSize().X;
	}
	
	// Bait
	{
		WoflSprite* Icon = new WoflSprite(XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE);
		Icon->AddImage(new WoflImage("bait"));
		AddChild(Icon);
		XOffset += Icon->GetSize().X;
		
		BaitLabel = new WoflLabel("---", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
		AddChild(BaitLabel);
		XOffset += BaitLabel->GetSize().X;
	}
	
	// Coins
	{
		WoflButton* BuyGoldButton = new WoflButton("Coin1", "+", XOffset, YOffset, BUTTON_SIZE, BUTTON_SIZE, Tag_Button_Gold,
												   [=](WoflButton* Button)
												   { Game->CurrentCoins += 1000; }
												   );
		AddChild(BuyGoldButton);
		XOffset += BuyGoldButton->GetSize().X;
		
		CoinsLabel = new WoflLabel("$$$", false, false, XOffset, YOffset, LABEL_WIDTH, BUTTON_SIZE);
		CoinsLabel->SetTextColor(WColor(1,0,0,1));
		AddChild(CoinsLabel);
		XOffset += CoinsLabel->GetSize().X;
	}
	




	WoflButton* AddFloorButton = new WoflButton("Construct", nullptr, Size.X - BUTTON_SIZE, Size.Y - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE, Tag_Button_Gold,
												[=](WoflButton* Button)
												{
													ERoomType Type = FHRoom::GetRandomRoomType();
													Game->CurrentBuilding->AddFloor(Type);
													Game->Save();
												}
												);
	AddChild(AddFloorButton);

}


void FHMainHud::Tick(float DeltaTime)
{
	// update HUD
	CoinsLabel->SetInt(Game->CurrentCoins);
	BaitLabel->SetInt(Game->CurrentBait);
	GemsLabel->SetInt(Game->CurrentGems);
	FoodLabel->SetInt(Game->CurrentFood);
}
