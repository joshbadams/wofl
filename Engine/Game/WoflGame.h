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
	
	string GetString(const Json::Value& Obj, const char* Key)
	{
		if (Obj.isMember(Key))
		{
			return Obj[Key].asString();
		}
		return "";
	}
	
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
	
	void GetStringArray(vector<string>& Array, const Json::Value& Obj, const char* ArrayName)
	{
		Array.clear();
		// pull out the array
		Json::Value ArrayObj = Obj[ArrayName];
		// create objects from the array
		for (const Json::Value& Obj : ArrayObj)
		{
			Array.push_back(Obj.asString());
		}
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
			
			// call a function on each object
			if (OnAddFunc)
			{
				OnAddFunc(NewEntry);
			}
		}
	}
	
	bool SaveToFile(const char* Filename)
	{
		string JsonString = ToJsonObject().toStyledString();
		
		return Utils::File->SaveStringToFile(JsonString, Filename);
	}
	
	bool LoadFromFile(const char* Filename)
	{
		string JsonString = Utils::File->LoadFileToString(Filename);

		if (JsonString.length() == 0)
		{
			return false;
		}
		
		Json::Reader Reader;
		Json::Value Root(Json::objectValue);
		
		// convert into an object hierarchy
		if (Reader.parse(JsonString, Root, false) == false)
		{
			WLOG("Failed to load %s : %s\n", Filename, Reader.getFormattedErrorMessages().c_str());
			return false;
		}

		// let the object load itself from the Json string
		FromJsonObject(Root);
		
		return true;
	}
};

class LoadJsonObj : public IJsonObj
{
private:
	virtual Json::Value ToJsonObject()
	{
		return Json::Value(Json::objectValue);
	};
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

