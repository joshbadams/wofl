//
//  Lua.cpp
//  Neuro
//
//  Created by Josh Adams on 2/17/24.
//

#include "NeuroLua.h"
#include "NeuroState.h"

struct LuaScope
{
	LuaScope(lua_State* Lua)
	{
		L = Lua;
		StackDepth = lua_gettop(L);
	}
	~LuaScope()
	{
		if (lua_gettop(L) > StackDepth)
		{
			lua_pop(L, lua_gettop(L) - StackDepth);
		}
	}

	lua_State* L;
	int StackDepth;
};

#define SCOPE LuaScope Scope(L);


Lua::Lua(void* Context)
{
	L = luaL_newstate();
	luaL_openlibs(L);

	SCOPE;
	
	lua_pushglobaltable(L);
	int Table = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, Table) != 0)
	{
		SystemVariables.push_back(lua_tostring(L, -2));
		// move to next
		lua_pop(L, 1);
	}
	
	lua_pushlightuserdata(L, Context);
	lua_setglobal(L, "this");
	
	luaL_dofile(L, Utils::File->GetResourcePath("Neuro.lua").c_str());
	
//	int IntVal;
//	string StringVal;
//	GetIntValue("foo", IntVal);
//	GetStringValue("bar", StringVal);
//	
//	WLOG("IntVal = %d, StringVal = %s\n", IntVal, StringVal.c_str());
//	
//	SetIntValue("foo", 2);
//	SetStringValue("bar", "newvalue");
//	
//	GetIntValue("foo", IntVal);
//	GetStringValue("baz", StringVal);
//	WLOG("IntVal = %d, StringVal = %s\n", IntVal, StringVal.c_str());
//	
//	ToJsonObject();
}

Lua::~Lua()
{
	lua_close(L);
}

// IJsonObj
Json::Value Lua::ToJsonObject()
{
	SCOPE;
	
	Json::Value LuaObject(Json::objectValue);
	
	lua_getglobal(L, "settings");
	int Table = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, Table) != 0)
	{
		const char* Key = lua_tostring(L, -2);
		if (lua_isinteger(L, -1))
		{
			LuaObject[Key] = Json::Value(lua_tointeger(L, -1));
		}
		else if (lua_isstring(L, -1))
		{
			LuaObject[Key] = Json::Value(lua_tostring(L, -1));
		}
		else
		{
			assert(0);
		}

		// move to next
		lua_pop(L, 1);
	}
	
	return LuaObject;
}

void Lua::FromJsonObject(const Json::Value& LuaObject)
{
	for (auto Name : LuaObject.getMemberNames())
	{
		if (LuaObject[Name].isInt())
		{
			SetIntValue(Name, LuaObject[Name].asInt());
		}
		else if (LuaObject[Name].isString())
		{
			SetStringValue(Name, LuaObject[Name].asString());
		}
	}

	//	Json::Value UnlockedMessageObject = Object["unlockedmessages"];
	//	for (auto Name : UnlockedMessageObject.getMemberNames())
	//	{
	//		GetIntArrayFromObject(UnlockedMessages[Name], UnlockedMessageObject[Name], "unlockedmessages");
	//	}

}

void Lua::RegisterFunction(const char* Name, lua_CFunction Func)
{
	lua_register(L, Name, Func);
}

void Lua::SetGlobal(const char* GlobalName, int Value)
{
	SCOPE;
	
	lua_pushinteger(L, Value);
	lua_setglobal(L, GlobalName);
}

void Lua::SetGlobal(const char* GlobalName, const char* Value)
{
	SCOPE;
	
	lua_pushstring(L, Value);
	lua_setglobal(L, GlobalName);
}

bool Lua::GetString(const string& Code, string& Result)
{
	SCOPE;
	
	SetGlobal("result", nullptr);
	if (!RunCode(Code))
	{
		return false;
	}

	lua_getglobal(L, "result");
	// allow no return, treated as empty string
	if (lua_isnil(L, -1))
	{
		Result = false;
		return true;
	}

	if (!lua_isstring(L, -1))
	{
		Result = "LUA ERROR";
		return false;
	}
	
	Result = lua_tostring(L, -1);
	
	return true;
}

bool Lua::GetBool(const string& Code, bool& Result)
{
	SCOPE;
	
	SetGlobal("result", nullptr);
	if (!RunCode(Code))
	{
		return false;
	}
	
	lua_getglobal(L, "result");
	// allow no return, treated as false
	if (lua_isnil(L, -1))
	{
		Result = false;
		return true;
	}
	if (!lua_isboolean(L, -1))
	{
		return false;
	}
	
	Result = lua_toboolean(L, -1);
	
	return true;
}

bool Lua::RunCode(const string& Code)
{
	SCOPE;
	
	if (!luaL_dostring(L, Code.c_str()) == LUA_OK)
	{
		WLOG("Error: %s\n", lua_tostring(L, -1));
		return false;
	}
	
	return true;
}

bool Lua::GetIntValue(const string& Name, int& Result) const
{
	SCOPE;
	
	lua_getglobal(L, Name.c_str());
	if (!lua_isinteger(L, -1))
	{
		return false;
	}
	Result = (int)lua_tointeger(L, -1);
	return true;
}

void Lua::SetIntValue(const string& Name, int Value) const
{
	SCOPE;

	lua_pushinteger(L, Value);
	lua_setglobal(L, Name.c_str());
}

bool Lua::GetStringValue(const string& Name, string& Result) const
{
	SCOPE;
	
	lua_getglobal(L, "settings");
	lua_pushlstring(L, Name.c_str(), (int)Name.length());
	lua_gettable(L, -2);
	if (!lua_isstring(L, -1))
	{
		return false;
	}
	Result = lua_tostring(L, -1);
	return true;
}

void Lua::SetStringValue(const string& Name, const string& Value) const
{
	SCOPE;
	
	lua_getglobal(L, "settings");
	lua_pushlstring(L, Name.c_str(), (int)Name.length());
	lua_pushlstring(L, Value.c_str(), (int)Value.length());
	lua_settable(L, -3);
}
