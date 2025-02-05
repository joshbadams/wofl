//
//  Lua.cpp
//  Neuro
//
//  Created by Josh Adams on 2/17/24.
//

#include "NeuroLua.h"
#include "NeuroState.h"

void dumpstack (lua_State *L) {
  int top=lua_gettop(L);
  printf("Stack:");
  for (int i=1; i <= top; i++) {
	printf("  %d\t%s\t", i, luaL_typename(L,i));
	switch (lua_type(L, i)) {
	  case LUA_TNUMBER:
		printf("  %g\n",lua_tonumber(L,i));
		break;
	  case LUA_TSTRING:
		printf("  %s\n",lua_tostring(L,i));
		break;
	  case LUA_TBOOLEAN:
		printf("  %s\n", (lua_toboolean(L, i) ? "true" : "false"));
		break;
	  case LUA_TNIL:
		printf("  %s\n", "nil");
		break;
	  default:
		printf("  %p\n",lua_topointer(L,i));
		break;
	}
  }
}


LuaScope::LuaScope(lua_State* Lua)
{
	L = Lua;
	StackDepth = lua_gettop(L);
}

LuaScope::LuaScope(Lua* Lua)
	: LuaScope(Lua->L)
{
}

LuaScope::~LuaScope()
{
	if (lua_gettop(L) > StackDepth)
	{
		lua_pop(L, lua_gettop(L) - StackDepth);
	}
}


//LuaRef::LuaRef(lua_State* LuaObj, int RefIndex)
//	: L(LuaObj)
//	, Ref(RefIndex)
//{
//}

LuaObjRef::LuaObjRef(Lua* LuaSys, int RefIndex)
	: LuaSystem(LuaSys)
	, L(LuaSys->L)
	, Ref(RefIndex)
{
		
}

LuaObjRef::~LuaObjRef()
{
	luaL_unref(L, LUA_REGISTRYINDEX, Ref);
}

bool operator==(const LuaRef& A, const LuaRef& B)
{
	bool bResult;
	A->LuaSystem->CallFunction_Return("", "TablesMatch", A, B, bResult);
	return bResult;
}


Lua::Lua(void* Context)
{
	L = luaL_newstate();
	luaL_openlibs(L);

	SCOPE;
	
	lua_pushlightuserdata(L, Context);
	lua_setglobal(L, "__neurostate");

	lua_pushlightuserdata(L, this);
	lua_setglobal(L, "__lua");

	// load the main file
	LoadScript("Neuro.lua");
	
	GetTableValue("", "s", Settings);

//	int IntVal;
//	std::string StringVal;
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

// table must be on top of stack
void WalkOverTable(lua_State* L, const std::function<void()>& VisitFunction)
{
	lua_pushnil(L);  // first key
	while (lua_next(L, -2) != 0)
	{
		VisitFunction();
		
		lua_pop(L, 1);
	}
}

static Json::Value LuaToJson(lua_State* L)
{
	// check to see the index types (all int = array, all strings = map, mixed = error)
//	bool bIsArrayType = true;
//	WalkOverTable(L, [&bIsArrayType, L]() { if (!lua_isinteger(L, -2)) { bIsArrayType = false; } });

	// make an object or an array
//	Json::Value JsonObject(bIsArrayType ? Json::arrayValue : Json::objectValue);
	Json::Value JsonObject(Json::arrayValue);

	// itrate over all entries in the table
	
	int Table = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, Table) != 0)
	{
		Json::Value Pair(Json::objectValue);
		if (lua_isinteger(L, -2))
		{
			Pair["key"] = Json::Value(lua_tointeger(L, -2));
		}
		else
		{
			Pair["key"] = Json::Value(lua_tostring(L, -2));
		}
		
		Json::Value SubValue;
		if (lua_isinteger(L, -1))
		{
			Pair["value"] = Json::Value(lua_tointeger(L, -1));
		}
		else if (lua_isstring(L, -1))
		{
			Pair["value"] = Json::Value(lua_tostring(L, -1));
		}
		else if (lua_istable(L, -1))
		{
			// recurse down for the object/array
			Pair["value"] = LuaToJson(L);
		}
		
		JsonObject.append(Pair);
		
		// move to next
		lua_pop(L, 1);
	}
	
	return JsonObject;
}

// IJsonObj
Json::Value Lua::ToJsonObject()
{
	SCOPE;
	
	// prime with state object
	PushSpec(L, "s");
	return LuaToJson(L);
}

int JsonToLua(Lua& Lua, lua_State* L, const Json::Value& JsonObject)
{
	// create a table and put on stack
	lua_newtable(L);
	int TableStackLoc = lua_gettop(L);
	
	for (int Index = 0; Index < JsonObject.size(); Index++)
	{
		Json::Value Key = JsonObject[Index]["key"];
		Json::Value Value = JsonObject[Index]["value"];
		if (Key.isString())
		{
			if (Value.isInt())
			{
				WLOG("Looading int value %s = %d\n", Key.asString().c_str(), Value.asInt());
				Lua.SetIntValue(TableStackLoc, Key.asString().c_str(), Value.asInt());
			}
			else if (Value.isString())
			{
				WLOG("Looading string value %s = %s\n", Key.asString().c_str(), Value.asString().c_str());
				Lua.SetStringValue(TableStackLoc, Key.asString().c_str(), Value.asString().c_str());
			}
			else if (Value.isArray() || Value.isObject())
			{
				WLOG("Looading array/object value %s:\n", Key.asString().c_str());
				SCOPE;
				int SubTableStackLoc = JsonToLua(Lua, L, Value);
				Lua.SetTableValue(TableStackLoc, Key.asString().c_str(), SubTableStackLoc);
			}
		}
		else
		{
			if (Value.isInt())
			{
				WLOG("Looading int value %d = %d\n", Key.asInt(), Value.asInt());
				Lua.SetIntValue(TableStackLoc, Key.asInt(), Value.asInt());
			}
			else if (Value.isString())
			{
				WLOG("Looading string value %d = %s\n", Key.asInt(), Value.asString().c_str());
				Lua.SetStringValue(TableStackLoc, Key.asInt(), Value.asString().c_str());
			}
			else if (Value.isArray() || Value.isObject())
			{
				WLOG("Looading array/object value %d:\n", Key.asInt());
				SCOPE;
				int SubTableStackLoc = JsonToLua(Lua, L, Value);
				Lua.SetTableValue(TableStackLoc, Key.asString().c_str(), SubTableStackLoc);
			}
		}
	}
	
	return TableStackLoc;
}

void Lua::FromJsonObject(const Json::Value& LuaObject)
{
	// cfreate table and get it's stack location (it _should_ be on top of stack)
	JsonToLua(*this, L, LuaObject);
	LuaRef Game = MakeRef();
	CallFunction_NoReturn("s", "ApplyLoadedGame", Game);
	}

void Lua::RegisterFunction(const char* Name, lua_CFunction Func)
{
	lua_register(L, Name, Func);
}

void Lua::LoadScript(const char* ScriptName)
{
	string FilePath = "Lua/";
	FilePath += ScriptName;
	bool bError = luaL_dofile(L, Utils::File->GetResourcePath(FilePath.c_str()).c_str());
	if (bError)
	{
		std::string Err = lua_tostring(L, -1);
		WLOG("error loading lua file: %s\n", lua_tostring(L, -1));
	}
	assert(!bError);
}

LuaRef Lua::MakeRef() const
{
	int Ref = luaL_ref(L, LUA_REGISTRYINDEX);
	if (Ref == LUA_REFNIL)
	{
		return nullptr;
	}
	return make_shared<LuaObjRef>(const_cast<Lua*>(this), Ref);
}

LuaRef Lua::GetGlobalTable() const
{
	SCOPE;
	
	lua_pushglobaltable(L);
	return make_shared<LuaObjRef>(const_cast<Lua*>(this), luaL_ref(L, LUA_REGISTRYINDEX));
}


int Lua::MarkStack()
{
	return lua_gettop(L);
}

void Lua::RestoreStack(int StackDepth)
{
	if (lua_gettop(L) > StackDepth)
	{
		lua_pop(L, lua_gettop(L) - StackDepth);
	}
}

bool Lua::TopIsNil()
{
	dumpstack(L);
	return lua_gettop(L) > 0 && lua_isnil(L, -1);
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

bool Lua::GetString(const std::string& Code, std::string& Result)
{
	SCOPE;
	
	SetGlobal("result", nullptr);
	if (!RunCode(Code))
	{
		return false;
	}

	lua_getglobal(L, "result");
	// allow no return, treated as empty std::string
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

bool Lua::GetBool(const std::string& Code, bool& Result)
{
	SCOPE;
	
//	int Top1 = lua_gettop(L);
	SetGlobal("result", nullptr);
	bool bSetsResult = Code.find("result = ") != std::string::npos || Code.find("result=") != std::string::npos;
	if (!RunCode(bSetsResult ? Code : (std::string("result = ") + Code)))
	{
		return false;
	}
//	int Top2 = lua_gettop(L);

	lua_getglobal(L, "result");
//	int Top3 = lua_gettop(L);
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

bool Lua::RunCode(const std::string& Code)
{
	SCOPE;
	
	if (!luaL_dostring(L, Code.c_str()) == LUA_OK)
	{
		WLOG("Error: %s\n", lua_tostring(L, -1));
		return false;
	}
	
	return true;
}

int PushSpec(lua_State* L, LuaRef TableRef)
{
	// just get the real table from the ref onto the stack
	lua_rawgeti(L, LUA_REGISTRYINDEX, TableRef->Ref);
	return lua_gettop(L);
}

int PushSpec(lua_State* L, int TableStackLoc)
{
	lua_pushvalue(L, TableStackLoc);
	return lua_gettop(L);
}

int PushSpec(lua_State* L, const char* TableName)
{
	// empty std::string is global
	if (TableName == nullptr || TableName[0] == 0)
	{
		lua_pushglobaltable(L);
	}
	else
	{
		lua_getglobal(L, TableName);
	}
	
	return lua_gettop(L);
}


int PushFuncSpec(lua_State* L, int TableStackLoc, const char* Func)
{
	lua_getfield(L, TableStackLoc, Func);
	return lua_gettop(L);
}

int PushFuncSpec(lua_State* L, int TableStackLoc, LuaRef Func)
{
	lua_rawgeti(L, LUA_REGISTRYINDEX, Func->Ref);
	return lua_gettop(L);
}




int PushParam(lua_State* L, LuaRef Param)
{
	lua_rawgeti(L, LUA_REGISTRYINDEX, Param->Ref);
	return lua_gettop(L);
}

int PushParam(lua_State* L, int Param)
{
	lua_pushinteger(L, Param);
	return lua_gettop(L);
}

int PushParam(lua_State* L, const char* Param)
{
	lua_pushstring(L, Param);
	return lua_gettop(L);
}

int PushParam(lua_State* L, bool Param)
{
	lua_pushboolean(L, Param);
	return lua_gettop(L);
}

bool GetReturn(lua_State* L, LuaRef& Param)
{
	if (!lua_istable(L, -1) && !lua_isfunction(L, -1))
	{
		Param = nullptr;
		return false;
	}
	
	lua_getglobal(L, "__lua");
	Lua* This = (Lua*)lua_touserdata(L, -1);
	lua_pop(L, 1);

	Param = make_shared<LuaObjRef>(This, luaL_ref(L, LUA_REGISTRYINDEX));
	return true;
}

bool GetReturn(lua_State* L, int& Param)
{
	if (!lua_isinteger(L, -1) )
	{
		Param = 0;
		return false;
	}
	
	Param = (int)lua_tointeger(L, -1);
	return true;
}

bool GetReturn(lua_State* L, std::string& Param)
{
	if (!lua_isstring(L, -1) )
	{
		Param = "";
		return false;
	}
	
	Param = lua_tostring(L, -1);
	return true;
}

bool GetReturn(lua_State* L, bool& Param)
{
	if (!lua_isboolean(L, -1) )
	{
		Param = false;
		return false;
	}
	
	Param = lua_toboolean(L, -1);
	return true;
}
