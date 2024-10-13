//
//  AndroidFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include "WoflFile.h"
#include "WoflGame.h"
#include <android/obb.h>

class AndroidFile : public WoflFile
{
public:
	
	AndroidFile()
		: WoflFile()
	{
	
	}
	
	virtual std::string GetResourcePath(const char* Filename) override
	{
		return std::string("/mnt/sdcard/") + WoflGame::TheGame->GetGameName() + "/" + Filename;
	}

	virtual std::string GetSavePath(const char* Filename) override
	{
		return std::string("/mnt/sdcard/") + WoflGame::TheGame->GetGameName() + "/save/" + Filename;
	}

	virtual std::string LoadFileToString(const char* Path) override
	{
		FILE* File = fopen(Path, "r");
		if (File == NULL)
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
		FILE* File = fopen(Path, "rb");
		if (File == NULL)
		{
			WLOG("Failed to load %s\n", Path);
			return std::vector<unsigned char>();
		}
		fseek(File, 0, SEEK_END);
		size_t FileSize = ftell(File);
		fseek(File, 0, SEEK_SET);

		std::vector<unsigned char> Buffer;
		Buffer.reserve(FileSize);
		fread(&Buffer[0], FileSize, 1, File);
		fclose(File);
		return Buffer;
	}

	
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) override
	{
		// load PNG file into buffer
		std::string Filename = std::string(ImageName) + ".png";
		Filename = GetResourcePath(Filename.c_str());
		std::vector<unsigned char> Buffer = LoadFileToArray(Filename.c_str());

		Width = 64;
		Height = 64;
		void* Texture = malloc(Width * Height * 4);
		memcpy(Texture, &Buffer[0], Buffer.size());
		return Texture;

//		UIImage* Image = [UIImage imageNamed:[NSString stringWithCString:ImageName encoding:NSUTF8StringEncoding]];
//
//		// pull out info
//		Width = [Image size].width;
//		Height = [Image size].height;
//
//		// allocate all the memory
//		void* ImageData = malloc(Width * Height * 4);
//		memset(ImageData, 0, Width * Height * 4);
//
//		// draw the UIImage into the memory block
//		CGContextRef SpriteContext = CGBitmapContextCreate(ImageData, Width, Height, 8, Width * 4,
//														   CGImageGetColorSpace(Image.CGImage),
//														   kCGImageAlphaPremultipliedLast);
//		// After you create the context, you can draw the sprite image to the context.
//		CGContextDrawImage(SpriteContext, CGRectMake(0.0, 0.0, (CGFloat)Width, (CGFloat)Height), Image.CGImage);
//		// You don't need the context at this point, so you need to release it to avoid memory leaks.
//		CGContextRelease(SpriteContext);
//
//		return ImageData;
		return NULL;
	}

	virtual bool SaveStringToFile(const std::string& String, const char* Path) override
	{
		FILE* File = fopen(Path, "w");
		if (File == NULL)
		{
			WLOG("Failed to save %s\n", Path);
			return false;
		}
		// write it out!
		fwrite(String.c_str(), String.length(), 1, File);
		fclose(File);

		return true;
	}

	virtual bool SaveArrayToFile(const std::vector<unsigned char>& Array, const char* Path) override
	{
		FILE* File = fopen(Path, "w");
		if (File == NULL)
		{
			WLOG("Failed to save %s\n", Path);
			return false;
		}

		// write it out!
		fwrite(Array.data(), Array.size(), 1, File);
		fclose(File);

		return true;

	}

};
