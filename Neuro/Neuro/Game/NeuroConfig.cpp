//
//  Config.cpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#include "NeuroConfig.h"

NeuroConfig::NeuroConfig()
{
	LoadFromFile(Utils::File->GetResourcePath("data.json").c_str());
}

void NeuroConfig::FromJsonObject(const Json::Value& Object)
{
	GetArrayFromObject(Rooms, Object, "rooms");
}

void Room::FromJsonObject(const Json::Value& Object)
{
	ID = GetString(Object, "id");
	BackgroundImage = GetString(Object, "background");
//	LongDescription = GetString(Object, "longdescription");
//	Description = GetString(Object, "description");
	
//	GetObject(LongDescription, Object, "longdescription");
//	GetObject(Description, Object, "description");
	GetArrayFromObject(Conversations, Object, "conversations");
}

void Conversation::FromJsonObject(const Json::Value& Object)
{
	Tag = GetString(Object, "tag");
	Condition = GetString(Object, "condition");
	Message = GetString(Object, "message");
	Continue = GetString(Object, "continue");
	Inventory = GetString(Object, "inventory");
	
	GetStringArray(Lines, Object, "lines");
	GetArrayFromObject(Options, Object, "options");
	
	for (auto Name : Object.getMemberNames())
	{
		string NameStr(Name);
		if (Object[Name].isString())
		{
			WLOG("Member %s = %s\n", NameStr.c_str(), Object[Name].asString().c_str());
		}
	}
}

void Option::FromJsonObject(const Json::Value& Object)
{
	Line = GetString(Object, "line");
	Response = GetString(Object, "response");
	Set = GetString(Object, "set");
}
