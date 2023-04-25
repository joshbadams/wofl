//
//  Config.hpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#pragma once

#include <Wofl/Wofl.h>


class Option : public LoadJsonObj
{
public:
	string Line;
	string Response;
	string Set;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Conversation : public LoadJsonObj
{
public:
	string Tag;
	string Condition;
	string Message;
	string Continue;
	string Inventory;

	vector<string> Lines;
	vector<Option*> Options;

	virtual void FromJsonObject(const Json::Value& Object) override;
};



class Room : public LoadJsonObj
{
public:
	string ID;
	string BackgroundImage;

	vector<Conversation*> Conversations;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};



class NeuroConfig : public LoadJsonObj
{
public:
	vector<Room*> Rooms;

	NeuroConfig();
	
	virtual void FromJsonObject(const Json::Value& Object) override;

	
};
