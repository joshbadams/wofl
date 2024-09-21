//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#pragma once

#include "Gridbox.h"
#include "NeuroState.h"


class SiteBox : public Gridbox
{
public:
	
	SiteBox(float X, float Y, float SizeX, float SizeY);
		
protected:
	virtual void OnClickEntry(GridEntry& Entry) override;
	virtual void CloseMessages() override;
	virtual void OnGenericContinueInput() override;
	
};
