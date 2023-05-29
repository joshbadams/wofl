//
//  Config.cpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#include "NeuroConfig.h"
#include "NeuroGame.h"


string NeuroConfigObj::PostProcessString(const string& String)
{
	const NeuroState& State = ((NeuroGame*)WoflGame::TheGame)->State;
	string NewString = String;
	State.StringReplacement(NewString, '%');
	return NewString;
}


NeuroConfig::NeuroConfig()
{
}

void NeuroConfig::Initialize()
{
	LoadFromFile(Utils::File->GetResourcePath("data.json").c_str());
}

void NeuroConfig::FromJsonObject(const Json::Value& Object)
{
	GetArrayFromObject(Rooms, Object, "rooms");
	GetArrayFromObject(NewsItems, Object, "news");
	GetIntMapFromObject(Items, Object, "items");
	GetStringMapFromObject(MailServer, Object, "mailserver");
	GetStringMapFromObject(Sites, Object, "sites");
		
	Json::Value StringList = Object["strings"];
	for (auto Name : StringList.getMemberNames())
	{
		Strings[Name] = StringList[Name].asString();
	}

	// get map of message arrays
	Json::Value MessagesList = Object["allmessages"];
	for (auto Name : MessagesList.getMemberNames())
	{
		GetArrayFromObject(AllMessages[Name], MessagesList[Name], "messages");
	}
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
	Set = GetString(Object, "set");
	
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
	Type =GetString(Object, "type");
}

void NewsItem::FromJsonObject(const Json::Value &Object)
{
	Date = GetInt(Object, "date");
	Title = GetString(Object, "title");
	Message = GetString(Object, "message");
	Condition = GetString(Object, "condition");
}

void Message::FromJsonObject(const Json::Value& Object)
{
	Date = GetInt(Object, "date");
	To = GetString(Object, "to");
	From = GetString(Object, "from");
	Message = GetString(Object, "message");
	Condition = GetString(Object, "condition");
}

void MailActions::FromJsonObject(const Json::Value& Object)
{
	for (auto Match : Object.getMemberNames())
	{
		Actions[PostProcessString(Match)] = PostProcessString(Object[Match].asString());
	}
}

void Site::FromJsonObject(const Json::Value& Object)
{
	Title = GetString(Object, "title");
	GetStringArrayFromObject(Passwords, Object, "passwords");
	GetStringMapFromObject(Pages, Object, "pages");
}

void SitePage::FromJsonObject(const Json::Value& Object)
{
	MessagesID = GetString(Object, "messagesid");
	StringID = GetString(Object, "stringid");
	Type = GetString(Object, "type");
	ExitDest = GetString(Object, "exit");
	Header = GetString(Object, "header");
	GetArrayFromObject(MenuEntries, Object, "menuentries");
	GetArrayFromObject(ListEntries, Object, "listentries");
	GetStringArrayFromObject(ListColumns, Object, "columns");
}

void MenuEntry::FromJsonObject(const Json::Value& Object)
{
	Name = GetString(Object, "name");
	Key = GetString(Object, "key")[0];
	Dest = GetString(Object, "dest");
}

void ListEntry::FromJsonObject(const Json::Value& Object)
{
	GetStringArrayFromObject(Fields, Object, "fields");
	Details = GetString(Object, "details");
}

