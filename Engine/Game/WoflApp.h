//
//  WoflApp.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_WoflApp_h
#define Wofl_WoflApp_h



// It is expected that every game implements this function in a .cpp file somewhere
// This will allow the platform code to call one function, and the project/makefile will determine
// which function is compiled in
extern class WoflGame* GlobalGameInitialization();


class WoflApplication
{
public:
	// initialize the whole thing
	static void Initialize();
	
	// called by platform to tick the world
	static void Tick();
	
	// called by the platform to render
	static void Render();
};

#endif
