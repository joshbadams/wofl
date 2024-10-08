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
class LuaRef;

class NeuroConfigObj : public LoadJsonObj
{
public:
	virtual void FromLua(Lua& L, LuaRef* Object);
	virtual void FromLuaDeleteRef(Lua& L, LuaRef*& Object);

protected:
	virtual std::string PostProcessString(const std::string& String) override;
};

class Option : public NeuroConfigObj
{
public:
	StringOrString Line;
	StringOrString Response;
	class LuaRef* Lua_OnEnd = nullptr;

	virtual void FromJsonObject(const Json::Value& Object) override;
	virtual void FromLua(Lua& L, LuaRef* Object) override;
};

class Conversation : public NeuroConfigObj
{
public:
	~Conversation();
	
	std::string Tag;
	StringOrBool Condition;
	StringOrBool Action;
	
	class LuaRef* Lua_OnStart = nullptr;
	class LuaRef* Lua_OnEnd = nullptr;

	std::vector<std::string> Lines;
	std::vector<Option*> Options;

	virtual void FromJsonObject(const Json::Value& Object) override;
	virtual void FromLua(Lua& L, LuaRef* Object) override;
};



class Room : public NeuroConfigObj
{
public:
	std::string ID;
	std::string BackgroundImage;
	bool bHasPAX;
	bool bHasJack;

	std::vector<Conversation*> Conversations;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Item : public NeuroConfigObj
{
public:
	int ID;
	std::string Name;
	std::string Type;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class NewsItem : public NeuroConfigObj
{
public:
	int Date;
	std::string Title;
	std::string Message;
	std::string Condition;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Message : public NeuroConfigObj
{
public:
	int Date;
	std::string To;
	std::string From;
	std::string Message;
	std::string Condition;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class MailActions : public NeuroConfigObj
{
public:
	std::map<std::string, std::string> Actions;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};


class MenuEntry : public NeuroConfigObj
{
public:
	std::string Name;
	std::string Dest;
	std::string Condition;
	char Key;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class ListEntry : public NeuroConfigObj
{
public:
	std::vector<std::string> Fields;
	std::string Details;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class SitePage : public NeuroConfigObj
{
public:
	std::vector<MenuEntry*> MenuEntries;
	std::vector<ListEntry*> ListEntries;
	std::vector<std::string> ListColumns;
	std::string Type;
	std::string MessagesID;
	std::string StringID;
	std::string ExitDest;
	std::string Header;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Site : public NeuroConfigObj
{
public:
	std::vector<std::string> Passwords;
	std::string Title;
	std::map<std::string, SitePage*> Pages;
	int ComlinkLevel;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class NeuroConfig : public NeuroConfigObj
{
public:
	std::vector<Room*> Rooms;
	std::vector<NewsItem*> NewsItems;

	std::map<int, Item*> Items;
	std::map<std::string, Site*> Sites;
	std::map<std::string, MailActions*> MailServer;
	std::map<std::string, std::string> Strings;

	std::map<std::string, std::vector<Message*>> AllMessages;

	NeuroConfig();
	void Initialize();

	
	virtual void FromJsonObject(const Json::Value& Object) override;	
};
