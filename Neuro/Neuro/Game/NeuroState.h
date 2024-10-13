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

	ShowMessage,
	EndedMessage,
	
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

ENABLE_ENUM_OPS(ZoneType)

class IStateChangedDelegate
{
public:
	virtual void Invalidate(ZoneType Zone) = 0;
	virtual void CloseBoxWithObj(LuaRef BoxObj) = 0;
};

class IInterfaceChangingStateDelegate
{
public:
	virtual void MessageComplete() = 0;
	//	virtual void DialogChosen() = 0;
		
	virtual void GridboxClosed(LuaRef Box) = 0;
	virtual void SetIntValue(const std::string& Name, int Value) = 0;
	virtual bool ConnectToSite(const std::string& Recipient, int ComLinkLevel) = 0;
};

class ITextboxDelegate : public IInterfaceChangingStateDelegate
{
public:
	virtual void SetIntValue(const std::string& Name, int Value) override  { assert(0); }
	virtual void GridboxClosed(LuaRef Box) override  { assert(0); }
	virtual bool ConnectToSite(const std::string& SiteName, int ComLinkLevel) override { assert(0); return false; }
};

class IQueryStateDelegate
{
public:
	virtual int GetIntValue(const std::string& Name) const = 0;
	virtual std::string GetStringValue(const std::string& Name) const = 0;
	virtual LuaRef GetTableValue(const std::string& Name) const = 0;

};

class NeuroState : public IJsonObj, public IInterfaceChangingStateDelegate, public IQueryStateDelegate
{
public:
	LuaRef CurrentRoom;
		
	NeuroState(NeuroConfig* InConfig, IStateChangedDelegate* InStateDelegate);
	virtual ~NeuroState() { }
	
	// IJsonObj
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;
	
	
	// IInterfaceChangingStateDelegate
	virtual void MessageComplete() override;
	virtual void GridboxClosed(LuaRef Box) override;
	virtual bool ConnectToSite(const std::string& SiteName, int ComLinkLevel) override;

	
	
	void Tick();
	
	void HandleSceneClick(ZoneType Zone);


	// returns -1 if not existant
	int GetIntValue(const char* Key) const
	{
		return GetIntValue(std::string(Key));
	}
	virtual int GetIntValue(const std::string&  Key) const override;
	virtual void SetIntValue(const std::string& Key, int Value) override;
	void IncrementIntValue(const std::string& Key);
	virtual std::string GetStringValue(const std::string&  Key) const override;
	void SetStringValue(const std::string& Key, const std::string& Value);
	virtual LuaRef GetTableValue(const std::string& Key) const override;

	void Trigger(const std::string& Type, const std::string& Value);
		
	void StringReplacement(std::string& String, char Delimiter) const;
	
	std::string GetCurrentDialogLine();
	std::string GetCurrentMessage();

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

	bool TestCondition(const std::string& Condition, bool bEmptyConditionIsSuccess, const std::string* Action=nullptr, const std::string* Value=nullptr);

private:
	
	static int Lua_Trigger(lua_State* L);
	static int Lua_Talk(lua_State* L);
	static int Lua_Say(lua_State* L);
	static int Lua_ShowMessage(lua_State* L);
	static int Lua_CloseBox(lua_State* L);

	void ActivateRoom(LuaRef OldRoom, LuaRef NewRoom);
	void ActivateConversation(Conversation* Convo);
	
	Conversation* FindConversationWithTag(const char* Tag);
	Conversation* FindActiveConversation();
	Conversation* FindConversationForAction(const std::string& Action, const std::string& Value);

	map<std::string, std::vector<int>> UnlockedMessages;

	NeuroConfig* Config;
	IStateChangedDelegate* StateDelegate;
	
	Conversation LuaConversation;
	Conversation* CurrentConversation;
	int DialogIndex;
	int ChoiceIndex;
	
	
	State CurrentState;

	LuaRef PendingRoom;
	LuaRef Lua_OnMessageComplete;

	Conversation* PendingConversation;
	std::string PendingMessage;

	ZoneType PendingInvalidation;
	
	Lua Lua;
	
};

