//
//  Config.hpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#pragma once

#include <Wofl/Wofl.h>
#

class NeuroConfigObj : public LoadJsonObj
{
protected:
	virtual string PostProcessString(const string& String) override;
};

class Option : public NeuroConfigObj
{
public:
	string Line;
	string Response;
	string Set;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Conversation : public NeuroConfigObj
{
public:
	string Tag;
	string Condition;
	string Action;
	string Message;
	string Set;

	vector<string> Lines;
	vector<Option*> Options;

	virtual void FromJsonObject(const Json::Value& Object) override;
};


class Room : public NeuroConfigObj
{
public:
	string ID;
	string BackgroundImage;

	vector<Conversation*> Conversations;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Item : public NeuroConfigObj
{
public:
	int ID;
	string Name;
	string Type;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class NewsItem : public NeuroConfigObj
{
public:
	int Date;
	string Title;
	string Message;
	string Condition;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Message : public NeuroConfigObj
{
public:
	int Date;
	string To;
	string From;
	string Message;
	string Condition;

	virtual void FromJsonObject(const Json::Value& Object) override;
};

class MailActions : public NeuroConfigObj
{
public:
	map<string, string> Actions;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class Site : public NeuroConfigObj
{
public:
	vector<string> Passwords;
	string Title;
//	vector<SitePage> Pages;
	
	virtual void FromJsonObject(const Json::Value& Object) override;
};

class NeuroConfig : public NeuroConfigObj
{
public:
	vector<Room*> Rooms;
	vector<NewsItem*> NewsItems;

	map<int, Item*> Items;
	map<string, Site*> Sites;
	map<string, MailActions*> MailServer;
	map<string, string> Strings;

	map<string, vector<Message*>> AllMessages;

	NeuroConfig();
	void Initialize();

	
	virtual void FromJsonObject(const Json::Value& Object) override;	
};
