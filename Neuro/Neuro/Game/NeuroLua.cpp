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
		SystemVariables.insert(lua_tostring(L, -2));
		// move to next
		lua_pop(L, 1);
	}
	// never serialize our special communcation variable
	SystemVariables.insert("result");
	
	lua_pushlightuserdata(L, Context);
	lua_setglobal(L, "__neurostate");

	lua_pushlightuserdata(L, this);
	lua_setglobal(L, "__lua");

	// load the main file
	LoadScript("Neuro.lua");
	LoadScript("Items.lua");

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
			 
			 

// IJsonObj
Json::Value Lua::ToJsonObject()
{
	SCOPE;
	
	Json::Value LuaObject(Json::objectValue);
	
	lua_pushglobaltable(L);
	//lua_getglobal(L, "SavedValues");
	int Table = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, Table) != 0)
	{
		std::string Key = lua_tostring(L, -2);
		if (SystemVariables.find(Key) == SystemVariables.end())
		{
			if (lua_isinteger(L, -1))
			{
				LuaObject[Key] = Json::Value(lua_tointeger(L, -1));
			}
			else if (lua_isstring(L, -1))
			{
				LuaObject[Key] = Json::Value(lua_tostring(L, -1));
			}
			else //if (lua_isfunction(L, -1) || lua_islightuserdata(L, -1))
			{
			}
//			else
//			{
//				assert(0);
//			}
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
			WLOG("Looading int value %s = %d\n", Name.c_str(), LuaObject[Name].asInt());
			SetIntValue(nullptr, Name.c_str(), LuaObject[Name].asInt());
		}
		else if (LuaObject[Name].isString())
		{
			WLOG("Looading std::string value %s = %s\n", Name.c_str(), LuaObject[Name].asString().c_str());
			SetStringValue(nullptr, Name.c_str(), LuaObject[Name].asString());
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

void Lua::LoadScript(const char* ScriptName)
{
	string FilePath = "Lua/";
	FilePath += ScriptName;
	bool bError = luaL_dofile(L, Utils::File->GetResourcePath(FilePath.c_str()).c_str());
	if (bError)
	{
		WLOG("error loading lua file: %s\n", lua_tostring(L, -1));
	}
	assert(!bError);
}

LuaRef Lua::MakeRef() const
{
	return make_shared<LuaObjRef>(const_cast<Lua*>(this), luaL_ref(L, LUA_REGISTRYINDEX));
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

//
//#define CALL_FUNCTION_NO_SCOPE_PREAMBLE \
//	if (lua_getglobal(L, ObjectName) != LUA_TTABLE) { WLOG("bad table\n"); lua_pop(L, 1); return false; } \
//	if (lua_getfield(L, -1, FunctionName) != LUA_TFUNCTION) { WLOG("bad func\n"); lua_pop(L, 2); return false; } \
//	/* put the object back onto the stack for the "self" value in the function */ \
//	lua_pushvalue(L, -2);
//
//#define CALL_FUNCTIONREF_NO_SCOPE_PREAMBLE \
//	if (lua_getglobal(L, ObjectName) != LUA_TTABLE) { lua_pop(L, 1); return false; } \
//	lua_rawgeti(L, LUA_REGISTRYINDEX, FunctionRef->Ref); \
//	/* put the object back onto the stack for the "self" value in the function */ \
//	lua_pushvalue(L, -2);
//
//
//bool Lua::CallFunction(const char* ObjectName, LuaRef FunctionRef)
//{
//	SCOPE;
//	if (lua_getglobal(L, ObjectName) != LUA_TTABLE) { lua_pop(L, 1); return false; }
//	lua_rawgeti(L, LUA_REGISTRYINDEX, FunctionRef->Ref); \
//
//	/* put the object back onto the stack for the "self" value in the function */ \
//	lua_pushvalue(L, -2);
//
//	lua_pcall(L, 1, 1, 0);
//
//	return true;
//}
//
//bool Lua::CallFunction_ReturnOnStack(const char* ObjectName, const char* FunctionName)
//{
//	CALL_FUNCTION_NO_SCOPE_PREAMBLE
//	
//	lua_pcall(L, 1, 1, 0);
//
//	// @todo error handling
//	return true;
//}
//
//bool Lua::CallFunction_ReturnOnStack(const char* ObjectName, const LuaRef FunctionRef)
//{
//	CALL_FUNCTIONREF_NO_SCOPE_PREAMBLE
//
//	lua_pcall(L, 1, 1, 0);
//
//	// @todo error handling
//	return true;
//}
//
//bool Lua::CallFunction_ReturnOnStack(const char* ObjectName, const char* FunctionName, const char* Param)
//{
//	CALL_FUNCTION_NO_SCOPE_PREAMBLE
//
//	lua_pushstring(L, Param);
//	dumpstack(L);
//
//	lua_pcall(L, 2, 1, 0);
//
//	// @todo error handling
//	return true;
//}
//
//bool Lua::CallFunction_ReturnOnStack(const char* ObjectName, const LuaRef FunctionRef, const char* Param)
//{
//	CALL_FUNCTIONREF_NO_SCOPE_PREAMBLE
//
//	lua_pushstring(L, Param);
//	lua_pcall(L, 2, 1, 0);
//
//	// @todo error handling
//	return true;
//}

int PushSpec(lua_State* L, LuaRef TableRef)
{
	// just get the real table from the ref onto the stack
	lua_rawgeti(L, LUA_REGISTRYINDEX, TableRef->Ref);
	return lua_gettop(L);
}

//int PushSpec(lua_State* L, int TableStackLoc)
//{
//	lua_pushvalue(L, TableStackLoc);
//	return lua_gettop(L);
//}

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

//
//#define INSTANTIATE(Func, ResultType) \
//	template bool Lua::Func<int>(int, const char*, ResultType&) const; \
//	template bool Lua::Func<const char*>(const char*, const char*, ResultType&) const; \
//	template bool Lua::Func<LuaRef>(LuaRef, const char*, ResultType&) const;
//
//INSTANTIATE(GetIntValue, int)
//INSTANTIATE(GetStringValue, string)
//INSTANTIATE(GetTableValue, LuaRef)
//INSTANTIATE(GetFunctionValue, LuaRef)
//INSTANTIATE(GetStringValues, vector<string>)
//INSTANTIATE(GetTableValues, vector<LuaRef>)


//bool Lua::GetIntValue(const char* Object, const char* Name, int& Result) const
//{
//	SCOPE;
//	
//	lua_getglobal(L, Name);
//	if (!lua_isinteger(L, -1))
//	{
//		return false;
//	}
//	Result = (int)lua_tointeger(L, -1);
//	return true;
//}

void Lua::SetIntValue(const char* Object, const char* Name, int Value) const
{
	SCOPE;

	lua_pushinteger(L, Value);
	lua_setglobal(L, Name);
}

//bool Lua::GetStringValue(const char* Object, const char* Name, std::string& Result) const
//{
//	SCOPE;
//	
//	if (Object == nullptr)
//	{
//		lua_pushglobaltable(L);
//	}
//	else
//	{
//		lua_getglobal(L, Object);
//		// @todo need to check it exists
//	}
//	lua_getfield(L, -1, Name);
//
//	if (!lua_isstring(L, -1))
//	{
//		return false;
//	}
//	Result = lua_tostring(L, -1);
//	return true;
//}
//
void Lua::SetStringValue(const char* Object, const char* Name, const std::string& Value) const
{
	SCOPE;
	
	lua_pushlstring(L, Value.c_str(), (int)Value.length());
	lua_setglobal(L, Name);
}

//
//#define GET_TABLE_VALUE_PREAMBLE(TestFunc, FailedValue) \
//	SCOPE; \
//	if (lua_isnil(L, StackLoc)) { Result = FailedValue; return false; } \
//	lua_getfield(L, StackLoc, Name); \
//	if (!TestFunc(L, -1)) { Result = FailedValue; return false; }
//
//bool Lua::GetTableIntValue(const char* Name, int& Result, int StackLoc) const
//{
//	GET_TABLE_VALUE_PREAMBLE(lua_isinteger, 0)
//	
//	Result = (int)lua_tointeger(L, -1);
//	return true;
//}
//
//bool Lua::GetTableStringValue(const char* Name, std::string& Result, int StackLoc) const
//{
//	GET_TABLE_VALUE_PREAMBLE(lua_isstring, "")
//	
//	Result = lua_tostring(L, -1);
//	return true;
//}
//
//bool Lua::GetTableStringsValue(const char* Name, std::vector<std::string>& Result, int StackLoc) const
//{
//	GET_TABLE_VALUE_PREAMBLE(lua_istable, {})
//
//	int Table = lua_gettop(L);
//	lua_pushnil(L);  // first key
//	while (lua_next(L, Table) != 0)
//	{
//		// -2 is key, -1 is value
//		Result.push_back(lua_tostring(L, -1));
//		// move to next
//		lua_pop(L, 1);
//	}
//	return true;
//}
//
//bool Lua::GetTableTableValue(const char* Name, LuaRef& Result, int StackLoc) const
//{
//	GET_TABLE_VALUE_PREAMBLE(lua_istable, nullptr)
//
//	// make a ref to it
//	Result = MakeRef();
//	return true;
//}
//
//bool Lua::GetTableFunctionValue(const char* Name, LuaRef& Result, int StackLoc) const
//{
//	GET_TABLE_VALUE_PREAMBLE(lua_isfunction, nullptr)
//
//	// make a ref to it
//	Result = MakeRef();
//	return true;
//}
//
//bool Lua::GetTableTable_OnStack(const char* Name, int StackLoc) const
//{
//	if (lua_isnil(L, StackLoc))
//	{
//		return false;
//	}
//	
//	lua_getfield(L, StackLoc, Name);
//	if (!lua_istable(L, -1))
//	{
//		return false;
//	}
//	return true;
//}
//




//bool Lua::GetObject(const char* Name, int& Global)
//{
//	SCOPE;
//	
//	lua_pushstring(L, Name);
//	lua_gettable(L, 1);
//	if (!lua_istable(L, -1))
//	{
//		Global = -1;
//		return false;
//	}
//	
//	Global = lua_tointeger(L, -1);
//	return false;
//	
//	
//	
////	lua_getfield(L, 1, Name_);
////	if (!lua_istable(L, -1))
//
//	
//	int Index;
//	if (GetIntValue(Name, Index))
//	{
//		return Index;
//	}
//	return -1;
//}
