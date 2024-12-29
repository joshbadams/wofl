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

Organ = Item:new {
	type = "organ",
	hp = 0,
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
	},

	[300] = Organ:new { name = "Heart", sell=6000, buy=6600, hp = 200 },
	[301] = Organ:new { name = "Eyes (2)", sell=5000, buy=6500, hp = 150 },
	[302] = Organ:new { name = "Lungs (2)", sell=3000, buy=3300, hp = 150 },
	[303] = Organ:new { name = "Stomach", sell=1500, buy=1650, hp = 100 },
	
	[304] = Organ:new { name = "Liver", sell=1250, buy=1375, hp = 75 },
	[305] = Organ:new { name = "Kidneys (2)", sell=1050, buy=1155, hp = 75 },
	[306] = Organ:new { name = "Gall Bladder", sell=1050, buy=1155, hp = 75 },
	[307] = Organ:new { name = "Pancreas", sell=500, buy=550, hp = 75 },
	
	[308] = Organ:new { name = "Legs (2)", sell=300, buy=330, hp = 50 },
	[309] = Organ:new { name = "Arms (2)", sell=300, buy=330, hp = 50 },
	[310] = Organ:new { name = "Tpngue", sell=150, buy=165, hp = 25 },
	[311] = Organ:new { name = "Larynx", sell=150, buy=165, hp = 25 },

	[312] = Organ:new { name = "Nose", sell=150, buy=165, hp=25 },
	[313] = Organ:new { name = "Ears (2)", sell=100, buy=110, hp=25 },
	[314] = Organ:new { name = "Intestine (large)", sell=50, buy=55, hp=10 },
	[315] = Organ:new { name = "Intestine (small)", sell=50, buy=55, hp=10 },

	[316] = Organ:new { name = "Spleen", sell=45, buy=78, hp=10 },
	[317] = Organ:new { name = "Bone Marrow", sell=45, buy=78, hp=10 },
	[318] = Organ:new { name = "Spinal Fluid", sell=30, buy=33, hp=10 },
	[319] = Organ:new { name = "Appendix", sell=3, buy=3, hp=10 },
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





