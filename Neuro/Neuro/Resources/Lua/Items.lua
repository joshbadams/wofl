Item = LuaObj:new {
	name = "",
	cost = 0,
	type = "custom"
}

Deck = Item:new {
	type = "deck",
	quality = 1,
	cyberspace = false,
	capacity = 0
}

Software = Item:new {
	type = "software",
	level = 0,
	desc = "",
}

Items = {
	[0] = Item:new {
		name = "Credits",
	},
	[1] = Item:new {
		name = "pawn ticket"
	},
	
	[100] = Deck:new {
		name = "UXB",
		capacity = 5,
	},
	
	
	[200] = Software:new {
		name = "Comlink 1.0",
		cast = 100,
		level = 1,
		desc = "Database access software"
	}
}

function GetItemDesc(invItem)
	
	if (inventory[invIndex] == 0) then
		return string.format("Credits %d", money)
	end

	return Items[inventory[invItem]].name
end
