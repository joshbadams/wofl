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
	Info		= 128,
};

enum class InfoType : int
{
	Date,
	Time,
	Money,
	Health,
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

ENABLE_ENUM_OPS(ZoneType)

class IStateChangedDelegate
{
public:
	virtual void Invalidate(ZoneType Zone) = 0;
	virtual void OpenBoxByName(const char* Name) = 0;
	virtual bool CloseBoxWithObj(LuaRef BoxObj) = 0;
	virtual bool AreBoxesShowing() = 0;
	virtual bool IsConversationShowing() = 0;
	virtual bool IsMessageActive() = 0;
	virtual void RefreshUI() = 0;

};

class IInterfaceChangingStateDelegate
{
public:
	virtual void MessageComplete() = 0;
	//	virtual void DialogChosen() = 0;
		
	virtual void GridboxClosed(LuaRef LuaObj) = 0;
	virtual void SetIntValue(const std::string& Name, int Value) = 0;
//	virtual void SendMessage(const std::string& Recipient, const string& Message) = 0;
};

class ITextboxDelegate : public IInterfaceChangingStateDelegate
{
public:
	virtual void SetIntValue(const std::string& Name, int Value) override  { assert(0); }
	virtual void GridboxClosed(LuaRef LuaObj) override  { assert(0); }
//	virtual void SendMessage(const std::string& Recipient, const string& Message) override  { assert(0); }
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
		
	NeuroState(IStateChangedDelegate* InStateDelegate);
	virtual ~NeuroState() { }
	
	// IJsonObj
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;
	
	
	// IInterfaceChangingStateDelegate
	virtual void MessageComplete() override;
	virtual void GridboxClosed(LuaRef Box) override;

	
	
	void Tick(float DeltaTime);
	
	void HandleSceneClick(ZoneType Zone);
	bool HandleSceneKey(KeyEvent Event);


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
			
	std::string GetCurrentDialogLine();
	std::string GetCurrentMessage();
	std::string GetCurrentInfoText();

	void ClickInventory();
	void ClickPAX();
	void ClickTalk();
	void ClickSkill();
	void ClickChip();
	void ClickSystem();
	
	void ClickDate();
	void ClickTime();
	void ClickMoney();
	void ClickHealth();

private:
	
	static int Lua_Trigger(lua_State* L);
	static int Lua_Talk(lua_State* L);
	static int Lua_Say(lua_State* L);
	static int Lua_ShowMessage(lua_State* L);
	static int Lua_OpenBox(lua_State* L);
	static int Lua_CloseBox(lua_State* L);
	static int Lua_StartTimer(lua_State* L);
	static int Lua_SaveGame(lua_State* L);
	static int Lua_LoadGame(lua_State* L);
	static int Lua_PauseGame(lua_State* L);
	static int Lua_QuitGame(lua_State* L);
	static int Lua_GoToRoom(lua_State* L);
	static int Lua_UpdateInfo(lua_State* L);

	void ActivateRoom(LuaRef OldRoom, LuaRef NewRoom);
	void ActivateConversation(Conversation* Convo);
	
	Conversation* FindConversationWithTag(const char* Tag);
	Conversation* FindActiveConversation();
	
	map<std::string, std::vector<int>> UnlockedMessages;

	IStateChangedDelegate* StateDelegate;
	
	Conversation LuaConversation;
	Conversation* CurrentConversation;
	int DialogIndex;
	int ChoiceIndex;
	
	struct Timer
	{
		float Time;
		LuaRef Object;
		LuaRef Callback;
	};
	vector<Timer> Timers;
	
	State CurrentState;

	LuaRef PendingRoom;
	LuaRef Lua_OnMessageComplete;

	Conversation* PendingConversation;
	std::string PendingMessage;

	ZoneType PendingInvalidation;
	InfoType CurrentInfoType;
	
	// how fast to increment a minute
	float SecondsPerMinute;
	float TimeTimer;

	Lua Lua;
	friend class NeuroGame;
};

