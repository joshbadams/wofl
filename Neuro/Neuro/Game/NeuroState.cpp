//
//  NeuroState.cpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include "NeuroState.h"

NeuroState::NeuroState(NeuroConfig* InConfig, IStateDelegate* InStateDelegate)
	: CurrentRoom(nullptr)
	, CurrentConversation(nullptr)
	, Money(6)
	, Config(InConfig)
	, StateDelegate(InStateDelegate)
{
	PendingRoom = Config->Rooms[0];
	CurrentState = State::EnteredRoom;
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
			
		case State::EndedConversation:
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

			break;
			
		case State::InDialog:
			break;
			
		case State::InOptions:
			break;
			
		case State::InMessage:
			break;
			
		case State::Idle:
			break;
	}

	if (PendingInvalidation != ZoneType::None)
	{
		StateDelegate->Invalidate(PendingInvalidation);
		PendingInvalidation = ZoneType::None;
	}
}


void NeuroState::ActivateRoom(Room* OldRoom, Room* NewRoom)
{
	CurrentRoom = NewRoom;
	
	PendingInvalidation = ZoneType::All;

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

void NeuroState::HandleSceneClick()
{
	if (CurrentConversation != nullptr)
	{
		if (CurrentState == State::InDialog)
		{
			DialogIndex++;
			if (DialogIndex == CurrentConversation->Lines.size())
			{
				CurrentState = State::EndedConversation;
			}
			PendingInvalidation |= ZoneType::Dialog;
		}
		else if (CurrentState == State::InOptions)
		{
			ChoiceIndex++;
			if (ChoiceIndex == CurrentConversation->Options.size())
			{
				ChoiceIndex = 0;
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
		if (Convo->Condition.length() && CheckVariablesFromString(Convo->Condition))
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
	istringstream InnerStream(Query);
	string Variable, Value;
	getline(InnerStream, Variable, '=');
	getline(InnerStream, Value, '=');
		
	return (GetIntValue(Variable) == std::stoi(Value));
}
