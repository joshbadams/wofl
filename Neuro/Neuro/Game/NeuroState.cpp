//
//  NeuroState.cpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include "NeuroState.h"

NeuroState::NeuroState(NeuroConfig* InConfig, IStateChangedDelegate* InStateDelegate)
	: CurrentRoom(nullptr)
	, CurrentConversation(nullptr)
	, Money(6)
	, Config(InConfig)
	, StateDelegate(InStateDelegate)
{
	if (LoadFromFile(Utils::File->GetSavePath("game.sav").c_str()) == false)
	{
		Money = 6;
		Inventory.push_back(0);
		Inventory.push_back(1);
		
		IntValues["bankaccount"] = 1941;
		Variables["name"] = "Badams";
		Variables["bamaid"] = "056306118";
	}

	PendingRoom = Config->Rooms[0];
	CurrentState = State::EnteredRoom;
}

Json::Value NeuroState::ToJsonObject()
{
	Json::Value SettingsObj(Json::objectValue);
	for (auto Pair : IntValues)
	{
		SettingsObj[Pair.first] = Json::Value(Pair.second);
	}
	for (auto Pair : Variables)
	{
		SettingsObj[Pair.first] = Json::Value(Pair.second);
	}

	Json::Value StateObj(Json::objectValue);
	StateObj["settings"] = SettingsObj;
	StateObj["money"] = Json::Value(Money);
	AddIntArrayToObject(Inventory, StateObj, "inventory");
	AddIntArrayToObject(UnlockedNewsItems, StateObj, "unlockednews");

	return StateObj;

}

void NeuroState::FromJsonObject(const Json::Value& Object)
{
	Json::Value SettingsObject = Object["settings"];
	for (auto Name : SettingsObject.getMemberNames())
	{
		if (SettingsObject[Name].isInt())
		{
			IntValues[Name] = SettingsObject[Name].asInt();
		}
		else
		{
			Variables[Name] = SettingsObject[Name].asString();
		}
	}
	Money = Object["money"].asInt();
	GetIntArrayFromObject(Inventory, Object, "inventory");
	GetIntArrayFromObject(UnlockedNewsItems, Object, "unlockednews");
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
			// options have an implied continue
			if (CurrentConversation->Continue != "")
			{
				UpdateVariablesFromString(CurrentConversation->Continue);
				CurrentState = State::ActivateConversation;
			}
			else
			{
				CurrentState = State::Idle;
			}
			CurrentConversation = nullptr;
			DialogIndex = -1;
			ChoiceIndex = -1;
			PendingInvalidation |= ZoneType::Dialog;
			PendingInvalidation |= ZoneType::Message;

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

void NeuroState::ClickPAX()
{
	if (CurrentState == State::Idle)
	{
		int CurrentData = 111758;
		for (int Index = 0; Index < (int)Config->NewsItems.size(); Index++)
		{
			NewsItem* Item = Config->NewsItems[Index];
			if (CurrentData >= Item->Date)
			{
				if (std::find(UnlockedNewsItems.begin(), UnlockedNewsItems.end(), Index) == UnlockedNewsItems.end())
				{
					if (TestCondition(Item->Condition, true))
					{
						UnlockedNewsItems.push_back(Index);
					}
				}
			}
		}
		
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
	
	if (Action == InvAction::Give)
	{
		char ValueStr[20];

		if (Index == 0)
		{
			snprintf(ValueStr, 20, "$%d", Modifier);

			Money -= Modifier;
		}
		else
		{
			snprintf(ValueStr, 20, "id_%d", Inventory[Index]);

			// todo: check if someone wants it
			Inventory.erase(Inventory.begin() + Index);
		}

		Variables["receive"] = ValueStr;

		// now find if someone cares
		Conversation* Convo = FindConversationForAction("receive", ValueStr);
		if (Convo != nullptr)
		{
			ActivateConversation(Convo);
		}
	}
	else if (Action == InvAction::Use)
	{
		
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

void NeuroState::SetIntVariable(string Name, int Value)
{
	if (Name == "money")
	{
		Money = Value;
	}
	else
	{
		SetIntValue(Name, Value);
	}
}

bool NeuroState::TestCondition(const string& Condition, bool bEmptyConditionIsSuccess, const string* Action, const string* Value)
{
	// no condition uses bEmptyConditionIsSuccess
	if (Condition == "")
	{
		return bEmptyConditionIsSuccess;
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
		
		return (Op == '<' && A < B) || (Op == '>' && A > B) || (Op == '=' && A == B);
	}
	
	// string comparison
	string A = (Value != nullptr) ? *Value : GetStringVariable(FirstHalf);
	return A == SecondHalf;
}

Conversation* NeuroState::FindConversationWithTag(const char* Tag)
{
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
		if (TestCondition(Convo->Action, false, &Action, &Value))
		{
			return Convo;
		}
	}
	return nullptr;
}

int NeuroState::GetIntValue(const string& Key)
{
	if (IntValues.contains(Key))
	{
		return IntValues[Key];
	}
	
	return -1;
}

void NeuroState::SetIntValue(const string& Key, int Value)
{
	IntValues[Key] = Value;
}

void NeuroState::IncrementIntValue(const string& Key)
{
	SetIntValue(Key, GetIntValue(Key) + 1);
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
		
		SetIntValue(Variable, std::stoi(Value));
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
