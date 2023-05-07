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
	GetArrayFromObject(NewsItems, Object, "news");

	//Items.push_back(new Item { 1, "pawn ticket" });
	
	Json::Value StringList = Object["strings"];
	for (auto Name : StringList.getMemberNames())
	{
		Strings[Name] = StringList[Name].asString();
	}

	GetIntMapFromObject(Items, Object, "items");
}

void Room::FromJsonObject(const Json::Value& Object)
{
	ID = GetString(Object, "id");
	BackgroundImage = GetString(Object, "background");
	GetArrayFromObject(Conversations, Object, "conversations");
}

void Conversation::FromJsonObject(const Json::Value& Object)
{
	Tag = GetString(Object, "tag");
	Condition = GetString(Object, "condition");
	Action = GetString(Object, "action");
	Message = GetString(Object, "message");
	Continue = GetString(Object, "continue");
	Inventory = GetString(Object, "inventory");
	
	GetStringArrayFromObject(Lines, Object, "lines");
	GetArrayFromObject(Options, Object, "options");
	
//	for (auto Name : Object.getMemberNames())
//	{
//		string NameStr(Name);
//		if (Object[Name].isString())
//		{
//			WLOG("Member %s = %s\n", NameStr.c_str(), Object[Name].asString().c_str());
//		}
//	}
}

void Option::FromJsonObject(const Json::Value& Object)
{
	Line = GetString(Object, "line");
	Response = GetString(Object, "response");
	Set = GetString(Object, "set");
}

void Item::FromJsonObject(const Json::Value &Object)
{
	ID = GetInt(Object, "id");
	Name = GetString(Object, "name");
}

void NewsItem::FromJsonObject(const Json::Value &Object)
{
	Date = GetInt(Object, "date");
	Title = GetString(Object, "title");
	Message = GetString(Object, "message");
	Condition = GetString(Object, "condition");
}
