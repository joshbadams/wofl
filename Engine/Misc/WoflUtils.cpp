//
//  Utils.cpp
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WoflUtils.h"


WoflFile* Utils::File = nullptr;
WoflInput* Utils::Input = nullptr;
WoflPlatform* Utils::Platform = nullptr;

WColor WColor::Black(0, 0, 0, 1);
WColor WColor::White(1, 1, 1, 1);
WColor WColor::Red(1, 0, 0, 1);
WColor WColor::Green(0, 1, 0, 1);
WColor WColor::Blue(0, 0, 1, 1);
