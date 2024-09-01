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

class Lua : public IJsonObj
{
public:
	Lua(void* Context);
	~Lua();

	// IJsonObj
	virtual Json::Value ToJsonObject() override;
	virtual void FromJsonObject(const Json::Value& Object) override;

	void RegisterFunction(const char* FunctionName, lua_CFunction Func);
	
	void SetGlobal(const char* GlobalName, int Value);
	void SetGlobal(const char* GlobalName, const char* Value);

	bool GetString(const string& Code, string& Result);
	bool GetBool(const string& Code, bool& Result);
	
	bool RunCode(const string& Code);
	
	bool GetIntValue(const string& Name, int& Result) const;
	void SetIntValue(const string& Name, int Value) const;
	bool GetStringValue(const string& Name, string& Result) const;
	void SetStringValue(const string& Name, const string& Value) const;

private:
	mutable lua_State* L;
	set<string> SystemVariables;
};
