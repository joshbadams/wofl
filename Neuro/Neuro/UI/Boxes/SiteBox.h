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

	virtual void MessageComplete() override;

	virtual void Open(LuaRef* OpenedSite) override;
	
protected:
	virtual void OnClickEntry(GridEntry& Entry) override;
	virtual void OnTextEntryComplete(const string& Text, const string& Tag) override;
	virtual void OnTextEntryCancelled() override;
	virtual void CloseMessages() override;
	virtual void OnGenericContinueInput() override;

private:
	virtual void Update() override;
	
//	Site* CurrentSite;
	SitePage* CurrentPage;
	
	int Page;
	int Phase;
	int SubPhase;
	int ActiveListEntry;
};
