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
	
	virtual string PostProcessString(const string& String)
	{
		return String;
	}
	
	string GetString(const Json::Value& Obj, const char* Key)
	{
		if (Obj.isMember(Key))
		{
			return PostProcessString(Obj[Key].asString());
		}
		return "";
	}

	bool GetBool(const Json::Value& Obj, const char* Key)
	{
		if (Obj.isMember(Key))
		{
			return Obj[Key].asBool();
		}
		return false;
	}

	int GetInt(const Json::Value& Obj, const char* Key)
	{
		if (Obj.isMember(Key))
		{
			return Obj[Key].asInt();
		}
		return 0;
	}
	
	void AddIntArrayToObject(const vector<int>& Array, Json::Value& Obj, const char* ArrayName)
	{
		// make a new array
		Json::Value ArrayObj(Json::arrayValue);
		// walk over the input array
		for (int Entry : Array)
		{
			ArrayObj.append(Json::Value(Entry));
		}
		
		Obj[ArrayName] = ArrayObj;
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
	
	void GetIntArrayFromObject(vector<int>& Array, const Json::Value& Obj, const char* ArrayName)
	{
		Array.clear();
		// pull out the array
		Json::Value ArrayObj = Obj[ArrayName];
		// create objects from the array
		for (const Json::Value& Obj : ArrayObj)
		{
			Array.push_back(Obj.asInt());
		}
	}
	
	void GetStringArrayFromObject(vector<string>& Array, const Json::Value& Obj, const char* ArrayName)
	{
		Array.clear();
		// pull out the array
		Json::Value ArrayObj = Obj[ArrayName];
		// create objects from the array
		for (const Json::Value& Obj : ArrayObj)
		{
			Array.push_back(PostProcessString(Obj.asString()));
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
	
	template<class T>
	void GetIntMapFromObject(map<int, T*>& Map, const Json::Value& Obj, const char* MapName, const function<void(T*)>& OnAddFunc=nullptr)
	{
		// toss any old entries
		for (auto Pair : Map)
		{
			delete Pair.second;
		}
		Map.clear();
		
		// pull out the map
		Json::Value MapObj = Obj[MapName];
		
		// create objects from the object keys
		for (auto Name : MapObj.getMemberNames())
		{
			int Key = stoi(Name);
			T* NewEntry = new T;
			NewEntry->FromJsonObject(MapObj[Name]);
			Map[Key] = NewEntry;

			// call a function on each object
			if (OnAddFunc)
			{
				OnAddFunc(NewEntry);
			}
		}
	}
	
	template<class T>
	void GetStringMapFromObject(map<string, T*>& Map, const Json::Value& Obj, const char* MapName, const function<void(T*)>& OnAddFunc=nullptr)
	{
		// toss any old entries
		for (auto Pair : Map)
		{
			delete Pair.second;
		}
		Map.clear();
		
		// pull out the map
		Json::Value MapObj = Obj[MapName];
		
		// create objects from the object keys
		for (auto Name : MapObj.getMemberNames())
		{
			T* NewEntry = new T;
			NewEntry->FromJsonObject(MapObj[Name]);
			Map[PostProcessString(Name)] = NewEntry;

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
		WLOG("Loading save game %s...\n", Filename);
		
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

