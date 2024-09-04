//
//  NeuroState.hpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#pragma once

#include <string>
#include <vector>
#include <map>
using namespace std;

#include "NeuroConfig.h"
#include "NeuroLua.h"

enum class ZoneType : int
{
	None 		= 0,
	Message		= 1,
	Dialog		= 2,
	Computer	= 4,
	Room		= 8,
	Inventory	= 16,
	PAX			= 32,
	Site		= 64,
};



enum class State : int
{
	Idle,
	
	EnteredRoom,
	LeavingRoom,
	
	ActivateConversation,
	ShowPostMessage,
	EndedConversation,
	
	InDialog,
	InOptions,
	InMessage,
	
	InInventory,
	InPAX,
	InSkill,
	InChip,
	InSystem,
	InSite,
};

enum class InvAction : int
{
	Cancel,
	Use,
	Give,
	Discard,
};

ENABLE_ENUM_OPS(ZoneType)

class IStateChangedDelegate
{
public:
	virtual void Invalidate(ZoneType Zone) = 0;
};

class IInterfaceChangingStateDelegate
{
public:
	virtual void MessageComplete() = 0;
	//	virtual void DialogChosen() = 0;
		
	virtual void InventoryUsed(int ID, InvAction Action, int Modifer) = 0;
	virtual void GridboxClosed() = 0;
	virtual void SetIntValue(const string& Name, int Value) = 0;
	virtual void SendMessage(const string& Recipient, const string& Message) = 0;
	virtual bool ConnectToSite(const string& Recipient, int ComLinkLevel) = 0;
};

class ITextboxDelegate : public IInterfaceChangingStateDelegate
{
public:
	virtual void InventoryUsed(int ID, InvAction Action, int Modifer) override { assert(0); }
	virtual void SetIntValue(const string& Name, int Value) override  { assert(0); }
	virtual void GridboxClosed() override  { assert(0); }
	virtual void SendMessage(const string& Recipient, const string& Message) override  { assert(0); }
	virtual bool ConnectToSite(const string& SiteName, int ComLinkLevel) override  {assert(0); }
};

class IQueryStateDelegate
{
public:
	virtual const vector<int>& GetInventory() const = 0;
	virtual int GetMoney() const = 0;
	virtual int GetIntValue(const string& Name) const = 0;
	virtual string GetStringValue(const string& Name) const = 0;
	virtual const vector<int>& GetUnlockedNewsItems() const = 0;
	virtual vector<Message*> GetUnlockedMessages(string ID) = 0;

};

class NeuroState : public IJsonObj, public IInterfaceChangingStateDelegate, public IQueryStateDelegate
{
public:
	Room* CurrentRoom;
	LuaRef* Lua_CurrentRoom;
	
//	map<string, int> IntValues;
//	map<string, string> Variables;
	
	NeuroState(NeuroConfig* InConfig, IStateChangedDelegate* InStateDelegate);
	virtual ~NeuroState() { }
	
	// IJsonObj
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;
	
	
	// IInterfaceChangingStateDelegate
	virtual void MessageComplete() override;
	virtual void InventoryUsed(int ID, InvAction Action, int Modifer) override;
	virtual void GridboxClosed() override;
	virtual void SendMessage(const string& Recipient, const string& Message) override;
	virtual bool ConnectToSite(const string& SiteName, int ComLinkLevel) override;

	
	// IQueryStateDelegate
	virtual const vector<int>& GetInventory() const override
	{
		return Inventory;
	}
	virtual int GetMoney() const override
	{
		return Money;
	}
	virtual const vector<int>& GetUnlockedNewsItems() const override
	{
		return UnlockedMessages.at("news");
	}
	virtual vector<Message*> GetUnlockedMessages(string ID) override;


	
	
	void Tick();
	
	void HandleSceneClick(ZoneType Zone);


	// returns -1 if not existant
	int GetIntValue(const char* Key) const
	{
		return GetIntValue(string(Key));
	}
	virtual int GetIntValue(const string&  Key) const override;
	virtual void SetIntValue(const string& Key, int Value) override;
	void IncrementIntValue(const string& Key);
	virtual string GetStringValue(const string&  Key) const override;
	void SetStringValue(const string& Key, const string& Value);

	void Trigger(const string& Type, const string& Value);
		
	void StringReplacement(string& String, char Delimiter) const;
	
	string GetCurrentDialogLine();
	string GetCurrentMessage();

	void ClickInventory();
	void ClickPAX();
	void ClickTalk();
	void ClickSkill();
	void ClickChip();
	void ClickSystem();

	bool IsShowingInventory() { return CurrentState == State::InInventory; }
	bool IsShowingPAX() { return CurrentState == State::InPAX; }
	bool IsShowingSkill() { return CurrentState == State::InSkill; }
	bool IsShowingChip() { return CurrentState == State::InChip; }
	bool IsShowingSystem() { return CurrentState == State::InSystem; }
	bool IsShowingSite() { return CurrentState == State::InSite; }

	bool TestCondition(const string& Condition, bool bEmptyConditionIsSuccess, const string* Action=nullptr, const string* Value=nullptr);

private:
	
	static int Lua_Trigger(lua_State* L);

	void ActivateRoom(Room* OldRoom, Room* NewRoom);
	void ActivateConversation(Conversation* Convo);
	
	Conversation* FindConversationWithTag(const char* Tag);
	Conversation* FindActiveConversation();
	Conversation* FindConversationForAction(const string& Action, const string& Value);

	void UpdateVariablesFromString(const string& Command);
	bool CheckVariablesFromString(const string& Query);

	const Item* GetItemForID(int ID);

	int Money;
	vector<int> Inventory;
	map<string, vector<int>> UnlockedMessages;

	NeuroConfig* Config;
	IStateChangedDelegate* StateDelegate;
	
	Conversation LuaConversation;
	Conversation* CurrentConversation;
	int DialogIndex;
	int ChoiceIndex;
	
	
	State CurrentState;
	Room* PendingRoom;
	Conversation* PendingConversation;

	ZoneType PendingInvalidation;
	
	Lua Lua;
};

