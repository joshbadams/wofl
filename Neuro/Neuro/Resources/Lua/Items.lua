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
	version = 0,
	desc = "",
}

Comlink = Software:new {
	name = "Comlink",
	subtype = "comlink",
	desc = "Database access software"
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
	
	[200] = Comlink:new {
		cast = 100,
		version = 1,
	},
	[201] = Comlink:new {
		cast = 1,
		version = 2,
	},
	[210] = Software:new {
		name = "BattleChess",
		version = 2,
	}
}

function GetItemDesc(itemId)

	if (itemId == 0) then
		return string.format("Credits %d", s.money)
	end

	local item = Items[itemId]

	if (item.type == "software") then
		return string.format("%s %d.0", item.name, item.version)
	end

	return item.name
end

function GetListItemDesc(itemId, width)
	local item = Items[itemId]

	if (item.type ~= "software") then
		return GetItemDesc(itemId)
	end

	local desc = item.name

	-- pad out spacing to right align version
	local ver = string.format("%d.0", item.version)
	local len = string.len(desc) + string.len(ver)
	local spaces = width - len

	for i=1,spaces do
		desc = desc .. ' '
	end

	return desc .. ver
end





