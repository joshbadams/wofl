//
//  NeuroState.hpp
//  Neuro
//
//  Created by Josh Adams on 4/16/23.
//

#include <string>
#include <vector>
#include <map>
using namespace std;

#include "NeuroConfig.h"

enum class ZoneType : int
{
	None 		= 0,
	Message		= 1,
	Dialog		= 2,
	Computer	= 4,
	Room		= 8,
	All			= 0xFF,
};

enum class State : int
{
	Idle,
	
	EnteredRoom,
	LeavingRoom,
	
	ActivateConversation,
	EndedConversation,
	
	InDialog,
	InOptions,
	InMessage,
};

template<typename E>
struct enable_bitmask_operators{
	static constexpr bool enable=false;
};

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator|(E lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  return static_cast<E>(static_cast<underlying>(lhs) | static_cast<underlying>(rhs));
}

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator|=(E& lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  lhs = static_cast<E>(static_cast<underlying>(lhs) | static_cast<underlying>(rhs));
  return lhs;
}

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator&(E lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  return static_cast<E>(static_cast<underlying>(lhs) & static_cast<underlying>(rhs));
}

template<>
struct enable_bitmask_operators<ZoneType>{ static constexpr bool enable=true; };

class IStateDelegate
{
public:
	virtual void Invalidate(ZoneType Zone) = 0;
};

class IInterfaceDelegate
{
public:
	virtual void MessageComplete() = 0;
//	virtual void DialogChosen() = 0;
};

class NeuroState
{
public:
	Room* CurrentRoom;

	map<string, int> IntValues;
	int Money;
	vector<int> Inventory;
		
	NeuroState(NeuroConfig* InConfig, IStateDelegate* InStateDelegate);
	virtual ~NeuroState() { }
	
	void Tick();
	
	void HandleSceneClick();
	void MessageComplete();

	// returns -1 if not existant
	int GetIntValue(const char* Key)
	{
		return GetIntValue(string(Key));
	}
	int GetIntValue(const string&  Key);
	void SetIntValue(const string& Key, int Value);
	void IncrementIntValue(const string& Key);
	
	string GetCurrentDialogLine();
	string GetCurrentMessage();

	

private:

	void ActivateRoom(Room* OldRoom, Room* NewRoom);
	void ActivateConversation(Conversation* Convo);

	Conversation* FindConversationWithTag(const char* Tag);
	Conversation* FindActiveConversation();

	void UpdateVariablesFromString(const string& Command);
	bool CheckVariablesFromString(const string& Query);

	
	NeuroConfig* Config;
	IStateDelegate* StateDelegate;
	
	Conversation* CurrentConversation;
	int DialogIndex;
	int ChoiceIndex;
	
	
	State CurrentState;
	Room* PendingRoom;
	
	ZoneType PendingInvalidation;
};

