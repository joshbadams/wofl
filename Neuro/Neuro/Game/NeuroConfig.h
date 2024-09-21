//
//  Config.hpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#pragma once

#include <Wofl/Wofl.h>

//class StringOrString
//{
//public:
//	string Get();
//
//	void Set(string& Val)
//	{
//		Value = Val;
//	}
//private:
//	string Value;
//	string CachedLuaValue;
//};
//
//class StringOrBool
//{
//public:
//	string Get();
//
//	void Set(string& Val)
//	{
//		Value = Val;
//	}
//private:
//	string Value;
//	string CachedLuaValue;
//};
#define StringOrString string
#define StringOrBool string

class Lua;
using LuaRef = shared_ptr<class LuaObjRef>;

class NeuroConfigObj// : public LoadJsonObj
{
public:
	virtual void FromLua(Lua& L, LuaRef Object);

protected:
	virtual string PostProcessString(const string& String);
};

class Option : public NeuroConfigObj
{
public:
	StringOrString Line;
	StringOrString Response;
	LuaRef Lua_OnEnd;

//	virtual void FromJsonObject(const Json::Value& Object) override;
	virtual void FromLua(Lua& L, LuaRef Object) override;
};

class Conversation : public NeuroConfigObj
{
public:
	~Conversation();
	
	string Tag;
	StringOrBool Condition;
	StringOrBool Action;
	
	LuaRef Lua_OnStart;
	LuaRef Lua_OnEnd;

	vector<string> Lines;
	vector<Option*> Options;

//	virtual void FromJsonObject(const Json::Value& Object) override;
	virtual void FromLua(Lua& L, LuaRef Object) override;
};



class Room : public NeuroConfigObj
{
public:
	string ID;
	string BackgroundImage;
	bool bHasPAX;
	bool bHasJack;

	vector<Conversation*> Conversations;
	
	virtual void FromJsonObject(const Json::Value& Object);// override;
};

//class Item : public NeuroConfigObj
//{
//public:
//	int ID;
//	string Name;
//	string Type;
//
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class NewsItem : public NeuroConfigObj
//{
//public:
//	int Date;
//	string Title;
//	string Message;
//	string Condition;
//
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class Message : public NeuroConfigObj
//{
//public:
//	int Date;
//	string To;
//	string From;
//	string Message;
//	string Condition;
//
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class MailActions : public NeuroConfigObj
//{
//public:
//	map<string, string> Actions;
//	
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//
//class MenuEntry : public NeuroConfigObj
//{
//public:
//	string Name;
//	string Dest;
//	string Condition;
//	char Key;
//	
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class ListEntry : public NeuroConfigObj
//{
//public:
//	vector<string> Fields;
//	string Details;
//	
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class SitePage : public NeuroConfigObj
//{
//public:
//	vector<MenuEntry*> MenuEntries;
//	vector<ListEntry*> ListEntries;
//	vector<string> ListColumns;
//	string Type;
//	string MessagesID;
//	string StringID;
//	string ExitDest;
//	string Header;
//	
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};
//
//class Site : public NeuroConfigObj
//{
//public:
//	vector<string> Passwords;
//	string Title;
//	map<string, SitePage*> Pages;
//	int ComlinkLevel;
//	
//	virtual void FromJsonObject(const Json::Value& Object) override;
//};

class NeuroConfig : public NeuroConfigObj
{
public:
	vector<string> RoomNames;
	vector<string> SiteNames;
//	vector<Room*> Rooms;
//	vector<NewsItem*> NewsItems;
//
//	map<int, Item*> Items;
//	map<string, Site*> Sites;
//	map<string, MailActions*> MailServer;
	map<string, string> Strings;

//	map<string, vector<Message*>> AllMessages;

	NeuroConfig();
//	void Initialize();

	virtual void FromLua(Lua& L, LuaRef Object) override;
	
//	virtual void FromJsonObject(const Json::Value& Object);// override;	
};
