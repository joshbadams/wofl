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
	uint Texture;
	float UVScaleBias[4];
	
	WoflImage(const char* TextureName, float U, float V, float SizeX, float SizeY);
	WoflImage(const char* AtlasTextureName);
	
string _Name;
protected:
	
	void Initialize(const char* TextureName, float U, float V, float SizeX, float SizeY);
	
	// tracks all loaded textures so we don't reload images
	struct Info
	{
		uint Texture;
		uint Width, Height;
	};
	static map<string, WoflImage::Info> LoadedTextures;
};

