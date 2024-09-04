//
//  NeuroState.cpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include "NeuroState.h"



NeuroState::NeuroState(NeuroConfig* InConfig, IStateChangedDelegate* InStateDelegate)
	: CurrentRoom(nullptr)
	, Lua_CurrentRoom(nullptr)
	, CurrentConversation(nullptr)
	, Money(6)
	, Config(InConfig)
	, StateDelegate(InStateDelegate)
	, Lua(this)
{
	Lua.RegisterFunction("Trigger", Lua_Trigger);

	if (LoadFromFile(Utils::File->GetSavePath("game.sav").c_str()) == false)
	{
		Money = 6;
		Inventory.push_back(0);
		Inventory.push_back(1);
		
		SetIntValue("bankaccount", 1941);
		SetStringValue("name", "Badams");
		SetStringValue("bamaid", "056306118");
	}
	
	Config->Initialize();

	PendingConversation = nullptr;
	PendingRoom = Config->Rooms[0];
	CurrentState = State::EnteredRoom;
	
	
//	int Obj;
//	Lua.GetObject("Room", Obj);
//	string Str;
//	Lua.GetStringValue("Room", "shortDesc", Str);
	
//	int Stack = Lua.MarkStack();
//	LuaRef* RRef;
//	Lua.GetTableValue("", "chatsubo", RRef);
//
//	string foobar;
//	Lua.GetStringValue("chatsubo", "foobar", foobar);
//	foobar = "";
//	Lua.GetStringValue(RRef, "foobar", foobar);
//	foobar = "";
//
//	delete RRef;
//	LuaRef* TestFunc;
//	Lua.GetFunctionValue("", "Test", TestFunc);
//	Lua.CallFunction_NoParam_Return("", TestFunc, RRef);
//	Lua.GetStringValue(RRef, "foobar", foobar);
//	foobar = "";
//	Lua.GetStringValue(RRef, "bar", foobar);
//	foobar = "";
//
//	LuaRef* CRef;
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
	StateObj["money"] = Json::Value(Money);
	AddIntArrayToObject(Inventory, StateObj, "inventory");
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

	Money = Object["money"].asInt();
	GetIntArrayFromObject(Inventory, Object, "inventory");
	Lua.FromJsonObject(Object["lua"]);
}

void NeuroState::Tick()
{
	switch (CurrentState)
	{
		case State::EnteredRoom:
			ActivateRoom(CurrentRoom, PendingRoom);
			break;
			
		case State::LeavingRoom:
			break;
			
		case State::ActivateConversation:
			ActivateConversation(FindActiveConversation());
			break;
			
		case State::ShowPostMessage:
			if (CurrentConversation->Message != "")
			{
				CurrentState = State::InMessage;
				PendingInvalidation |= ZoneType::Message;
			}
			else
			{
				CurrentState = State::EndedConversation;
			}
			break;
			
		case State::EndedConversation:
		{
			LuaRef* OnEndFunction = CurrentConversation->Lua_OnEnd;
			// set any vars, and maybe trigger another talk
			string& EndedConversationSet = CurrentConversation->Set;
			string& EndedConversationLua = CurrentConversation->LuaCode;

			CurrentState = State::Idle;
			CurrentConversation = nullptr;
			
			DialogIndex = -1;
			ChoiceIndex = -1;
			PendingInvalidation |= ZoneType::Dialog;
			PendingInvalidation |= ZoneType::Message;

			if (OnEndFunction)
			{
				Lua.CallFunction_NoParam_NoReturn(Lua_CurrentRoom, OnEndFunction);
			}
			if (EndedConversationLua != "")
			{
				Lua.RunCode(EndedConversationLua);
			}
			if (EndedConversationSet != "")
			{
				UpdateVariablesFromString(EndedConversationSet);
			}
		}
			break;
			
		case State::Idle:
		default:
			break;
	}

	if (PendingInvalidation != ZoneType::None)
	{
		StateDelegate->Invalidate(PendingInvalidation);
		PendingInvalidation = ZoneType::None;
	}
}

void NeuroState::ClickInventory()
{
	if (CurrentState == State::Idle)
	{
		CurrentState = State::InInventory;
		PendingInvalidation |= ZoneType::Inventory;
	}
}

template<typename T>
void CheckMessagesForActivation(NeuroState* State, vector<T*>& Items, vector<int>& UnlockedItems)
{
	int CurrentData = 111758;

	for (int Index = 0; Index < (int)Items.size(); Index++)
	{
		T* Item = Items[Index];
		if (CurrentData >= Item->Date)
		{
			if (std::find(UnlockedItems.begin(), UnlockedItems.end(), Index) == UnlockedItems.end())
			{
				if (State->TestCondition(Item->Condition, true))
				{
					UnlockedItems.push_back(Index);
				}
			}
		}
	}
}

void NeuroState::ClickPAX()
{
	if (CurrentState == State::Idle)
	{
		CheckMessagesForActivation(this, Config->NewsItems, UnlockedMessages["news"]);
//		CheckMessagesForActivation(this, Config->AllMessages["news"], UnlockedMessages["board"]);
		
		CurrentState = State::InPAX;
		PendingInvalidation |= ZoneType::PAX;
	}
}

void NeuroState::ClickTalk()
{
	if (CurrentState == State::Idle)
	{
		CurrentState = State::ActivateConversation;
	}
}

void NeuroState::ClickSkill()
{
	CurrentState = State::InSite;
	SetStringValue("currentsite", "irs");
	PendingInvalidation |= ZoneType::Site;
}

void NeuroState::ClickChip()
{
	LoadFromFile(Utils::File->GetSavePath("game.sav").c_str());
}

void NeuroState::ClickSystem()
{
	SaveToFile(Utils::File->GetSavePath("game.sav").c_str());
}


void NeuroState::ActivateRoom(Room* OldRoom, Room* NewRoom)
{
	CurrentRoom = NewRoom;
	
	delete Lua_CurrentRoom;
	Lua.GetTableValue("",  CurrentRoom->ID.c_str(), Lua_CurrentRoom);
	
	PendingInvalidation = ZoneType::Room;

	string FirstVisitKey = string("__") + CurrentRoom->ID;
	bool bFirstEnter = GetIntValue(FirstVisitKey.c_str()) == -1;
	SetIntValue(FirstVisitKey, 1);
	
	ActivateConversation(FindConversationWithTag(bFirstEnter ? "longdescription" : "description"));
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
	else if (Convo->Message.length() > 0)
	{
		PendingInvalidation |= ZoneType::Message;
		CurrentState = State::InMessage;
	}
}

string NeuroState::GetCurrentDialogLine()
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

string NeuroState::GetCurrentMessage()
{
	if (CurrentConversation == nullptr)
	{
		return "";
	}
	
	if (CurrentConversation->Message.starts_with("lua:"))
	{
		string Result;
		Lua.GetString(CurrentConversation->Message.substr(4), Result);
		return Result;
	}
	
	return CurrentConversation->Message;
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
				CurrentState = State::ShowPostMessage;
			}
			PendingInvalidation |= ZoneType::Dialog;
		}
		else if (CurrentState == State::InOptions)
		{
			if (Zone == ZoneType::Dialog)
			{
				UpdateVariablesFromString(CurrentConversation->Options[ChoiceIndex]->Set);
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
	assert(CurrentState == State::InMessage);

	CurrentState = State::EndedConversation;
}

//void NeuroState::CycleDialog()
//{
//	assert(CurrentState == State::InDialog);
//}
//
//void NeuroState::ChooseDialog()
//{
//	assert(CurrentState == State::InDialog);
//
//}

void NeuroState::InventoryUsed(int Index, InvAction Action, int Modifier)
{
	PendingInvalidation |= ZoneType::Inventory;
	CurrentState = State::Idle;
	
	if (Action == InvAction::Cancel)
	{
		return;
	}
	
	
	if (Action == InvAction::Give || Action == InvAction::Use)
	{
		// can only give money, not use it
		if (Index == 0)
		{
			Lua.SetGlobal("action", "give");
			Lua.SetGlobal("type", "money");
			Lua.SetGlobal("amount", Modifier);

//			snprintf(ValueStr, 20, "$%d", Modifier);

			Money -= Modifier;
		}
		else
		{
			char ValueStr[20];
			snprintf(ValueStr, 20, "id_%d", Inventory[Index]);

			if (Modifier == 0) Modifier = 1;
			
			Lua.SetGlobal("action", Action == InvAction::Give ? "give" : "use");
			Lua.SetGlobal("type", ValueStr);
			Lua.SetGlobal("amount", Modifier);

			// todo: check if someone wants it
			Inventory.erase(Inventory.begin() + Index);
		}

		for (Conversation* Convo : CurrentRoom->Conversations)
		{
			if (Convo->Action.starts_with("lua:"))
			{
				bool bActivateConversation = false;
				// check condition, then run action, and if it returns true, then activate (we don't break, just in case other actions
				// want to do something
				if (TestCondition(Convo->Condition, true) &&
					Lua.GetBool(Convo->Action.substr(4), bActivateConversation) &&
					bActivateConversation)
				{
					ActivateConversation(Convo);
				}
			}
		}
		
//		Variables["receive"] = ValueStr;

		// now find if someone cares
//		Conversation* Convo = FindConversationForAction("receive", ValueStr);
//		if (Convo != nullptr)
//		{
//			ActivateConversation(Convo);
//		}
	}
	else if (Action == InvAction::Discard)
	{
		if (Index == 0)
		{
			Money -= Modifier;
			if (Money < 0)
			{
				Money = 0;
			}
		}
		else
		{
			Inventory.erase(Inventory.begin() + Index);
		}
	}
}

void NeuroState::GridboxClosed()
{
	if (CurrentState == State::InPAX)
	{
		CurrentState = State::Idle;
		PendingInvalidation |= ZoneType::PAX;
	}
	else if (CurrentState == State::InInventory)
	{
		CurrentState = State::Idle;
		PendingInvalidation |= ZoneType::Inventory;
	}
	else if (CurrentState == State::InSite)
	{
		CurrentState = State::Idle;
		PendingInvalidation |= ZoneType::Site;
	}
}

void NeuroState::SendMessage(const string& Recipient, const string& Message)
{
	if (Config->MailServer.contains(Recipient))
	{
		MailActions* MailActions = Config->MailServer[Recipient];
		if (MailActions->Actions.contains(Message))
		{
			UpdateVariablesFromString(MailActions->Actions[Message]);
		}
	}
}

bool NeuroState::ConnectToSite(const string& SiteName, int ComLinkLevel)
{
	if (Config->Sites.contains(SiteName))
	{
		SetStringValue("currentsite", SiteName);
		CurrentState = State::InSite;
		PendingInvalidation |= ZoneType::Inventory | ZoneType::Site;
		return true;
	}
	
	return false;
}


bool NeuroState::TestCondition(const string& Condition, bool bEmptyConditionIsSuccess, const string* Action, const string* Value)
{
	// no condition uses bEmptyConditionIsSuccess
	if (Condition == "")
	{
		return bEmptyConditionIsSuccess;
	}
	
	if (Condition.starts_with("lua:"))
	{
		bool Result;
		Lua.GetBool(Condition.substr(4), Result);
		return Result;
	}
	
	size_t OpLoc = Condition.find('=');
	if (OpLoc == string::npos) OpLoc = Condition.find('<');
	if (OpLoc == string::npos) OpLoc = Condition.find('>');
	
	if (OpLoc == string::npos)
	{
		WLOG("Invalid condition: %s\n", Condition.c_str());
		return false;
	}

	string FirstHalf = Condition.substr(0, OpLoc);
	string SecondHalf = Condition.substr(OpLoc + 1);
	
	if (Action != nullptr && *Action != FirstHalf)
	{
		return false;
	}
	// if one value but not both is $, return false, and skip the $
	int FirstIndex = 0;
	if (Value != nullptr && ((*Value)[0] == '$' || SecondHalf[0] == '$'))
	{
		if ((*Value)[0] != SecondHalf[0])
		{
			return false;
		}
		FirstIndex = 1;
	}

	char Op = Condition[OpLoc];
	// dealing with integer operations?
	if (Op == '>' || Op == '<' || (SecondHalf[FirstIndex] >= '0' && SecondHalf[FirstIndex] <= '9') || SecondHalf[FirstIndex] == '$')
	{
		int A = (Value != nullptr) ? stoi(Value->substr(FirstIndex)) : GetIntValue(FirstHalf);
		int B = stoi(SecondHalf.substr(FirstIndex));
		
		bool bResult = (Op == '<' && A < B) || (Op == '>' && A > B) || (Op == '=' && A == B);
		
		if (bResult)
		{
			WLOG("Condition: %s, was met!\n", Condition.c_str());
		}
		return bResult;
	}
	
	// string comparison
	string A = (Value != nullptr) ? *Value : GetStringValue(FirstHalf);
	bool bResult = A == SecondHalf;
	if (bResult)
	{
		WLOG("Condition: %s, was met!\n", Condition.c_str());
	}
	return bResult;
}

Conversation* NeuroState::FindConversationWithTag(const char* Tag)
{
//	LUA_SCOPE;
	LuaRef* ConvoRef;
	Lua.CallFunction_OneParam_Return(Lua_CurrentRoom, "GetNextConversation", Tag, ConvoRef);
	if (ConvoRef)
	{
		LuaConversation.FromLua(Lua, ConvoRef);
		delete ConvoRef;
		
		return &LuaConversation;
	}
	
	// if nothing found in Lua, look in json
	for (Conversation* Convo : CurrentRoom->Conversations)
	{
		if (Convo->Tag == Tag)
		{
			return Convo;
		}
	}
	
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

	LuaRef* ConvoRef;
	Lua.CallFunction_NoParam_Return(Lua_CurrentRoom, "GetNextConversation", ConvoRef);
	if (ConvoRef)
	{
		LuaConversation.FromLua(Lua, ConvoRef);
		return &LuaConversation;
	}

	for (Conversation* Convo : CurrentRoom->Conversations)
	{
		if (TestCondition(Convo->Condition, false))
		{
			return Convo;
		}
	}
	return nullptr;
}


Conversation* NeuroState::FindConversationForAction(const string& Action, const string& Value)
{
	for (Conversation* Convo : CurrentRoom->Conversations)
	{
		// empty condition is success when doing actions
		if (TestCondition(Convo->Condition, true) && TestCondition(Convo->Action, false, &Action, &Value))
		{
			return Convo;
		}
	}
	return nullptr;
}

int NeuroState::GetIntValue(const string& Key) const
{
	if (Key == "money")
	{
		return Money;
	}
	int Value;
	if (Lua.GetIntValue("", Key.c_str(), Value))
	{
		return Value;
	}
	return -1;
}

string NeuroState::GetStringValue(const string& Key) const
{
	string Value;
	if (Lua.GetStringValue("", Key.c_str(), Value))
	{
		return Value;
	}
	return "";
}

void NeuroState::SetIntValue(const string& Name, int Value)
{
	if (Name == "money")
	{
		Money = Value;
	}
	else
	{
		Lua.SetIntValue(nullptr, Name.c_str(), Value);
	}
}

void NeuroState::SetStringValue(const string& Name, const string& Value)
{
	Lua.SetStringValue(nullptr, Name.c_str(), Value);
}


void NeuroState::Trigger(const string& Type, const string& Value)
{
	if (Type == "talk")
	{
		if (Value == "")
		{
			PendingConversation = FindActiveConversation();
		}
		else
		{
			PendingConversation = FindConversationWithTag(Value.c_str());
		}
		if (PendingConversation != nullptr)
		{
			CurrentState = State::ActivateConversation;
		}
	}
}

void NeuroState::IncrementIntValue(const string& Key)
{
	SetIntValue(Key, GetIntValue(Key) + 1);
}

static NeuroState* State(lua_State* L)
{
	lua_getglobal(L, "this");
	NeuroState* State = (NeuroState*)lua_touserdata(L, -1);
	lua_pop(L, 1);
	
	return State;

}

//int NeuroState::Lua_GetIntValue(lua_State* L)
//{
//	if (!lua_isstring(L, 1))
//	{
//		return 0;
//	}
//	
//	const char* Key = lua_tostring(L, 1);
//	int Value = State(L)->GetIntValue(Key);
//	lua_pushinteger(L, Value);
//
//	// return number of results
//	return 1;
//}
//
//int NeuroState::Lua_SetIntValue(lua_State* L)
//{
//	if (!lua_isstring(L, 1) || !lua_isinteger(L, 2))
//	{
//		return 0;
//	}
//	
//	const char* Key = lua_tostring(L, 1);
//	int Value = (int)lua_tointeger(L, 2);
//
//	State(L)->SetIntValue(Key, Value);
//	
//	// return number of results
//	return 0;
//}
//

int NeuroState::Lua_Trigger(lua_State* L)
{
	if (!lua_isstring(L, -1) || !lua_isstring(L, -2))
	{
		return 0;
	}

	// Lua: Trigger(type, value)
	const char* Type = lua_tostring(L, -2);
	const char* Value = lua_tostring(L, -1);
	
	State(L)->Trigger(Type, Value);

	return 0;
}

void NeuroState::UpdateVariablesFromString(const string& Commands)
{
	istringstream Stream(Commands);
	
	string Command;
	while (getline(Stream, Command, '|'))
	{
		istringstream InnerStream(Command);
		string Variable, Value;
		getline(InnerStream, Variable, '=');
		getline(InnerStream, Value, '=');
		
		StringReplacement(Variable, '@');
		StringReplacement(Value, '@');
	
		WLOG("Setting variable from string: %s = %s\n", Variable.c_str(), Value.c_str());

		if (Variable.starts_with('_'))
		{
			if (Variable == "_deposit")
			{
				int CurrentBank = GetIntValue("bankaccount");
				int Change = stoi(Value);
				CurrentBank += Change;
				if (CurrentBank < 0)
				{
					CurrentBank = 0;
				}
				SetIntValue("bankaccount", CurrentBank);
			}
			else if (Variable == "_inventory")
			{
				if (Value[0] == '$')
				{
					Money += stoi(Value.substr(1));
				}
			}
			else if (Variable == "_trigger")
			{
				if (Value == "talk")
				{
					CurrentState = State::ActivateConversation;
				}
			}
		}
		else
		{
			SetIntValue(Variable, std::stoi(Value));
		}
	}
}

void NeuroState::StringReplacement(string& String, char Delimiter) const
{
	size_t FirstPercent = String.find(Delimiter);
	while (FirstPercent != string::npos)
	{
		size_t SecondPercent = String.find(Delimiter, FirstPercent + 1);
		if (SecondPercent == string::npos)
		{
			return;
		}
		
		string Variable = String.substr(FirstPercent + 1, SecondPercent - FirstPercent - 1);
		
		// replcae %foo% with GetVar(foo)
		string NewValue;
		if (Lua.GetStringValue("", Variable.c_str(), NewValue))
		{
			String.replace(FirstPercent, SecondPercent - FirstPercent + 1, NewValue);
		}
		else
		{
			FirstPercent = SecondPercent + 1;
		}
		
		FirstPercent = String.find(Delimiter, FirstPercent);
	}
}


bool NeuroState::CheckVariablesFromString(const string& Query)
{
	if (Query == "")
	{
		return true;
	}
	
	istringstream InnerStream(Query);
	string Variable, Value;
	getline(InnerStream, Variable, '=');
	getline(InnerStream, Value, '=');
		
	return (GetIntValue(Variable) == std::stoi(Value));
}



vector<Message*> NeuroState::GetUnlockedMessages(string ID)
{
	// check for new unlocks
	CheckMessagesForActivation(this, Config->AllMessages[ID], UnlockedMessages[ID]);

	vector<Message*> Messages;
	for (int MessageIndex : UnlockedMessages.at(ID))
	{
		Messages.push_back(Config->AllMessages[ID][MessageIndex]);
	}
	return Messages;
}

