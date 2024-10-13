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
//	std::string Get();
//
//	void Set(std::string& Val)
//	{
//		Value = Val;
//	}
//private:
//	std::string Value;
//	std::string CachedLuaValue;
//};
//
//class StringOrBool
//{
//public:
//	std::string Get();
//
//	void Set(std::string& Val)
//	{
//		Value = Val;
//	}
//private:
//	std::string Value;
//	std::string CachedLuaValue;
//};
#define StringOrString std::string
#define StringOrBool std::string

class Lua;
using LuaRef = shared_ptr<class LuaObjRef>;

class NeuroConfigObj// : public LoadJsonObj
{
public:
	virtual void FromLua(Lua& L, LuaRef Object);

protected:
	virtual std::string PostProcessString(const std::string& String);
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
	
	std::string Tag;
	StringOrBool Condition;
	StringOrBool Action;
	
	LuaRef Lua_OnStart;
	LuaRef Lua_OnEnd;

	std::vector<std::string> Lines;
	std::vector<Option*> Options;

//	virtual void FromJsonObject(const Json::Value& Object) override;
	virtual void FromLua(Lua& L, LuaRef Object) override;
};



class Room : public NeuroConfigObj
{
public:
	std::string ID;
	std::string BackgroundImage;
	bool bHasPAX;
	bool bHasJack;

	std::vector<Conversation*> Conversations;
	
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
	std::vector<std::string> RoomNames;
	std::vector<std::string> SiteNames;
//	vector<Room*> Rooms;
//	vector<NewsItem*> NewsItems;
//
//	map<int, Item*> Items;
//	map<string, Site*> Sites;
//	map<string, MailActions*> MailServer;
	std::map<std::string, std::string> Strings;

	std::map<std::string, std::vector<Message*>> AllMessages;

	NeuroConfig();
//	void Initialize();

	virtual void FromLua(Lua& L, LuaRef Object) override;
	
//	virtual void FromJsonObject(const Json::Value& Object);// override;	
};
