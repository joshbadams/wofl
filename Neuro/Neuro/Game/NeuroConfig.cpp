//
//  Config.cpp
//  Neuro
//
//  Created by Josh Adams on 4/15/23.
//

#include "NeuroGame.h"
#include "NeuroLua.h"

void NeuroConfigObj::FromLua(class Lua& L, LuaRef Object)
{
	
}

Conversation::~Conversation()
{
}

void Conversation::FromLua(class Lua& L, LuaRef Object)
{
	*this = {};
	
	// we don't need Tag since we've already found it in Lua, but just for completeness
	L.GetStringValue(Object, "tag", Tag);
//	L.GetStringValue(Object, "message", Message);
	L.GetFunctionValue(Object, "onStart", Lua_OnStart);
	L.GetFunctionValue(Object, "onEnd", Lua_OnEnd);

	// get the lines
	L.GetStringValues(Object, "lines", Lines);

	// get option objects
	std::vector<LuaRef> OptionRefs;
	L.GetTableValues(Object, "options", OptionRefs);
	for (LuaRef OptionRef : OptionRefs)
	{
		Option* O = new Option();
		Options.push_back(O);
		
		O->FromLua(L, OptionRef);
	}
}

void Option::FromLua(Lua& L, LuaRef Object)
{
	*this = {};

	L.GetStringValue(Object, "line", Line);
	L.GetStringValue(Object, "response", Response);
	L.GetFunctionValue(Object, "onEnd", Lua_OnEnd);
}
