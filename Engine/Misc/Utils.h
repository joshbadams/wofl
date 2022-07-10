//
//  Utils.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

class Utils
{
public:
	
	static class WoflFile* File;
	static class WoflInput* Input;
	static class WoflPlatform* Platform;
};

// now that the Utils class is defined, we can include the classes it uses that may use it
#include "WoflFile.h"
#include "WoflInput.h"
#include "WoflPlatform.h"



#define ARRAY_COUNT(x) (sizeof(x) / sizeof(x[0]))
#define GLCHECK(x) x; { GLenum E = glGetError(); if (E) printf("Error %d with '%s'\n", E, #x); }

