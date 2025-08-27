//
//  Textbox.cpp
//  Neuro
//
//  Created by Josh Adams on 4/10/23.
//

#include "Gridbox.h"
#include "Textbox.h"
#include "NeuroState.h" // replace with InterfaceDelegate.h or similar

const float InputDelay = 0.2f;
void GridEntry::FromLua(LuaRef Ref)
{
	Lua* L = Ref->LuaSystem;
	LuaEntry = Ref;

	L->GetIntValue(Ref, "x", X);
	L->GetIntValue(Ref, "y", Y);
	L->GetIntValue(Ref, "wrap", WrapWidth);
	L->GetStringValue(Ref, "text", Text);
	L->GetIntValue(Ref, "clickId", ClickId);
	std::string KeyStr;
	L->GetStringValue(Ref, "key", KeyStr);
	if (KeyStr.length() == 1)
	{
		char Shortcut = KeyStr[0];
		if (Shortcut >= '0' && Shortcut <= '9')
		{
			Key = (WoflKeys)((int)WoflKeys::Zero + Shortcut - '0');
		}
		else if (Shortcut >= 'A' && Shortcut <= 'Z')
		{
			Key = (WoflKeys)((int)WoflKeys::A + Shortcut - 'A');
		}
		if (Shortcut >= 'a' && Shortcut <= 'z')
		{
			Key = (WoflKeys)((int)WoflKeys::A + Shortcut - 'a');
		}
	}
	
	L->GetStringValue(Ref, "entryTag", EntryTag);
	L->GetBoolValue(Ref, "numeric", bNumericEntry);
	L->GetBoolValue(Ref, "multiline", bMultilineEntry);
	if (bMultilineEntry && WrapWidth == 0)
	{
		WrapWidth = -1;
	}

	L->GetFunctionValue(Ref, "onClick", OnClick);
	L->GetFunctionValue(Ref, "onClickEntry", OnClickEntry);
}

Gridbox::Gridbox()
	: Gridbox(0, 0, 0, 0, 0, WColor::Black)
{
	
}

Gridbox::Gridbox(float X, float Y, float SizeX, float SizeY, int Tag, WColor Color)
	: Ninebox(Ninebox::Basic, X, Y, SizeX, SizeY, Tag, Color)
	, TextColor(Color)
{
	Init();
}

Gridbox::Gridbox(int Tag, WColor Color)
	: Ninebox(Ninebox::NoBorder, 0, 0, 0, 0, Tag, Color)
	, TextColor(Color)
{
	Init();
}

void Gridbox::Init()
{
	TextEntryIndex = -1;
	bIgnoreUntilNextUp = false;

	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	GridsX = ClientSize.X / GRID_X;
	GridsY = ClientSize.Y / GRID_Y;
	SetClickEnabled(true);
	
	// skip one line
	if (Messagebox == nullptr)
	{
		Messagebox = new Textbox(nullptr, ClientLocation.X, ClientLocation.Y + GRID_Y, ClientSize.X, ClientSize.Y - (ClientLocation.Y + GRID_Y), 0, true, true, WColor::Black, GRID_Y);
		Messagebox->SetInterfaceDelegate(this);
	}
	else
	{
		Messagebox->SetPosition(Vector(ClientLocation.X, ClientLocation.Y + GRID_Y));
		Messagebox->SetSize(Vector(ClientSize.X, ClientSize.Y - (ClientLocation.Y + GRID_Y)));
	}
	
	if (LuaBox)
	{
		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnOpenBox", GridsX, GridsY, this);
	}

	Update();
}

void Gridbox::Open(LuaRef InLuaBox, bool bOverlayDialog)
{
	LuaBox = InLuaBox;

	int X, Y, W, H;
	if (bOverlayDialog)
	{
		X = 0;
		Y = GRID_Y;
		W = GRID_X * 30 + 2;
		H = GRID_Y + 2;
	}
	else
	{
		LuaBox->LuaSystem->GetIntValue(LuaBox, "x", X);
		LuaBox->LuaSystem->GetIntValue(LuaBox, "y", Y);
		LuaBox->LuaSystem->GetIntValue(LuaBox, "w", W);
		LuaBox->LuaSystem->GetIntValue(LuaBox, "h", H);
	}
	
	// resize to match
	Move(X, Y, W, H);

	Init();
}

void Gridbox::RefreshUI()
{
	Update();
}

bool Gridbox::MatchesLuaBox(LuaRef Box)
{
	return Box == LuaBox;
}

void Gridbox::CustomPostChildrenRender()
{
	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	Vector BaseLoc = GetPosition() + ClientLocation;
	
	for (const GridEntry& Entry : Entries)
	{
		string Text = Entry.Text;
		if (Entry.EntryTag != "")
		{
			Text = Text + "<";
		}
		WColor EntryColor = TextColor;
		if (Entry.ClickId != 0 && ActivatingClickId == Entry.ClickId)
		{
			if (ActivatingCountdown > (InputDelay * 0.75) || ActivatingCountdown <= InputDelay * 0.25)
			{
				EntryColor.R = 1.0f - EntryColor.R;
				EntryColor.G = 1.0f - EntryColor.G;
				EntryColor.B = 1.0f - EntryColor.B;
				EntryColor.A = -1.0f;
			}
		}
		
		if (Entry.WrapWidth != 0)
		{
			int Wrap = Entry.WrapWidth < 0 ? (ClientSize.X + Entry.WrapWidth * GRID_X) : Entry.WrapWidth * GRID_X;
			std::vector<std::string> Lines = SplitLines(Text, Wrap);
			int Index = 0;
			for (const std::string& Line : Lines)
			{
				WoflRenderer::Renderer->DrawString(Line.c_str(), BaseLoc + Vector(Entry.X * GRID_X, (Entry.Y + Index) * GRID_Y), 1.0f, EntryColor);
				Index++;
			}
		}
		else
		{
			WoflRenderer::Renderer->DrawString(Text.c_str(), BaseLoc + Vector(Entry.X * GRID_X, Entry.Y * GRID_Y), 1.0f, EntryColor);
		}
	}
}

void Gridbox::SetupTextEntry(const GridEntry& Entry)
{
	TextEntryIndex = (int)Entries.size();
	Entries.push_back(Entry);
}


void Gridbox::Tick(float DeltaTime)
{
	if (ActivatingCountdown > 0)
	{
		ActivatingCountdown -= DeltaTime;
		if (ActivatingCountdown <= 0)
		{
			for (GridEntry& Entry : Entries)
			{
				if (Entry.ClickId == ActivatingClickId)
				{
					OnClickEntry(Entry);
					break;
				}
			}
			ActivatingCountdown = 0;
			ActivatingClickId = 0;
		}
	}
}

void Gridbox::OnInput(const Vector& ScreenLocation, int RepeatIndex)
{
	if (ActivatingClickId != 0)
	{
		return;
	}
	Vector ClientLocation;
	Vector ClientSize;
	GetClientGeometry(ClientLocation, ClientSize);

	Vector GridLocation = ScreenLocation - (GetPosition() + ClientLocation);
	int X = GridLocation.X / GRID_X;
	int Y = GridLocation.Y / GRID_Y;

//	WLOG("Grid: %d, %d\n", X, Y);
	
	bool bWasHandled = false;
	for (GridEntry& Entry : Entries)
	{
		bool bWantsInput = Entry.ClickId != 0 || Entry.OnClick || Entry.OnClickEntry;
		if (bWantsInput && Y == Entry.Y && X >= Entry.X && X < Entry.X + Entry.Text.length())
		{
			ActivatingClickId = Entry.ClickId;
			ActivatingCountdown = InputDelay;
			bWasHandled = true;
			break;
		}
	}
	
	// allow for full-widget click/space to continue type things
	if (!bWasHandled)
	{
//		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnGenericContinueInput");
		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "HandleMouseInput", X, Y);
		Update();
	}
}

bool Gridbox::OnKey(const KeyEvent& Event)
{
	if (bIgnoreUntilNextUp)
	{
		if (Event.Type == KeyType::Up)
		{
			bIgnoreUntilNextUp = false;
		}
		return true;
	}
	
	if (ActivatingClickId != 0)
	{
		 return true;
	}

	if (Event.Type != KeyType::Down)
	{
		return true;
	}
	// we only want to handle char events and keydown of some special keycodes
	//if (Event.Char == 0 && Event.KeyCode != WoflKeys::Enter && Event.KeyCode != WoflKeys::Backspace && Event.KeyCode != WoflKeys::Escape)
	//{
	//	return true;
	//}
	
	if (TextEntryIndex != -1)
	{
		GridEntry& TextEntry = Entries[TextEntryIndex];
		
		if ((Event.Char >= '0' && Event.Char <= '9') || (!TextEntry.bNumericEntry && isprint(Event.Char)))
		{
			Entries[TextEntryIndex].Text += Event.Char;
		}
		// delete
		else if (Event.KeyCode == WoflKeys::Backspace)
		{
			if (Entries[TextEntryIndex].Text.length() > 0)
			{
				Entries[TextEntryIndex].Text = Entries[TextEntryIndex].Text.substr(0, Entries[TextEntryIndex].Text.size() - 1);
			}
		}
		// complete entry (enter for single line, esc for multiline)
		else if ((Event.KeyCode == WoflKeys::Enter && !TextEntry.bMultilineEntry) ||
				 (Event.KeyCode == WoflKeys::Escape && TextEntry.bMultilineEntry))
		{
			int Index = TextEntryIndex;
			TextEntryIndex = -1;
			OnTextEntryComplete(Entries[Index].Text, Entries[Index].EntryTag);
			bIgnoreUntilNextUp = true;
		}
		// enter in mult line
		else if (Event.KeyCode == WoflKeys::Enter)
		{
			Entries[TextEntryIndex].Text += '\n';
		}
		// cancel (escape for single line_
		else if (Event.KeyCode == WoflKeys::Escape)
		{
			int Index = TextEntryIndex;
			TextEntryIndex = -1;
			OnTextEntryCancelled(Entries[Index].EntryTag);
			bIgnoreUntilNextUp = true;
		}
	}
	// char events are only for text entry
	else if (Event.Type == KeyType::Down && Event.KeyCode != WoflKeys::None)
	{
		for (GridEntry& Entry : Entries)
		{
			if (Entry.Key == Event.KeyCode)
			{
				if (Entry.ClickId == 0)
				{
					OnClickEntry(Entry);
				}
				else
				{
					ActivatingClickId = Entry.ClickId;
					ActivatingCountdown = InputDelay;
				}
				bIgnoreUntilNextUp = true;
				break;
			}
		}
		if (!bIgnoreUntilNextUp)
		{
			LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "HandleKeyInput", (int)Event.KeyCode, (int)Event.Type);
			Update();
			bIgnoreUntilNextUp = true;

//			if (Event.Type == KeyType::Down && (Event.KeyCode == WoflKeys::Enter || Event.KeyCode == WoflKeys::Space || Event.KeyCode == WoflKeys::Escape))
			{
				//			OnGenericContinueInput();
			}
		}
	}
	

	return true;
}

void Gridbox::OnTextEntryComplete(const string& Text, const string& Tag)
{
	LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnTextEntryComplete", Text.c_str(), Tag.c_str());
	Update();
}

void Gridbox::OnTextEntryCancelled(const string& Tag)
{
	LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnTextEntryCancelled", Tag.c_str());
	Update();
}

void Gridbox::OnGenericContinueInput()
{
	LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnGenericContinueInput");
	Update();
}

void Gridbox::MessageComplete()
{
//	bIsShowingMessageList = true;
//	bIsShowingMessage = false;
	
	LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "OnMessageComplete");
	
//	UpdateMessages();
	Update();
}

void Gridbox::Update()
{
	// child class would need to handle this
	if (LuaBox == nullptr)
	{
		return;
	}
	
	Entries.clear();
	Messagebox->RemoveFromParent();

	// do we need full screen message?
	int DetailsIndex;
	LuaBox->LuaSystem->GetIntValue(LuaBox, "detailsIndex", DetailsIndex);
	if (DetailsIndex > 0)
	{
		std::string DetailsString;
		LuaBox->LuaSystem->CallFunction_Return(LuaBox, "GetDetailsString", DetailsString);
		Messagebox->SetText(DetailsString, true);
		AddChild(Messagebox);
	}
	
	LuaRef EntriesTable;
	vector<LuaRef> LuaEntries;
	LuaBox->LuaSystem->CallFunction_Return(LuaBox, "GetEntries", EntriesTable);
	if (EntriesTable != nullptr)
	{
		LuaBox->LuaSystem->GetTableValues(EntriesTable, "", LuaEntries);
	}
	else
	{
		WLOG("Tailed to get an entries array. LIkely an exception in Lua");
	}
	for (LuaRef& LuaEntry : LuaEntries)
	{
		GridEntry Entry;
		Entry.FromLua(LuaEntry);
		
		if (Entry.EntryTag != "")
		{
			SetupTextEntry(Entry);
		}
		else
		{
			Entries.push_back(Entry);
		}
	}
}

void Gridbox::OnClickEntry(GridEntry& Entry)
{
	if (Entry.OnClick != nullptr)
	{
		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, Entry.OnClick);
	}
	else if (Entry.OnClickEntry != nullptr)
	{
		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, Entry.OnClickEntry, Entry.LuaEntry);
	}
	else
	{
		LuaBox->LuaSystem->CallFunction_NoReturn(LuaBox, "HandleClickedGridEntry", Entry.ClickId);
	}
	
	Update();
}

