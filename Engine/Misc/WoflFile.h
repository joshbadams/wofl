//
//  WoflFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once


class WoflFile
{
public:
	WoflFile()
	{
		// register ourself
		Utils::File = this;
	}
	
	virtual string GetResourcePath(const char* Filename) = 0;
	virtual string GetSavePath(const char* Filename) = 0;

	// @todo: Maybe this should have a default fopen implementation
	virtual string LoadFileToString(const char* Path) = 0;
	virtual vector<unsigned char> LoadFileToArray(const char* Path) = 0;

	// Helper that reads in a .png file (by name with NO extension, NOT path), and returns the data and size info
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) = 0;

	virtual bool SaveStringToFile(const string& String, const char* Path) = 0;
	virtual bool SaveArrayToFile(const vector<unsigned char>& Array, const char* Path) = 0;
};

