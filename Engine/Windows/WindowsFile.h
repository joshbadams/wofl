//
//  iOSFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_iOSFile_h
#define Wofl_iOSFile_h

#include "WoflFile.h"
#include "stb_image.h"
#include <windows.h>
#include <fileapi.h>


class WindowsFile : public WoflFile
{
public:
	
	WindowsFile()
		: WoflFile()
	{
		Utils::File = this;
	}
	
	virtual std::string GetResourcePath(const char* Filename) override
	{
		return Filename;
	}
	
	virtual std::string GetSavePath(const char* Filename) override
	{
		char HomeDir[1024];
		GetEnvironmentVariableA("APPDATA", HomeDir, 1023);
		std::string Path = std::string(HomeDir) + "/Wofl/";
		CreateDirectoryA(Path.c_str(), nullptr);
		return Path + Filename;
	}
	
	virtual std::string LoadFileToString(const char* Path) override
	{
		// @todo: move this to WoflFile, or a WoflStandardFile or something
		FILE* File;
		if (fopen_s(&File, Path, "r") != 0)
		{
			WLOG("Failed to load %s\n", Path);
			return "";
		}
		fseek(File, 0, SEEK_END);
		size_t FileSize = ftell(File);
		fseek(File, 0, SEEK_SET);
		char* Buffer = (char*)malloc(FileSize + 1);
		Buffer[FileSize] = 0;
		fread(Buffer, FileSize, 1, File);
		fclose(File);
		std::string Contents = Buffer;
		free(Buffer);
		return Contents;
	}

	virtual std::vector<unsigned char> LoadFileToArray(const char* Path) override
	{
		FILE* File;
		if (fopen_s(&File, Path, "rb") != 0)
		{
			WLOG("Failed to load %s\n", Path);
			return std::vector<unsigned char>();
		}
		fseek(File, 0, SEEK_END);
		size_t FileSize = ftell(File);
		fseek(File, 0, SEEK_SET);

		std::vector<unsigned char> Buffer;
		Buffer.resize(FileSize);
		fread(&Buffer[0], FileSize, 1, File);
		fclose(File);
		return Buffer;
	}

	
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) override
	{
		// load PNG file into buffer
		std::string Filename = std::string(ImageName);
		Filename = GetResourcePath(Filename.c_str());

		int X, Y, N;
		unsigned char* PNGData = stbi_load(Filename.c_str(), &X, &Y, &N, 4);
		Width = X;
		Height = Y;

		void* Texture = malloc(Width * Height * 4);
		//		memcpy(Texture, &Buffer[0], Buffer.size());
		memcpy(Texture, &PNGData[0], Width * Height * 4);

		stbi_image_free(PNGData);
		return Texture;
	}
	
	virtual bool SaveStringToFile(const std::string& String, const char* Path) override
	{
		FILE* File;
		if (fopen_s(&File, Path, "w") != 0)
		{
			WLOG("Failed to save %s\n", Path);
			return "";
		}

		// write it out!
		fwrite(String.c_str(), String.length(), 1, File);
		fclose(File);

		return true;
}

	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path) override
	{
		FILE* File;
		if (fopen_s(&File, Path, "w") != 0)
		{
			WLOG("Failed to save %s\n", Path);
			return "";
		}

		// write it out!
		fwrite(Array.data(), Array.size(), 1, File);
		fclose(File);

		return true;

	}

protected:

};

#endif
