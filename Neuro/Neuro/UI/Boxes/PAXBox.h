//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#pragma once

#include "Gridbox.h"


class PAXBox : public Gridbox
{
public:
	
	PAXBox(float X, float Y, float SizeX, float SizeY);

	virtual void MessageComplete() override;

	virtual void OnClickEntry(GridEntry& Entry) override;
	virtual void OnTextEntryComplete(const string& Text, const string& Tag) override;
	virtual void OnTextEntryCancelled() override;

	void Open();
	
private:
	void Update();
//	void DescribeItem(int Prefix, int ItemIndex);
//	char ItemDesc[20];
	
	virtual void CloseMessages() override;

	
	int Page;
	int Phase;
	int SubPhase;
	int NumPages;
	int CurrentItem;
	
	int NumItemsPerPage;
	int FirstItem;
	int ChosenItem;
	
	// some local state
	int CurrentMoney;
	int CurrentBank;
	string MailTo;

	vector<NewsItem*> CurrentNewsItems;
};
