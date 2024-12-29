//
//  Config.hpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#pragma once

#include <Wofl/Wofl.h>

class Lua;
using LuaRef = std::shared_ptr<class LuaObjRef>;

class NeuroConfigObj
{
public:
	virtual void FromLua(Lua& L, LuaRef Object);

protected:
};

class Option : public NeuroConfigObj
{
public:
	std::string Line;
	std::string Response;
	LuaRef Lua_OnEnd;

	virtual void FromLua(Lua& L, LuaRef Object) override;
};

class Conversation : public NeuroConfigObj
{
public:
	~Conversation();
	
	std::string Tag;
	std::string Condition;
	std::string Action;
	
	LuaRef Lua_OnStart;
	LuaRef Lua_OnEnd;

	std::vector<std::string> Lines;
	std::vector<Option*> Options;

	virtual void FromLua(Lua& L, LuaRef Object) override;
};



class Room : public NeuroConfigObj
{
public:
	std::string ID;
	std::string BackgroundImage;
	bool bHasPAX;
	bool bHasJack;

	std::vector<Conversation*> Conversations;
};
