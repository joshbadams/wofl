//
//  WoflFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once


enum FileDomain
{
	Save,
	System,
	Game,
	Absolute,
	
	GameThenSystem,
	SystemThenGame,
};

class WoflFile
{
public:
	WoflFile()
	{
		// register ourself
		Utils::File = this;
	}
	
	
	virtual void SetGameDomainName(const char* GameDomainName)
	{
		GameDomain = GameDomainName;
	}
	
	virtual std::vector<std::string> FindFiles(FileDomain Domain, const char* Directory, const char* Ext, bool bIncludePath=true, bool bIncludeExtension=true) = 0;
	
	
	std::string LoadFileToString(const char* Path, FileDomain Domain)
	{
		return LoadFileToType<std::string>(Path, Domain);
	}
	std::vector<unsigned char> LoadFileToArray(const char* Path, FileDomain Domain)
	{
		return LoadFileToType<std::vector<unsigned char>>(Path, Domain);
	}
	// Helper that reads in a .png file (by name with NO extension, NOT path), and returns the data and size info
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) = 0;
	
	virtual bool SaveStringToFile(const std::string& String, const char* Path, FileDomain Domain) = 0;
	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path, FileDomain Domain) = 0;
	
protected:
	// @todo: Maybe this should have a default fopen implementation
	template<typename ResultType>
	ResultType LoadFileToType(const char* Path, FileDomain Domain)
	{
		ResultType Result;
		std::string FullPath;
		switch (Domain)
		{
			case FileDomain::System:
			case FileDomain::Game:
			case FileDomain::Absolute:
			case FileDomain::Save: FullPath = GetFinalPath(Domain, Path); break;
			case FileDomain::GameThenSystem: FullPath = GetFinalPath(FileDomain::Game, Path); break;
			case FileDomain::SystemThenGame: FullPath = GetFinalPath(FileDomain::System, Path); break;
		}
		
		
		bool bSucceeded = LoadFile(FullPath, Result);
		if (bSucceeded)
		{
			if (Domain == FileDomain::Save)
			{
				WLOG("Loaded save domain file: %s\n", FullPath.c_str());
			}
		}
		else
		{
			switch (Domain)
			{
				case FileDomain::System:
				case FileDomain::Game:
				case FileDomain::Absolute:
				case FileDomain::Save: return ResultType();
				case FileDomain::GameThenSystem: FullPath = GetFinalPath(FileDomain::System, Path); break;
				case FileDomain::SystemThenGame: FullPath = GetFinalPath(FileDomain::Game, Path); break;
			}
			
			LoadFile(FullPath, Result);
		}
		
		return Result;
	}



	std::string GameDomain;
	
	virtual std::string GetFinalPath(FileDomain Domain, const char* SubPath) = 0;
	
	virtual bool LoadFile(const std::string& Path, std::string& OutString) = 0;
	virtual bool LoadFile(const std::string& Path, std::vector<unsigned char>& OutArray) = 0;
	
//	virtual bool SaveStringToFile(const std::string& String, const char* Path) = 0;
//	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path) = 0;
};

