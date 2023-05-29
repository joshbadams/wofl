//
//  Ninebox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/12/23.
//

#include "Ninebox.h"
#include "Textbox.h"
#include <Wofl/Wofl.h>

const char* Ninebox::Basic[] =
{
   "TopLeft", "TopCenter", "TopRight",
   "LeftCenter", "Center", "RightCenter",
   "BottomLeft", "BottomCenter", "BottomRight",
};

const float BSize = 16;

Ninebox::Ninebox(const char* Config[], float X, float Y, float SizeX, float SizeY, int Tag, WColor TextColor)
	: WoflSprite(X, Y, SizeX, SizeY, Tag)
{
	for (int Index = 0; Index < 9; Index++)
	{
		Sprites[Index] = new WoflSprite(0, 0, 0, 0, Tag);
		Sprites[Index]->AddImage(new WoflImage(Config[Index], 0, 0, 1, 1));
		AddChild(Sprites[Index]);
	}
	
	Text = new Textbox(nullptr, 0, 0, 0, 0, Tag, false, false, TextColor);
	Sprites[Center]->AddChild(Text);
	
	Move(X, Y, SizeX, SizeY);
}

void Ninebox::GetClientGeometry(Vector& Position, Vector& Size)
{
	Position = Sprites[Center]->GetRelativePosition();
	Size = Sprites[Center]->GetSize();
}


static void TileImage(WoflSprite* Sprite, bool bTileX, bool bTileY)
{
	WoflImage* Image = Sprite->GetImage();
//	Vector TextureSize = WoflRenderer::Renderer->GetTextureSize(Image->Texture);
	
	float TileX = 1.0f;
	float TileY = 1.0f;
	if (bTileX)
	{
		TileX = Sprite->GetSize().X / BSize;
	}
	if (bTileY)
	{
		TileY = Sprite->GetSize().Y / BSize;
	}
	Image->TileImage(TileX, TileY);
}

void Ninebox::Move(float X, float Y, float SizeX, float SizeY)
{
	SetRelativePosition({X, Y});
	SetSize({SizeX, SizeY});
	
	Sprites[TopLeft]->SetRelativePosition({0, 0});
	Sprites[TopLeft]->SetSize({BSize, BSize});

	Sprites[TopCenter]->SetRelativePosition({BSize, 0});
	Sprites[TopCenter]->SetSize({SizeX - 2 * BSize, BSize});
	TileImage(Sprites[TopCenter], true, false);

	Sprites[TopRight]->SetRelativePosition({SizeX - BSize, 0});
	Sprites[TopRight]->SetSize({BSize, BSize});

	Sprites[LeftCenter]->SetRelativePosition({0, BSize});
	Sprites[LeftCenter]->SetSize({BSize, SizeY - 2 * BSize});
	TileImage(Sprites[LeftCenter], false, true);

	Sprites[Center]->SetRelativePosition({BSize, BSize});
	Sprites[Center]->SetSize({SizeX - 2 * BSize, SizeY - 2 * BSize});
	TileImage(Sprites[Center], true, true);

	Sprites[RightCenter]->SetRelativePosition({SizeX - BSize, BSize});
	Sprites[RightCenter]->SetSize({BSize, SizeY - 2 * BSize});
	TileImage(Sprites[RightCenter], false, true);

	Sprites[BottomLeft]->SetRelativePosition({0, SizeY - BSize});
	Sprites[BottomLeft]->SetSize({BSize, BSize});

	Sprites[BottomCenter]->SetRelativePosition({BSize, SizeY - BSize});
	Sprites[BottomCenter]->SetSize({SizeX - 2 * BSize, BSize});
	TileImage(Sprites[BottomCenter], true, false);

	Sprites[BottomRight]->SetRelativePosition({SizeX - BSize, SizeY - BSize});
	Sprites[BottomRight]->SetSize({BSize, BSize});

	Text->SetSize(Sprites[Center]->GetSize());
}


