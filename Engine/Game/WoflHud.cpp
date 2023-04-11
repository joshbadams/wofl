//
//  WoflHud.cpp
//  Wofl
//
//  Created by Josh on 6/17/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflHud.h"
#include "WoflRenderer.h"

WoflHud::WoflHud()
	: WoflSprite(0, 0, WoflRenderer::Renderer->GetViewSize().X, WoflRenderer::Renderer->GetViewSize().Y)
{
	
}
