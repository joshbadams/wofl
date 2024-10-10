//
//  Render.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include <string>

// now let the platform extend
#if IOS
//#include "iOSGLSetup.h"
#elif ANDROID
#include "Android/AndroidGLSetup.h"
#else
//#error New platforms here. Hah!
#endif

//#include "WoflMath.h"

class WoflRenderer
{
public:
	static WoflRenderer* Renderer;
	
	WoflRenderer();
	virtual ~WoflRenderer()
	{
	}

	virtual void InitializeAfterWindowCreate(void* Window, unsigned int Width, unsigned int Height)
	{

	}
	
	virtual void BeginFrame() = 0;
	virtual void DrawScene(class WoflSprite* RootSprite) = 0;
	virtual void EndFrame() = 0;

	virtual void DrawString(const char* String, Vector Location, float Scale=1.0f, WColor& Color=WColor::White) = 0;
	

	virtual int CreateUncompressedTexture(unsigned int Width, unsigned int Height, void* Contents) = 0;

	virtual Vector GetTextureSize(unsigned int Texture) = 0;
	
	virtual Vector GetStringSize(const char* String, float Scale=1.0f);
	virtual void DrawCenteredString(const char* String, float Y, float Scale=1.0f, WColor& Color=WColor::White);
	Vector GetViewSize()
	{
		return ViewSize;
	}
	
protected:
	Vector ViewSize;
	
	//	GLuint SpriteIB;
	
	
	
	const char* String_Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-=_+`~[]\\{}|;':\",./<>? ";
	const int String_TexSize = 256;
	const float String_InvTexSize = 1.0f / (float)String_TexSize;
	const int String_CharX = 18;
	const int String_CharY = 35;
	const int String_NumCharsX = String_TexSize / String_CharX;
	const int String_NumCharsY = String_TexSize / String_CharY;

};

