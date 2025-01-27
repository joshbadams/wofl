//
//  Ninebox.hpp
//  Neuro
//
//  Created by Josh Adams on 4/12/23.
//

#ifndef Ninebox_hpp
#define Ninebox_hpp

#include <Wofl/Wofl.h>

const int TopLeft=0;
const int TopCenter=1;
const int TopRight=2;
const int LeftCenter=3;
const int Center=4;
const int RightCenter=5;
const int BottomLeft=6;
const int BottomCenter=7;
const int BottomRight=8;

class Ninebox : public WoflSprite
{
public:
	static const char* Basic[];
	static const char* Thinking[];

	class Textbox* Text;
	
	Ninebox(const char* Config[], float X, float Y, float SizeX, float SizeY, int Tag, WColor TextColor=WColor::Black);
	
	void Move(float X, float Y, float SizeX, float SizeY);
	
	void GetClientGeometry(Vector& Position, Vector& Size);
	
	virtual std::string Describe() override
	{
		return std::string("Ninebox");
	}

	
protected:
	WoflSprite* Sprites[9];
	
};

#endif /* Ninebox_hpp */
