//
//  WoflAtlases.cpp
//  Wofl
//
//  Created by Josh on 6/15/16.
//  Copyright © 2016 Josh. All rights reserved.
//

#include "WoflAtlases.h"
#include "json.h"

map<string, string> WoflAtlases::SubImageToAtlasMap;
map<string, WoflAtlases::SubImageInfo> WoflAtlases::SubImageToInfoMap;

void WoflAtlases::LoadAtlas(const char* AtlasName)
{
	std::string AtlasMetaPath = Utils::File->GetResourcePath((string(AtlasName) + ".json").c_str());
	std::string AtlasMetaContents = Utils::File->LoadFileToString(AtlasMetaPath.c_str());
	
	// parse a string using a Reader object
	Json::Reader Reader;
	Json::Value Root(Json::objectValue);
	
	// convert into an object hierarchy
	Reader.parse(AtlasMetaContents, Root, false);
	
	// get the meta object
	Json::Value MetaObj = Root["meta"];
	Json::Value SizeObj = MetaObj["size"];
	float Width = SizeObj["w"].asFloat();
	float Height = SizeObj["h"].asFloat();
	
	// get the frames array
	Json::Value FramesArray = Root["frames"];
	
	// walk over array
	for (const Json::Value& FrameObj : FramesArray)
	{
		// get the filename, and pull off any extension
		string Filename = FrameObj["filename"].asString();
		stringstream FilenameStream(Filename);
		string ImageName;
		std::getline(FilenameStream, ImageName, '.');
		
		SubImageToAtlasMap[ImageName] = AtlasName;
		
		// get the bounds of the image
		Json::Value RectObj = FrameObj["frame"];
		
		SubImageInfo Info;
		Info.U = RectObj["x"].asFloat() / Width;
		Info.V = RectObj["y"].asFloat() / Height;
		Info.SizeX = RectObj["w"].asFloat() / Width;
		Info.SizeY = RectObj["h"].asFloat() / Height;
		
		SubImageToInfoMap[ImageName] = Info;
	}
}
