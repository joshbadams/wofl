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

std::map<std::string, WoflImage::Info> WoflImage::LoadedTextures;

WoflImage::WoflImage(const std::string& TextureName, float U, float V, float SizeX, float SizeY)
	: TileX(1.0f)
	, TileY(1.0f)
{
_Name = TextureName;
	Initialize(TextureName, U, V, SizeX, SizeY);
}

WoflImage::WoflImage(const std::string& AtlasTextureName)
	: TileX(1.0f)
	, TileY(1.0f)
{
_Name = AtlasTextureName;
	std::string AtlasName = WoflAtlases::SubImageToAtlasMap[AtlasTextureName];
	WoflAtlases::SubImageInfo Info = WoflAtlases::SubImageToInfoMap[AtlasTextureName];
	
	Initialize(AtlasName, Info.U, Info.V, Info.SizeX, Info.SizeY);
}

void WoflImage::TileImage(float InTileX, float InTileY)
{
	UVScaleBias[0] /= TileX;
	UVScaleBias[1] /= TileY;

	TileX = InTileX;
	TileY = InTileY;

	UVScaleBias[0] *= TileX;
	UVScaleBias[1] *= TileY;
}

void WoflImage::Initialize(const std::string& TextureName, float U, float V, float SizeX, float SizeY)
{
	// look for texture already loaded
	std::map<std::string, WoflImage::Info>::iterator ExistingIterator = LoadedTextures.find(TextureName);
	
	// did it fail to find?
	WoflImage::Info Info;
	if (ExistingIterator == LoadedTextures.end())
	{
		// load in the texture!
		std::string FinalTextureName = TextureName + ".png";
//		FinalTextureName = Utils::File->GetResourcePath(FinalTextureName.c_str());
		void* ImageContents = Utils::File->LoadPNGToAllocatedBuffer(FinalTextureName.c_str(), Info.Width, Info.Height);
		
		if (ImageContents == NULL)
		{
			WLOG("Failed to find texture '%s'\n", TextureName.c_str());
			Texture = 0;
			return;
		}
		
		Info.Texture = WoflRenderer::Renderer->CreateUncompressedTexture(Info.Width, Info.Height, ImageContents);
		
		// Release the image data
		free(ImageContents);
		
		// store the texture info to get later
		LoadedTextures[TextureName] = Info;
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

