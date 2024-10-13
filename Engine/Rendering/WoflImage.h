//
//  WoflImage.hpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#pragma once

//#include "WoflRenderer.h"

class WoflImage
{
public:
	unsigned int Texture;
	float UVScaleBias[4];
	
	WoflImage(const std::string& TextureName, float U, float V, float SizeX, float SizeY);
	WoflImage(const std::string& AtlasTextureName);

	void TileImage(float InTileX, float InTileY);
	
std::string _Name;
protected:

	float TileX, TileY;
	
	void Initialize(const std::string& TextureName, float U, float V, float SizeX, float SizeY);
	
	// tracks all loaded textures so we don't reload images
	struct Info
	{
		unsigned int Texture;
		unsigned int Width, Height;
	};
	static std::map<std::string, WoflImage::Info> LoadedTextures;
};

