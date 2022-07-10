//
//  WoflGame.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

class IJsonObj
{
public:
	// serialization of the game
	virtual Json::Value ToJsonObject() = 0;
	virtual void FromJsonObject(const Json::Value& Object) = 0;
	
protected:
	template<class T>
	void AddArrayToObject(const vector<T*>& Array, Json::Value& Obj, const char* ArrayName)
	{
		// make a new array
		Json::Value ArrayObj(Json::arrayValue);
		// walk over the input array
		for (IJsonObj* Entry : Array)
		{
			// convert to json
			Json::Value NewObj = Entry->ToJsonObject();
			ArrayObj.append(NewObj);
		}
		
		Obj[ArrayName] = ArrayObj;
	}
	
	template<class T>
	void GetArrayFromObject(vector<T*>& Array, const Json::Value& Obj, const char* ArrayName, const function<void(T*)>& OnAddFunc=nullptr)
	{
		// toss any old entries
		for (T* Entry : Array)
		{
			delete Entry;
		}
		Array.clear();
		
		// pull out the array
		Json::Value ArrayObj = Obj[ArrayName];
		
		// create objects from the array
		for (const Json::Value& Obj : ArrayObj)
		{
			T* NewEntry = new T;
			NewEntry->FromJsonObject(Obj);
			Array.push_back(NewEntry);

			// call a function on each obhect
			if (OnAddFunc)
			{
				OnAddFunc(NewEntry);
			}
		}
	}
	
};

class WoflGame : public IJsonObj
{
public:
	static WoflGame* TheGame;

	WoflGame(const char* InGameName)
		: GameName(InGameName)
	{
		TheGame = this;
	}

	const string& GetGameName()
	{
		return GameName;
	}

	virtual class WoflHud* GetHud()
	{
		return nullptr;
	}
	
	virtual void Tick(float DeltaTime)
	{
		
	}
	
	virtual void PostRender()
	{
		
	}
	
	// save
	bool Save();
	bool Load();
	
protected:

	// default the game to no load/save
	virtual Json::Value ToJsonObject() override
	{
		return Json::Value(Json::objectValue);
	}
	
	virtual void FromJsonObject(const Json::Value& Object) override
	{
		
	}

	
private:
	// name of the particular games
	string GameName;
};

