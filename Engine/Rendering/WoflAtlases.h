//
//  WoflAtlases.hpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#pragma once


class WoflAtlases
{
public:
	static void LoadAtlas(const char* AtlasName);

protected:
	friend class WoflImage;
	
	struct SubImageInfo
	{
		float U, V, SizeX, SizeY;
	};

	static map<string, string> SubImageToAtlasMap;
	static map<string, SubImageInfo> SubImageToInfoMap;
};


