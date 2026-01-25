//
//  iOSPlatform.h
//  Wofl
//
//  Created by Josh on 2/23/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include <windows.h>
#include "WoflPlatform.h"

#define strcasecmp _stricmp

class WindowsPlatform : public WoflPlatform
{
public:
	
	WindowsPlatform()
		: WoflPlatform()
	{
		QueryPerformanceCounter(&StartTime);
		QueryPerformanceFrequency(&Frequency);
	}
	
	virtual double GetTime() override
	{
		LARGE_INTEGER Now;
		QueryPerformanceCounter(&Now);
		return (Now.QuadPart - StartTime.QuadPart) / (double)Frequency.QuadPart;
	}

	std::string wstring_to_utf8(const std::wstring& wstr) 
	{
		char AnsiStr[1024];
		WideCharToMultiByte(CP_ACP, 0, wstr.c_str(), (int)wstr.size(), AnsiStr, 1024, 0, nullptr);
		return AnsiStr;
	}

	virtual std::string GetCommandLineOption(const char* Option, const char* Default = "") override
	{
		int ArgC;
		LPWSTR* ArgV = CommandLineToArgvW(GetCommandLineW(), &ArgC);

		std::string Opt = "-";
		Opt += Option;

		for (int Arg = 0; Arg < ArgC; Arg++)
		{
			std::string Param = wstring_to_utf8(ArgV[Arg]);
			if (Param.starts_with(Opt))
			{
				return std::string(&Param[Opt.size() + 1]);
			}
		}

		
		return Default;
	}

	
protected:
	LARGE_INTEGER StartTime, Frequency;
};
