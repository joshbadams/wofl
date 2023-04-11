//
//  NeuroGame.cpp
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#include "NeuroGame.h"

NeuroGame::NeuroGame()
: WoflGame("Neuromancer")
{
	WoflLabel* Label = new WoflLabel("Hi", false, false, 100, 100, 200, 200);
	WoflWorld::Get()->SetRootSprite(Label);

}
