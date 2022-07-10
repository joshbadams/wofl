//
//  WoflImage.cpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflImage.h"
#include "WoflAtlases.h"
#include "WoflRenderer.h"

map<string, WoflImage::Info> WoflImage::LoadedTextures;

WoflImage::WoflImage(const char* TextureName, float U, float V, float SizeX, float SizeY)
{
_Name = TextureName;
	Initialize(TextureName, U, V, SizeX, SizeY);
}


WoflImage::WoflImage(const char* AtlasTextureName)
{
_Name = AtlasTextureName;
	string AtlasName = WoflAtlases::SubImageToAtlasMap[AtlasTextureName];
	WoflAtlases::SubImageInfo Info = WoflAtlases::SubImageToInfoMap[AtlasTextureName];
	
	Initialize(AtlasName.c_str(), Info.U, Info.V, Info.SizeX, Info.SizeY);
	
}

void WoflImage::Initialize(const char* TextureName, float U, float V, float SizeX, float SizeY)
{
	// look for texture already loaded
	string TextureNameStr(TextureName);
	
	map<string, WoflImage::Info>::iterator ExistingIterator = LoadedTextures.find(TextureNameStr);
	
	// did it fail to find?
	WoflImage::Info Info;
	if (ExistingIterator == LoadedTextures.end())
	{
		// load in the texture!
		void* ImageContents = Utils::File->LoadPNGToAllocatedBuffer(TextureName, Info.Width, Info.Height);
		
		if (ImageContents == NULL)
		{
			WLOG("Failed to find texture '%s'\n", TextureName);
			Texture = 0;
			return;
		}
		
		Info.Texture = WoflRenderer::Renderer->CreateUncompressedTexture(Info.Width, Info.Height, ImageContents);
		
		// Release the image data
		free(ImageContents);
		
		// store the texture info to get later
		LoadedTextures[TextureNameStr] = Info;
	}
	else
	{
		// just point to the existint texture
		Info = ExistingIterator->second;
	}
	
	// cache the texgture ID from the info
	Texture = Info.Texture;
	
	// initialize UV stuff
	UVScaleBias[0] = SizeX <= 1.0f ? SizeX : SizeX / (float)Info.Width;
	UVScaleBias[1] = SizeY <= 1.0f ? SizeY : SizeY / (float)Info.Height;
	UVScaleBias[2] = U <= 1.0f ? U : U / (float)Info.Width;
	UVScaleBias[3] = V <= 1.0f ? V : V / (float)Info.Height;
}

