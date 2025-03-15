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

class Room : public NeuroConfigObj
{
public:
	std::string ID;
	std::string BackgroundImage;
	bool bHasPAX;
	bool bHasJack;

};
