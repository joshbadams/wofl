//
//  Lua.hpp
//  Neuro
//
//  Created by Josh Adams on 2/17/24.
//

#pragma once

#include <Wofl/Wofl.h>
#include "../../lua/lua.hpp"

#include <string>
#include <set>
using namespace	 std;

class Lua;
struct lua_State;

class LuaRef
{
public:
	~LuaRef();
	
private:
	friend class Lua;
	friend int PushSpec(lua_State* L, LuaRef* TableRef);
	friend int PushParam(lua_State* L, LuaRef* Param);
	friend bool GetReturn(lua_State* L, LuaRef*& Param);
	friend int PushFuncSpec(lua_State* L, int TableStackLoc, LuaRef* Func);

	LuaRef(const Lua* LuaObj, int RefIndex);
	LuaRef(lua_State* LuaObj, int RefIndex);

	lua_State* L;
	int Ref;
};

struct LuaScope
{
	LuaScope(lua_State* Lua);
	LuaScope(Lua* Lua);
	~LuaScope();

private:
	lua_State* L;
	int StackDepth;
};

#define LUA_SCOPE LuaScope Scope(&Lua);



class Lua : public IJsonObj
{
public:
	Lua(void* Context);
	~Lua();

	// IJsonObj
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;

	void RegisterFunction(const char* FunctionName, lua_CFunction Func);
	
	LuaRef* MakeRef() const;

	int MarkStack();
	void RestoreStack(int StackDepth);
	bool TopIsNil();

	void SetGlobal(const char* GlobalName, int Value);
	void SetGlobal(const char* GlobalName, const char* Value);

	bool GetString(const string& Code, string& Result);
	bool GetBool(const string& Code, bool& Result);
	

	bool RunCode(const string& Code);
//	bool CallFunction(const char* ObjectName, LuaRef* FunctionRef);
//	bool CallFunction_ReturnOnStack(const char* ObjectName, const char* FunctionName);
//	bool CallFunction_ReturnOnStack(const char* ObjectName, const char* FunctionName, const char* Param);
//	bool CallFunction_ReturnOnStack(const char* ObjectName, const LuaRef* FunctionRef);
//	bool CallFunction_ReturnOnStack(const char* ObjectName, const LuaRef* FunctionRef, const char* Param);
	

//	bool GetIntValue(const char* Object, const char* Name, int& Result) const;
	void SetIntValue(const char* Object, const char* Name, int Value) const;
//	bool GetStringValue(const char* Object, const char* Name, string& Result) const;
	void SetStringValue(const char* Object, const char* Name, const string& Value) const;
//	
//	bool GetTableIntValue(const char* Name, int& Result, int StackLoc=-1) const;
//	bool GetTableStringValue(const char* Name, string& Result, int StackLoc=-1) const;
//	bool GetTableStringsValue(const char* Name, vector<string>& Result, int StackLoc=-1) const;
//	bool GetTableTableValue(const char* Name, LuaRef*& Result, int StackLoc=-1) const;
//	bool GetTableFunctionValue(const char* Name, LuaRef*& Result, int StackLoc=-1) const;
//	bool GetTableTable_OnStack(const char* Name, int StackLoc=-1) const;

	
	
	template<typename TableSpec>
	bool GetIntValue(TableSpec Table, const char* Name, int& Result) const;

	template<typename TableSpec>
	bool GetStringValue(TableSpec Table, const char* Name, string& Result) const;

	template<typename TableSpec>
	bool GetTableValue(TableSpec Table, const char* Name, LuaRef*& Result) const;

	template<typename TableSpec>
	bool GetFunctionValue(TableSpec Table, const char* Name, LuaRef*& Result) const;

	template<typename TableSpec>
	bool GetStringValues(TableSpec Table, const char* Name, vector<string>& Result) const;

	template<typename TableSpec>
	bool GetTableValues(TableSpec Table, const char* Name, vector<LuaRef*>& Result) const;



	template<typename TableSpec, typename FuncSpec>
	bool CallFunction_NoParam_NoReturn(TableSpec Table, FuncSpec Function) const;

	template<typename TableSpec, typename FuncSpec, typename P1Type>
	bool CallFunction_OneParam_NoReturn(TableSpec Table, FuncSpec Function, P1Type P1) const;

	template<typename TableSpec, typename FuncSpec, typename ReturnType>
	bool CallFunction_NoParam_Return(TableSpec Table, FuncSpec Function, ReturnType& Result) const;

	template<typename TableSpec, typename FuncSpec, typename P1Type, typename ReturnType>
	bool CallFunction_OneParam_Return(TableSpec Table, FuncSpec Function, P1Type P1, ReturnType& Result) const;


private:
	friend class LuaScope;
	friend class LuaRef;
	mutable lua_State* L;
	set<string> SystemVariables;
};




int PushSpec(lua_State* L, LuaRef* TableRef);
//int PushSpec(lua_State* L, int TableStackLoc);
int PushSpec(lua_State* L, const char* TableName);

int PushFuncSpec(lua_State* L, int TableStackLoc, LuaRef* TableRef);
int PushFuncSpec(lua_State* L, int TableStackLoc, const char* TableName);

int PushParam(lua_State* L, LuaRef* Param);
int PushParam(lua_State* L, int Param);
int PushParam(lua_State* L, const char* Param);

bool GetReturn(lua_State* L, LuaRef*& Param);
bool GetReturn(lua_State* L, int& Param);
bool GetReturn(lua_State* L, string& Param);


void dumpstack (lua_State *L);

#define SCOPE LuaScope Scope(L);

#define GET_TABLE_VALUE_PREAMBLE(TestFunc, FailedValue) \
	SCOPE; \
	int StackLoc = PushSpec(L, Table); \
	if (!lua_istable(L, StackLoc)) { Result = FailedValue; return false; } \
	lua_getfield(L, -1, Name); \
	if (!TestFunc(L, -1)) { Result = FailedValue; return false; }

#define CALL_FUNCTION_PREAMBLE() \
	SCOPE; \
	PushSpec(L, Table); \
	if (!lua_istable(L, -1)) { return false; } \
	PushFuncSpec(L, -1, Function); \
	/* push the Table back on as the "self" param */ \
	lua_pushvalue(L, -2);

#define CALL_FUNCTION_PREAMBLE_RETURN() \
	SCOPE; \
	PushSpec(L, Table); \
	if (!lua_istable(L, -1)) { Result = {}; return false; } \
	PushFuncSpec(L, Function); \
	/* push the Table back on as the "self" param */ \
	lua_pushvalue(L, -2);

#define CALL_FUNC(NumParams, NumReturns) \
	/* Add one for the self param we pass all functions */ \
	if (lua_pcall(L, NumParams + 1, NumReturns, 0)) \
	{ \
		WLOG("Failed to call function. Stack and error:\n"); \
		dumpstack(L); \
		return false; \
	}

	



template<typename TableSpec>
bool Lua::GetIntValue(TableSpec Table, const char* Name, int& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_isinteger, 0)
	
	Result = (int)lua_tointeger(L, -1);
	return true;
}

template<typename TableSpec>
bool Lua::GetStringValue(TableSpec Table, const char* Name, string& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_isstring, "")

	Result = lua_tostring(L, -1);
	return true;
}

template<typename TableSpec>
bool Lua::GetTableValue(TableSpec Table, const char* Name, LuaRef*& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_istable, nullptr)

	// this makes a ref to top of stack
	Result = MakeRef();
	return true;
}

template<typename TableSpec>
bool Lua::GetFunctionValue(TableSpec Table, const char* Name, LuaRef*& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_isfunction, nullptr)

	// this makes a ref to top of stack
	Result = MakeRef();
	return true;
}

template<typename TableSpec>
bool Lua::GetStringValues(TableSpec Table, const char* Name, vector<string>& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_istable, {})

	dumpstack(L);
	int TableLoc = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, TableLoc) != 0)
	{
		// -2 is key, -1 is value
		Result.push_back(lua_tostring(L, -1));
		// move to next
		lua_pop(L, 1);
	}

	return true;
}

template<typename TableSpec>
bool Lua::GetTableValues(TableSpec Table, const char* Name, vector<LuaRef*>& Result) const
{
	GET_TABLE_VALUE_PREAMBLE(lua_istable, {})

	dumpstack(L);
	int TableLoc = lua_gettop(L);
	lua_pushnil(L);  // first key
	while (lua_next(L, TableLoc) != 0)
	{
		// -2 is key, -1 is value
		Result.push_back(MakeRef());
		// move to next
//		lua_pop(L, 1);
	}

	return true;
}


template<typename TableSpec, typename FuncSpec>
bool Lua::CallFunction_NoParam_NoReturn(TableSpec Table, FuncSpec Function) const
{
	// this will push the table
	CALL_FUNCTION_PREAMBLE();

	CALL_FUNC(0, 0);

	return true;
}

template<typename TableSpec, typename FuncSpec, typename P1Type>
bool Lua::CallFunction_OneParam_NoReturn(TableSpec Table, FuncSpec Function, P1Type P1) const
{
	CALL_FUNCTION_PREAMBLE();
	
	PushParam(L, P1);
	CALL_FUNC(1, 0);
	
	return true;
}

template<typename TableSpec, typename FuncSpec, typename ReturnType>
bool Lua::CallFunction_NoParam_Return(TableSpec Table, FuncSpec Function, ReturnType& Result) const
{
	CALL_FUNCTION_PREAMBLE();
	
	CALL_FUNC(0, 1);

	return GetReturn(L, Result);
}

template<typename TableSpec, typename FuncSpec, typename P1Type, typename ReturnType>
bool Lua::CallFunction_OneParam_Return(TableSpec Table, FuncSpec Function, P1Type P1, ReturnType& Result) const
{
	CALL_FUNCTION_PREAMBLE();
	
	PushParam(L, P1);

	CALL_FUNC(1, 1);
	
//	WLOG("field type: %d\n", lua_getfield(L, -1, "tag"));
//	dumpstack(L);

	return GetReturn(L, Result);
}




//
//template<typename TableFuncSpec>
//bool Lua::CallFunctionWithNoReturn(TableFuncSpec Table, TableFuncSpec Function) const
//{
//	// this will push the table
//	CALL_FUNCTION_PREAMBLE(0);
//
//	if (lua_pcall(L, 1, 0, 0))
//	{
//		WLOG("Failed to call function. Stack and error:\n%s\n", dumpstack(L));
//		return false;
//	}
//
//	return true;
//}
//
//template<typename TableFuncSpec>
//bool Lua::CallFunctionWithIntReturn(TableFuncSpec Table, TableFuncSpec Function, int& Result) const
//{
//	// this will push the table
//	CALL_FUNCTION_PREAMBLE_RETURN(0);
//
//	if (lua_pcall(L, 1, 1, 0))
//	{
//		WLOG("Failed to call function. Stack and error:\n%s\n", dumpstack(L));
//		return false;
//	}
//	
//	if (!lua_isinteger(L, -1))
//	{
//		Result = 0;
//		return false;
//	}
//	Result = (int)lua_tointeger(L, -1);
//	return true;
//}
//
//template<typename TableFuncSpec>
//bool Lua::CallFunctionWithTableReturn(TableFuncSpec Table, TableFuncSpec Function, LuaRef*& Result) const
//{
//	// this will push the table
//	CALL_FUNCTION_PREAMBLE_RETURN(nullptr);
//
//	if (lua_pcall(L, 1, 1, 0))
//	{
//		WLOG("Failed to call function. Stack and error:\n%s\n", dumpstack(L));
//		return false;
//	}
//	
//	if (!lua_istable(L, -1))
//	{
//		Result = nullptr;
//		return false;
//	}
//	
//	Result = MakeRef();
//	return true;
//}
