//
//  NeuroState.cpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include "NeuroState.h"
#include "Gridbox.h"

NeuroState::NeuroState(IStateChangedDelegate* InStateDelegate)
	: StateDelegate(InStateDelegate)
	, Lua(this)
{
	// this would be better done in NeuroGame, but oh well
	Utils::File->SetMainResourceSubdir(WoflGame::TheGame->GetGameName().c_str());

	InitLua();
	
	// loaded values here will override init values in tha
	if (!LoadFromFile(Utils::File->GetSavePath("game1.sav").c_str()))
	{
		// if we don't load from a save, then we need to trigger the EnteredRoom function in the first room -
		// when loading from a save, we have already entered the room, so we don't want to trigger conversations, etc
		// this does mean that room state can't assume EnteredRoom will set up when loading from a save!!
		CurrentState = State::EnteredRoom;
	}
	
	CurrentInfoType = InfoType::Date;
	PendingInvalidation |= ZoneType::Info;
}

void NeuroState::InitLua()
{
	Lua.RegisterFunction("OpenBox", Lua_OpenBox);
	Lua.RegisterFunction("CloseBox", Lua_CloseBox);
	Lua.RegisterFunction("ShowMessage", Lua_ShowMessage);
	Lua.RegisterFunction("StartTimer", Lua_StartTimer);
	Lua.RegisterFunction("StopTimer", Lua_StopTimer);
	Lua.RegisterFunction("SaveGame", Lua_SaveGame);
	Lua.RegisterFunction("LoadGame", Lua_LoadGame);
	Lua.RegisterFunction("PauseGame", Lua_PauseGame);
	Lua.RegisterFunction("QuitGame", Lua_QuitGame);
	Lua.RegisterFunction("GoToRoom", Lua_GoToRoom);
	Lua.RegisterFunction("UpdateInfo", Lua_UpdateInfo);
	Lua.RegisterFunction("UpdateDialog", Lua_UpdateDialog);
	Lua.RegisterFunction("ReorderBox", Lua_ReorderBox);
	Lua.RegisterFunction("UpdateBoxes", Lua_UpdateBoxes);
	Lua.RegisterFunction("AddAnimation", Lua_AddAnimation);
	Lua.RegisterFunction("RemoveAnimation", Lua_RemoveAnimation);

	std::vector<string> GameScripts;
	Lua.GetStringValues("", "GameScripts", GameScripts);

	for (string& R : GameScripts)
	{
		Lua.LoadScript((R + ".lua").c_str());
	}

	// default to initial room (LoadFromFile will set PendingRoom if loaded)
	string InitialRoom;
	Lua.GetStringValue("c", "initialRoom", InitialRoom);
	Lua.GetTableValue("", InitialRoom.c_str(), PendingRoom);
	
	Lua.GetFloatValue("c", "secondsPerMinute", SecondsPerMinute);
	TimeTimer = SecondsPerMinute;

	
	
//	LuaRef IRS;
//	Lua.GetTableValue("", "IRS", IRS);
//	
//	std::string Page;
////	Lua.CallFunction_NoParam_Return(IRS, "GetCurrentPage", Page);
//	Lua.GetStringValue(IRS, "currentPage", Page);
//
//	WLOG("Page: %s\n", Page.c_str());
//
//	Lua.CallFunction_OneParam_NoReturn(IRS, "HandleInput", "1");
//
//	Lua.GetStringValue(IRS, "currentPage", Page);
//	WLOG("Page: %s\n", Page.c_str());
//
//	int Obj;
//	Lua.GetObject("Room", Obj);
//	std::string Str;
//	Lua.GetStringValue("Room", "shortDesc", Str);
	
//	int Stack = Lua.MarkStack();
//	LuaRef RRef;
//	Lua.GetTableValue("", "chatsubo", RRef);
//
//	std::string foobar;
//	Lua.GetStringValue("chatsubo", "foobar", foobar);
//	foobar = "";
//	Lua.GetStringValue(RRef, "foobar", foobar);
//	foobar = "";
//
//	delete RRef;
//	LuaRef TestFunc;
//	Lua.GetFunctionValue("", "Test", TestFunc);
//	Lua.CallFunction_NoParam_Return("", TestFunc, RRef);
//	Lua.GetStringValue(RRef, "foobar", foobar);
//	foobar = "";
//	Lua.GetStringValue(RRef, "bar", foobar);
//	foobar = "";
//
//	LuaRef CRef;
//	
//	Lua.CallFunction_OneParam_Return("Chatsubo", "GetNextConversation", "longdescription", CRef);
//	if (CRef)
//	{
//		Lua.GetStringValue(CRef, "foobar", foobar);
//		Lua.GetStringValue(CRef, "tag", foobar);
//		Lua.GetStringValue(RRef, "foobar", foobar);
//		Lua.GetStringValue(RRef, "tag", foobar);
//
//		Lua.CallFunction_NoParam_NoReturn(CRef, "onEnd");
//
//		Conversation C;
//		C.FromLuaDeleteRef(Lua, CRef);
//		
//		WLOG("Before: %d\n", GetIntValue("chatsubo"));
//		if (C.Lua_OnEnd)
//		{
//			Lua.CallFunction_NoParam_NoReturn("Chatsubo", C.Lua_OnEnd);
//		}
//		//		Lua.CallFunction_ReturnsOnStack("Room", C.Lua_OnStart);
//		WLOG("After: %d\n", GetIntValue("chatsubo"));
//		WLOG("Line: %s\n", C.Message.c_str());
//	}
////	Lua.RestoreStack(Stack);
}

Json::Value NeuroState::ToJsonObject()
{
	Json::Value StateObj(Json::objectValue);
	StateObj["lua"] = Lua.ToJsonObject();
	
	// remebmer which room we are in
	string RoomName;
	Lua.GetStringValue(CurrentRoom, "name", RoomName);
	StateObj["room"] = RoomName;
	
//	StateObj["money"] = Json::Value(Money);
//	AddIntArrayToObject(Inventory, StateObj, "inventory");

//	AddIntArrayToObject(UnlockedNewsItems, StateObj, "unlockednews");

//	for (auto& Pair : UnlockedMessages)
//	{
//		AddIntArrayToObject(Pair.second, SettingsObj["unlockedmessages"][Pair.first], "unlockedmessages");
//	}
	
	return StateObj;

}

void NeuroState::FromJsonObject(const Json::Value& Object)
{
//	Json::Value UnlockedMessageObject = Object["unlockedmessages"];
//	for (auto Name : UnlockedMessageObject.getMemberNames())
//	{
//		GetIntArrayFromObject(UnlockedMessages[Name], UnlockedMessageObject[Name], "unlockedmessages");
//	}

//	Money = Object["money"].asInt();
//	GetIntArrayFromObject(Inventory, Object, "inventory");
	Lua.FromJsonObject(Object["lua"]);
	
	// set next room to saved room
	Lua.GetTableValue("", Object["room"].asString().c_str(), CurrentRoom);
	Lua.SetTableValue("", "currentRoom", CurrentRoom);

	CurrentState = State::Idle;
	PendingInvalidation |= ZoneType::Room;
}

void NeuroState::Tick(float DeltaTime)
{
	switch (CurrentState)
	{
		case State::EnteredRoom:
			CurrentState = State::Idle;
			ActivateRoom(CurrentRoom, PendingRoom);
			break;
			
		case State::LeavingRoom:
			break;
					
		case State::Idle:
		default:
			break;
	}

	if (PendingMessage != "")
	{
		StateDelegate->Invalidate(ZoneType::Message);
		PendingMessage = "";
	}

	if (PendingInvalidation != ZoneType::None)
	{
		StateDelegate->Invalidate(PendingInvalidation);
		PendingInvalidation = ZoneType::None;
	}

	vector<unsigned int> TimersToRemove;
	for (auto& Pair : Timers)
	{
		Pair.second.Time -= DeltaTime;
		if (Pair.second.Time <= 0)
		{
			Lua.CallFunction_NoReturn(Pair.second.Object, Pair.second.Callback);
			StateDelegate->RefreshUI();
			
			TimersToRemove.push_back(Pair.first);
		}
	}
	for (unsigned int Id : TimersToRemove)
	{
		Timers.erase(Id);
	}

	TimeTimer -= DeltaTime;
	while (TimeTimer <= 0)
	{
		Lua.CallFunction_NoReturn("", "IncrementTime");
		TimeTimer += SecondsPerMinute;
	}
}


void NeuroState::ReloadLua()
{
	SaveToFile(Utils::File->GetSavePath("tempgame").c_str());
	
	StateDelegate->ResetLua();
	
	Timers.clear();
	CurrentRoom = nullptr;
	PendingRoom = nullptr;
	Lua_OnMessageComplete = nullptr;
	Lua.Reset();
	InitLua();
	
	LoadFromFile(Utils::File->GetSavePath("tempgame").c_str());
}

void NeuroState::ClickInventory()
{
	// @todo can also open when in site
//	if (!StateDelegate->IsConversationShowing() && !StateDelegate->AreBoxesShowing() && !StateDelegate->IsMessageActive())
	if (StateDelegate->IsConversationShowing())
	{
		StateDelegate->OpenBoxByName("InvBox_Convo");
	}
	else if (StateDelegate->AreBoxesShowing())
	{
		StateDelegate->OpenBoxByName("InvBox_Site");
	}
	else
	{
		StateDelegate->OpenBoxByName("InvBox");
	}
}

void NeuroState::ClickPAX()
{
	if (!StateDelegate->IsConversationShowing() && !StateDelegate->AreBoxesShowing() && !StateDelegate->IsMessageActive())
	{
//		CheckMessagesForActivation(this, Config->NewsItems, UnlockedMessages["news"]);
//		CheckMessagesForActivation(this, Config->AllMessages["news"], UnlockedMessages["board"]);
	
		bool bHasPax;
		Lua.GetBoolValue(CurrentRoom, "hasPax", bHasPax);
		if (bHasPax)
		{
			StateDelegate->OpenBoxByName("PAX");
			CurrentState = State::InSite;
		}
	}
}

void NeuroState::ClickTalk()
{
	if (CurrentState == State::Idle)
	{
		Lua.CallFunction_NoReturn(CurrentRoom, "ActivateConversation");
//		PendingConversation = FindActiveConversation();
	}
}

void NeuroState::ClickSkill()
{
	StateDelegate->OpenBoxByName("SkillBox");
}

void NeuroState::ClickChip()
{
	if (!StateDelegate->IsConversationShowing() && !StateDelegate->AreBoxesShowing() && !StateDelegate->IsMessageActive())
	{
		CurrentState = State::InSite;
		std::string LastSite;
		Lua.GetStringValue("s", "lastSite", LastSite);
		StateDelegate->OpenBoxByName(LastSite.c_str());
	}
}

void NeuroState::ClickSystem()
{
	StateDelegate->OpenBoxByName("SystemBox");

//	SaveToFile(Utils::File->GetSavePath("game.sav").c_str());
}

void NeuroState::ClickDate()
{
	CurrentInfoType = InfoType::Date;
	PendingInvalidation |= ZoneType::Info;

}

void NeuroState::ClickTime()
{	
	CurrentInfoType = InfoType::Time;
	PendingInvalidation |= ZoneType::Info;
}

void NeuroState::ClickMoney()
{
	CurrentInfoType = InfoType::Money;
	PendingInvalidation |= ZoneType::Info;
}

void NeuroState::ClickHealth()
{
	CurrentInfoType = InfoType::Health;
	PendingInvalidation |= ZoneType::Info;
}


void NeuroState::ActivateRoom(LuaRef OldRoom, LuaRef NewRoom)
{
	CurrentRoom = NewRoom;
		
	PendingInvalidation |= ZoneType::Room;

//	string FirstVisitKey = string("__") + CurrentRoom->ID;
//	bool bFirstEnter = GetIntValue(FirstVisitKey.c_str()) != 1;
//	SetIntValue(FirstVisitKey, 1);
	
	if (OldRoom)
	{
		Lua.CallFunction_NoReturn(OldRoom, "OnExitRoom");
	}
	Lua.CallFunction_NoReturn(NewRoom, "OnEnterRoom");
}

bool NeuroState::GetCurrentDialogLine(std::string& Line, int& Speaker, bool& bIsThought, bool& bHasTextEntry)
{
	LuaRef Dialog;
	Lua.CallFunction_Return(CurrentRoom, "GetDialog", Dialog);
	
	if (Dialog == nullptr)
	{
		CurrentState = State::Idle;
		return false;
	}
	CurrentState = State::InDialog;
	
	Lua.GetStringValue(Dialog, "text", Line);
	Lua.GetIntValue(Dialog, "speaker", Speaker);
	Lua.GetBoolValue(Dialog, "thought", bIsThought);
	Lua.GetBoolValue(Dialog, "hasTextEntry", bHasTextEntry);
	return true;
}

std::string NeuroState::GetCurrentMessage(bool& bNeedsPauseAtEnd)
{
	bNeedsPauseAtEnd = bPendingMessageNeedsPauseAtEnd;
	return PendingMessage;
//	if (CurrentConversation == nullptr)
//	{
//		return "";
//	}
//	
//	if (CurrentConversation->Message.starts_with("lua:"))
//	{
//		std::string Result;
//		Lua.GetString(CurrentConversation->Message.substr(4), Result);
//		return Result;
//	}
//	
//	return CurrentConversation->Message;
}

std::string NeuroState::GetCurrentInfoText()
{
	string Info;
	switch (CurrentInfoType)
	{
		case InfoType::Date:
			Lua.CallFunction_Return("string", "fromTodaysDate", Info);
			break;
		case InfoType::Time:
			Lua.CallFunction_Return("string", "fromTime", Info);
			break;
		case InfoType::Money:
			Lua.GetStringValue("s", "money", Info);
			Info = string("$") + Info;
			break;
		case InfoType::Health:
			Lua.GetStringValue("s", "hp", Info);
			break;
	}
	return Info;
}

bool NeuroState::HandleSceneKey(KeyEvent Event)
{
	bool bWasHandled = false;
	if (Event.Type == KeyType::Down)
	{
		const char* Direction = nullptr;
		if (Event.KeyCode == WoflKeys::UpArrow)
		{
			Direction = "north";
		}
		else if (Event.KeyCode == WoflKeys::DownArrow)
		{
			Direction = "south";
		}
		else if (Event.KeyCode == WoflKeys::LeftArrow)
		{
			Direction = "west";
		}
		else if (Event.KeyCode == WoflKeys::RightArrow)
		{
			Direction = "east";
		}

		if (Direction != nullptr)
		{
			LuaRef NewRoom;
			Lua.CallFunction_Return(CurrentRoom, "GetConnectingRoom", Direction, NewRoom);
			if (NewRoom != nullptr)
			{
				ActivateRoom(CurrentRoom, NewRoom);
			}
			bWasHandled = true;
		}
	}
	
	return bWasHandled;
}

void NeuroState::HandleSceneClick(ZoneType Zone)
{
	if (CurrentState == State::InDialog || CurrentState == State::InOptions)
	{
		// param is true if clicked outside the message buggle
		bool bIsOutsideOfBox = Zone != ZoneType::Dialog;
		Lua.CallFunction_NoReturn(CurrentRoom, "HandleDialogClick", bIsOutsideOfBox);
	}
}

void NeuroState::MessageComplete()
{
	if (Lua_OnMessageComplete != nullptr)
	{
		Lua.CallFunction_NoReturn(CurrentRoom, Lua_OnMessageComplete);
		Lua_OnMessageComplete = nullptr;
	}

	PendingMessage = "";
}


void NeuroState::GridboxClosed(LuaRef Box)
{
	// this returns true when all boxes are closed and we can go idle
	if (StateDelegate->CloseBoxWithObj(Box))
	{
		if (CurrentState == State::InSite || CurrentState == State::InInventory)
		{
			CurrentState = State::Idle;
		}
	}
}

int NeuroState::GetIntValue(const std::string& Key) const
{
	int Value;
	if (Lua.GetIntValue("s", Key.c_str(), Value))
	{
		return Value;
	}
	return -1;
}

std::string NeuroState::GetStringValue(const std::string& Key) const
{
	std::string Value;
	if (Lua.GetStringValue("s", Key.c_str(), Value))
	{
		return Value;
	}
	return "";
}

LuaRef NeuroState::GetTableValue(const std::string& Key) const
{
	LuaRef Value;
	if (Lua.GetTableValue("s", Key.c_str(), Value))
	{
		return Value;
	}
	return nullptr;
}


void NeuroState::SetIntValue(const std::string& Name, int Value)
{
	Lua.SetIntValue("s", Name.c_str(), Value);
}

void NeuroState::SetStringValue(const std::string& Name, const std::string& Value)
{
	Lua.SetStringValue("s", Name.c_str(), Value);
}


void NeuroState::IncrementIntValue(const std::string& Key)
{
	SetIntValue(Key, GetIntValue(Key) + 1);
}

unsigned int NeuroState::AddTimer(const Timer& Timer)
{
	unsigned int Id = NextId++;
	Timers[Id] = Timer;
	return Id;
}

static NeuroState* State(lua_State* L)
{
	lua_getglobal(L, "__neurostate");
	NeuroState* State = (NeuroState*)lua_touserdata(L, -1);
	lua_pop(L, 1);
	
	return State;

}

int NeuroState::Lua_CloseBox(lua_State* L)
{
	NeuroState* NS = State(L);

	// this will get the box off the stack
	LuaRef Box = NS->Lua.MakeRef();
	
	NS->GridboxClosed(Box);

	return 0;
}

int NeuroState::Lua_OpenBox(lua_State* L)
{
	NeuroState* NS = State(L);

	// stack has the box name to open
	LuaRef Box = NS->StateDelegate->OpenBoxByName(lua_tostring(L, -1));

	if (Box == nullptr)
	{
		lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_REFNIL);
	}
	else
	{
		// put the luraref on the stack
		lua_rawgeti(L, LUA_REGISTRYINDEX, Box->Ref);
	}
	return 1;
}

int NeuroState::Lua_ShowMessage(lua_State* L)
{
	NeuroState* S = State(L);
	int StackPos = lua_gettop(L);
	S->bPendingMessageNeedsPauseAtEnd = false;
	if (lua_isboolean(L, StackPos))
	{
		S->bPendingMessageNeedsPauseAtEnd = lua_toboolean(L, StackPos);
		StackPos--;
	}
	if (lua_isfunction(L, StackPos) || lua_isnil(L, StackPos))
	{
		// put it on top for MakeRef() (very annoying)
		lua_pushvalue(L, StackPos);
		LuaRef OnCompleteFunc = S->Lua.MakeRef();
		
		if (!S->bPendingMessageNeedsPauseAtEnd)
		{
			if (OnCompleteFunc)
			{
				S->Lua.CallFunction_NoReturn(S->CurrentRoom, OnCompleteFunc);
			}
		}
		else
		{
			S->Lua_OnMessageComplete = OnCompleteFunc;
		}
		
		// move down one to get std::string
		StackPos--;
	}
	if (!lua_isstring(L, StackPos))
	{
		return 0;
	}

	S->PendingMessage = lua_tostring(L, StackPos);	
	if (S->PendingMessage == "")
	{
		S->Lua.CallFunction_NoReturn(S->CurrentRoom, "OnMessageComplete");
	}
//	S->CurrentState = State::ShowMessage;
	
	return 0;
}

int NeuroState::Lua_StartTimer(lua_State *L)
{
	NeuroState* S = State(L);	
	
	// put it on top for MakeRef()
	int StackPos = lua_gettop(L);
	lua_pushvalue(L, StackPos);
	LuaRef Func = S->Lua.MakeRef();

	lua_pushvalue(L, StackPos - 1);
	LuaRef Obj = S->Lua.MakeRef();

	assert(lua_isinteger(L, -3));
	float Time = lua_tonumber(L, -3);

	int Id = S->AddTimer({Time, Obj, Func});
	
	// @todo push the timer id
	lua_pushinteger(L, Id);
	return 1;
}

int NeuroState::Lua_StopTimer(lua_State *L)
{
	NeuroState* S = State(L);
	
	assert(lua_isinteger(L, -1));
	long long Id = lua_tointeger(L, -1);
	if (Id >= 0)
	{
		S->Timers.erase((unsigned int)Id);
	}
	
	return 1;
}

int NeuroState::Lua_SaveGame(lua_State* L)
{
	NeuroState* S = State(L);
	int Index = (int)lua_tointeger(L, -1);
	S->SaveToFile(Utils::File->GetSavePath((std::string("game") + (char)('0' + Index) + ".sav").c_str()).c_str());

	return 0;
}

int NeuroState::Lua_LoadGame(lua_State* L)
{
	NeuroState* S = State(L);
	int Index = (int)lua_tointeger(L, -1);
	S->LoadFromFile(Utils::File->GetSavePath((std::string("game") + (char)('0' + Index) + ".sav").c_str()).c_str());
	return 0;
}

int NeuroState::Lua_PauseGame(lua_State* L)
{
	return 0;
}

int NeuroState::Lua_QuitGame(lua_State* L)
{
	return 0;
}

int NeuroState::Lua_GoToRoom(lua_State* L)
{
	string RoomName = lua_tostring(L, -1);
	
	NeuroState* S = State(L);
	S->Lua.GetTableValue("", RoomName.c_str(), S->PendingRoom);
	S->CurrentState = State::EnteredRoom;
	
	return 0;
}

int NeuroState::Lua_UpdateInfo(lua_State* L)
{
	NeuroState* S = State(L);
	S->PendingInvalidation |= ZoneType::Info;
	return 0;
}

int NeuroState::Lua_UpdateDialog(lua_State* L)
{
	NeuroState* S = State(L);
	S->PendingInvalidation |= ZoneType::Dialog;
	return 0;
}

int NeuroState::Lua_UpdateBoxes(lua_State* L)
{
	NeuroState* S = State(L);
	S->StateDelegate->RefreshUI();

	return 0;
}

int NeuroState::Lua_ReorderBox(lua_State* L)
{
	NeuroState* S = State(L);
	
	// push first param on top for MakeRef
	lua_pushvalue(L, -2);
	LuaRef BoxRef = S->Lua.MakeRef();
	int Mode = (int)lua_tointeger(L, -1);
	
	S->StateDelegate->ReorderBoxWithObj(BoxRef, Mode);
	
	return 0;
}

int NeuroState::Lua_AddAnimation(lua_State* L)
{
	NeuroState* S = State(L);

	lua_pushvalue(L, -1);
	LuaRef AnimRef = S->Lua.MakeRef();

	S->StateDelegate->AddAnimation(AnimRef);
	
	return 0;
}

int NeuroState::Lua_RemoveAnimation(lua_State* L)
{
	NeuroState* S = State(L);

	lua_pushvalue(L, -1);
	LuaRef AnimRef = S->Lua.MakeRef();

	S->StateDelegate->RemoveAnimation(AnimRef);
	
	return 0;
}


//std::vector<Message*> NeuroState::GetUnlockedMessages(std::string ID)
//{
//	// check for new unlocks
//	CheckMessagesForActivation(this, Config->AllMessages[ID], UnlockedMessages[ID]);
//
//	std::vector<Message*> Messages;
//	for (int MessageIndex : UnlockedMessages.at(ID))
//	{
//		Messages.push_back(Config->AllMessages[ID][MessageIndex]);
//	}
//	return Messages;
//}

