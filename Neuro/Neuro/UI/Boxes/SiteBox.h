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


	void Open(Site* OpenedSite);
	
protected:
	virtual void OnClickEntry(GridEntry& Entry) override;
	virtual void OnTextEntryComplete(const string& Text) override;
	virtual void OnTextEntryCancelled() override;
	virtual void CloseMessages() override;
	virtual void OnGenericContinueInput() override;

private:
	void Update();
	
	Site* CurrentSite;
	SitePage* CurrentPage;
	
	int Page;
	int Phase;
	int SubPhase;
	int ActiveListEntry;
};
