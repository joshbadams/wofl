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
#include <PathCch.h>


class WindowsFile : public WoflFile
{
public:
	
	WindowsFile()
		: WoflFile()
	{
		Utils::File = this;
	}
	

	virtual std::string GetFinalPath(FileDomain Domain, const char* SubPath) override
	{
		if (Domain == FileDomain::Absolute)
		{
			return SubPath;
		}

		assert(Domain == FileDomain::Game || Domain == FileDomain::System || Domain == FileDomain::Save || Domain == FileDomain::Engine);

		if (Domain == FileDomain::Save)
		{
			char HomeDir[1024];
			GetEnvironmentVariableA("APPDATA", HomeDir, 1023);
			std::string Path = std::string(HomeDir) + "/Wofl/";
			if (GameDomain.length() > 0)
			{
				Path += "/";
				Path += GameDomain;
			}
			// make sure the dir exists
			CreateDirectoryA(Path.c_str(), nullptr);
			if (SubPath)
			{
				Path += "/";
				Path += SubPath;
			}
			return Path;
		}
		else if (Domain == FileDomain::Engine)
		{
			// Game and System are relative to the binary
			std::string Path = "../../Engine/Rendering/Resources/";
			Path += SubPath;
			return Path;
		}
		else
		{
			// Game and System are relative to the binary
			std::string Path = "../Neuro/Resources/";
			if (Domain == FileDomain::Game)
			{
				Path += GameDomain;
			}
			else
			{
				Path += "System";
			}
			if (SubPath)
			{
				Path += "/";
				Path += SubPath;
			}
			return Path;
		}
		return "";
	}

	virtual bool LoadFile(const std::string& Path, std::string& OutString) override
	{
		// @todo: move this to WoflFile, or a WoflStandardFile or something
		FILE* File;
		if (fopen_s(&File, Path.c_str(), "rb") != 0)
		{
			WLOG("Failed to load %s\n", Path.c_str());
			return false;
		}
		fseek(File, 0, SEEK_END);
		size_t FileSize = ftell(File);
		fseek(File, 0, SEEK_SET);
		char* Buffer = (char*)malloc(FileSize + 1);
		fread(Buffer, FileSize, 1, File);
		Buffer[FileSize] = 0;
		fclose(File);
		OutString = Buffer;
		free(Buffer);
		return true;
	}

	virtual bool LoadFile(const std::string& Path, std::vector<unsigned char>& OutArray) override
	{
		// @todo: move this to WoflFile, or a WoflStandardFile or something
		FILE* File;
		if (fopen_s(&File, Path.c_str(), "rb") != 0)
		{
			WLOG("Failed to load %s\n", Path.c_str());
			return false;
		}
		fseek(File, 0, SEEK_END);
		size_t FileSize = ftell(File);
		fseek(File, 0, SEEK_SET);

		OutArray.resize(FileSize);
		fread(OutArray.data(), FileSize, 1, File);

		fclose(File);
		return true;
	}
	
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) override
	{
		// load PNG file into buffer
		std::vector<unsigned char> Bytes = LoadFileToArray(ImageName, FileDomain::GameThenSystem);
		if (Bytes.size() == 0)
		{
			Bytes = LoadFileToArray(ImageName, FileDomain::Engine);
			if (Bytes.size() == 0)
			{
				return nullptr;
			}
		}

		int X, Y, N;
		unsigned char* PNGData = stbi_load_from_memory(Bytes.data(), (int)Bytes.size(), &X, &Y, &N, 4);
		Width = X;
		Height = Y;

		void* Texture = malloc(Width * Height * 4);
		//		memcpy(Texture, &Buffer[0], Buffer.size());
		memcpy(Texture, &PNGData[0], Width * Height * 4);

		stbi_image_free(PNGData);
		return Texture;
	}
	
	virtual bool SaveStringToFile(const std::string& String, const char* Path, FileDomain Domain) override
	{
		std::string PathStr = GetFinalPath(Domain, Path);

		FILE* File;
		if (fopen_s(&File, PathStr.c_str(), "w") != 0)
		{
			WLOG("Failed to save %s\n", Path);
			return "";
		}

		// write it out!
		fwrite(String.c_str(), String.length(), 1, File);
		fclose(File);

		return true;
}

	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path, FileDomain Domain) override
	{
		std::string PathStr = GetFinalPath(Domain, Path);

		FILE* File;
		if (fopen_s(&File, PathStr.c_str(), "w") != 0)
		{
			WLOG("Failed to save %s\n", Path);
			return "";
		}

		// write it out!
		fwrite(Array.data(), Array.size(), 1, File);
		fclose(File);

		return true;

	}


	virtual std::vector<std::string> FindFiles(FileDomain Domain, const char* InDirectory, const char* Ext, bool bIncludePath, bool bIncludeExtension) override
	{
		std::vector<std::string> Results;
		std::string Directory = GetFinalPath(Domain, InDirectory);
		if (!Directory.ends_with('/'))
		{
			Directory += '/';
		}
		Directory += "*";
		if (Ext)
		{
			Directory += ".";
			Directory += Ext;
		}

		WIN32_FIND_DATAA FindData;
		HANDLE File = FindFirstFileA(Directory.c_str(), &FindData);
		if (File != INVALID_HANDLE_VALUE)
		{
			do
			{

				if (_stricmp(FindData.cFileName, ".") != 0 && _stricmp(FindData.cFileName, "..") != 0)
				{
					if ((FindData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0)
					{
						std::string FullPath;
						if (bIncludePath)
						{
							FullPath = InDirectory;
							FullPath += "/";
						}
						if (!bIncludeExtension)
						{
							char* Dot = strrchr(FindData.cFileName, '.');
							if (Dot)
							{
								*Dot = 0;
							}
						}
						FullPath += FindData.cFileName;
						Results.push_back(FullPath);
					}
				}
			}
			while (FindNextFileA(File, &FindData));
		}

		return Results;
	}

protected:

};

#endif
