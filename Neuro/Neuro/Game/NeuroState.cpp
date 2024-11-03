//
//  NeuroState.cpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include "NeuroState.h"


NeuroState::NeuroState(NeuroConfig* InConfig, IStateChangedDelegate* InStateDelegate)
	: CurrentConversation(nullptr)
	, Config(InConfig)
	, StateDelegate(InStateDelegate)
	, Lua(this)
{
	Lua.RegisterFunction("Talk", Lua_Talk);
	Lua.RegisterFunction("Say", Lua_Say);
	Lua.RegisterFunction("OpenBox", Lua_OpenBox);
	Lua.RegisterFunction("CloseBox", Lua_CloseBox);
	Lua.RegisterFunction("ShowMessage", Lua_ShowMessage);
	Lua.RegisterFunction("StartTimer", Lua_StartTimer);
	Lua.RegisterFunction("SaveGame", Lua_SaveGame);
	Lua.RegisterFunction("LoadGame", Lua_LoadGame);
	Lua.RegisterFunction("PauseGame", Lua_PauseGame);
	Lua.RegisterFunction("QuitGame", Lua_QuitGame);

	Config->FromLua(Lua, Lua.GetGlobalTable());

	for (string& R : Config->RoomNames)
	{
		Lua.LoadScript((R + ".lua").c_str());
	}
	for (string& S : Config->SiteNames)
	{
		Lua.LoadScript((S + ".lua").c_str());
	}

	// loaded values here will override init values in tha
	LoadFromFile(Utils::File->GetSavePath("game1.sav").c_str());

	// get a pointer to starting room
	Lua.GetTableValue("", Config->RoomNames[0].c_str(), PendingRoom);
	
	PendingConversation = nullptr;
	CurrentState = State::EnteredRoom;
	
	
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
			
		case State::ActivateConversation:
			ActivateConversation(FindActiveConversation());
			break;

		case State::EndedConversation:
			{
				LuaRef OnEndFunction = CurrentConversation->Lua_OnEnd;
	 
				CurrentState = State::Idle;
				CurrentConversation = nullptr;
				
				DialogIndex = -1;
				ChoiceIndex = -1;
				PendingInvalidation |= ZoneType::Dialog;
				PendingInvalidation |= ZoneType::Message;

				if (OnEndFunction)
				{
					Lua.CallFunction_NoReturn(CurrentRoom, OnEndFunction);
				}
			}
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

	if (PendingConversation != nullptr)
	{
		ActivateConversation(PendingConversation);
		PendingConversation = nullptr;
		StateDelegate->Invalidate(ZoneType::Dialog);
	}

	if (PendingInvalidation != ZoneType::None)
	{
		StateDelegate->Invalidate(PendingInvalidation);
		PendingInvalidation = ZoneType::None;
	}

	vector<Timer>::iterator it = Timers.begin();
	while (it != Timers.end())
	{
		it->Time -= DeltaTime;
		if (it->Time <= 0)
		{
			Lua.CallFunction_NoReturn(it->Object, it->Callback);
			StateDelegate->RefreshUI();
			
			Timers.erase(it);
			break;
		}
		else
		{
			++it;
		}
	}
}

void NeuroState::ClickInventory()
{
	// @todo can also open when in site
	if (!StateDelegate->IsConversationShowing() && !StateDelegate->AreBoxesShowing() && !StateDelegate->IsMessageActive())
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
	
		StateDelegate->OpenBoxByName("PAX");
		CurrentState = State::InSite;
	}
}

void NeuroState::ClickTalk()
{
	if (CurrentState == State::Idle)
	{
		PendingConversation = FindActiveConversation();
	}
}

void NeuroState::ClickSkill()
{
	if (!StateDelegate->IsConversationShowing() && !StateDelegate->AreBoxesShowing() && !StateDelegate->IsMessageActive())
	{
		CurrentState = State::InSite;
		StateDelegate->OpenBoxByName("regfellow");
	}
}

void NeuroState::ClickChip()
{
//	LoadFromFile(Utils::File->GetSavePath("game.sav").c_str());
}

void NeuroState::ClickSystem()
{
	StateDelegate->OpenBoxByName("SystemBox");

//	SaveToFile(Utils::File->GetSavePath("game.sav").c_str());
}


void NeuroState::ActivateRoom(LuaRef OldRoom, LuaRef NewRoom)
{
	CurrentRoom = NewRoom;
		
	PendingInvalidation = ZoneType::Room;

//	string FirstVisitKey = string("__") + CurrentRoom->ID;
//	bool bFirstEnter = GetIntValue(FirstVisitKey.c_str()) != 1;
//	SetIntValue(FirstVisitKey, 1);
	
	if (OldRoom)
	{
		Lua.CallFunction_NoReturn(OldRoom, "OnExitRoom");
	}
	Lua.CallFunction_NoReturn(NewRoom, "OnEnterRoom");
}

void NeuroState::ActivateConversation(Conversation* Convo)
{
	CurrentConversation = Convo;
	if (Convo == nullptr)
	{
		CurrentState = State::Idle;
		return;
	}
	
	DialogIndex = -1;
	ChoiceIndex = -1;
	
	if (Convo->Lines.size() > 0)
	{
		PendingInvalidation |= ZoneType::Dialog;
		CurrentState = State::InDialog;
		DialogIndex = 0;
	}
	else if (Convo->Options.size() > 0)
	{
		PendingInvalidation |= ZoneType::Dialog;
		CurrentState = State::InOptions;
		ChoiceIndex = 0;
	}
//	else if (Convo->Message.length() > 0)
//	{
//		PendingInvalidation |= ZoneType::Message;
//		CurrentState = State::InMessage;
//	}
}

std::string NeuroState::GetCurrentDialogLine()
{
	if (CurrentConversation == nullptr || (DialogIndex == -1 && ChoiceIndex == -1))
	{
		return "";
	}
	
	if (ChoiceIndex != -1)
	{
		if (CurrentState == State::InDialog)
		{
			return CurrentConversation->Options[ChoiceIndex]->Response;
		}
		return CurrentConversation->Options[ChoiceIndex]->Line;
	}

	return CurrentConversation->Lines[DialogIndex];
}

std::string NeuroState::GetCurrentMessage()
{
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

void NeuroState::HandleSceneClick(ZoneType Zone)
{
	if (CurrentConversation != nullptr)
	{
		if (CurrentState == State::InDialog)
		{
			DialogIndex++;
			if (DialogIndex == CurrentConversation->Lines.size())
			{
				CurrentState = State::EndedConversation;
				DialogIndex = -1;
			}
			PendingInvalidation |= ZoneType::Dialog;
		}
		else if (CurrentState == State::InOptions)
		{
			if (Zone == ZoneType::Dialog)
			{
				if (CurrentConversation->Options[ChoiceIndex]->Lua_OnEnd)
				{
					Lua.CallFunction_NoReturn(CurrentRoom, CurrentConversation->Options[ChoiceIndex]->Lua_OnEnd);
				}
				if (CurrentConversation->Options[ChoiceIndex]->Response != "")
				{
					CurrentState = State::InDialog;
				}
				else
				{
					CurrentState = State::ShowPostMessage;
				}
			}
			else
			{
				ChoiceIndex++;
				if (ChoiceIndex == CurrentConversation->Options.size())
				{
					ChoiceIndex = 0;
				}
			}
			PendingInvalidation |= ZoneType::Dialog;
		}
	}
}

void NeuroState::MessageComplete()
{
	if (Lua_OnMessageComplete != nullptr)
	{
		Lua.CallFunction_NoReturn(CurrentRoom, Lua_OnMessageComplete);
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

Conversation* NeuroState::FindConversationWithTag(const char* Tag)
{
//	LUA_SCOPE;
	LuaRef ConvoRef;
	Lua.CallFunction_Return(CurrentRoom, "GetNextConversation", Tag, ConvoRef);
	if (ConvoRef)
	{
		LuaConversation.FromLua(Lua, ConvoRef);
		
		return &LuaConversation;
	}
	
//	// if nothing found in Lua, look in json
//	for (Conversation* Convo : CurrentRoom->Conversations)
//	{
//		if (Convo->Tag == Tag)
//		{
//			return Convo;
//		}
//	}
	
	return nullptr;
}

Conversation* NeuroState::FindActiveConversation()
{
	if (PendingConversation != nullptr)
	{
		Conversation* Result = PendingConversation;
		PendingConversation = nullptr;
		return Result;
	}

	LuaRef ConvoRef;
	Lua.CallFunction_Return(CurrentRoom, "GetNextConversation", ConvoRef);
	if (ConvoRef)
	{
		LuaConversation.FromLua(Lua, ConvoRef);
		return &LuaConversation;
	}

	return nullptr;
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

static NeuroState* State(lua_State* L)
{
	lua_getglobal(L, "__neurostate");
	NeuroState* State = (NeuroState*)lua_touserdata(L, -1);
	lua_pop(L, 1);
	
	return State;

}

int NeuroState::Lua_Talk(lua_State* L)
{
	NeuroState* NS = State(L);

	// optional tag as param
	if (lua_isstring(L, -1))
	{
		NS->PendingConversation = NS->FindConversationWithTag(lua_tostring(L, -1));
		assert(NS->PendingConversation != nullptr);
	}
	else
	{
		NS->PendingConversation = NS->FindActiveConversation();
	}
	
	return 0;
}

int NeuroState::Lua_Say(lua_State* L)
{
	NeuroState* NS = State(L);

	if (!lua_isstring(L, -1))
	{
		return 0;
	}

	NS->LuaConversation = {};
	NS->LuaConversation.Lines.push_back(lua_tostring(L, -1));
	NS->PendingConversation = &NS->LuaConversation;
	NS->CurrentState = State::ActivateConversation;

	return 0;
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
	NS->StateDelegate->OpenBoxByName(lua_tostring(L, -1));

	return 0;
}

int NeuroState::Lua_ShowMessage(lua_State* L)
{
	NeuroState* S = State(L);
	int StackPos = lua_gettop(L);
	if (lua_isfunction(L, StackPos))
	{
		// put it on top for MakeRef() (very annoying)
		lua_pushvalue(L, StackPos);
		S->Lua_OnMessageComplete = S->Lua.MakeRef();
		
		// move down one to get std::string
		StackPos--;
	}
	if (!lua_isstring(L, StackPos))
	{
		return 0;
	}

	//
	S->PendingMessage = lua_tostring(L, StackPos);
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
dumpstack(L);

	assert(lua_isinteger(L, -3));
	float Time = lua_tonumber(L, -3);

	S->Timers.push_back({Time, Obj, Func});
	
	// @todo push the timer id
	lua_pushinteger(L, 33);
	return 1;
}

int NeuroState::Lua_SaveGame(lua_State* L)
{
	NeuroState* S = State(L);
	int Index = lua_tointeger(L, -1);
	S->SaveToFile(Utils::File->GetSavePath((std::string("game") + (char)('0' + Index) + ".sav").c_str()).c_str());

	return 0;
}

int NeuroState::Lua_LoadGame(lua_State* L)
{
	NeuroState* S = State(L);
	int Index = lua_tointeger(L, -1);
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

