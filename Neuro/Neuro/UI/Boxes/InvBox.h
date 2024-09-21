//
//  Textbox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#pragma once

#include "GridBox.h"

class InvBox : public Gridbox
{
public:
	
	InvBox(float X, float Y, float SizeX, float SizeY);
	
protected:
	virtual void OnGenericContinueInput() override;

private:
	void DescribeItem(int Prefix, int ID);
	char ItemDesc[20];
	
	int Page;
	int Phase;
	int NumPages;
	int NumInvPerPage;
	int CurrentItem;
};
