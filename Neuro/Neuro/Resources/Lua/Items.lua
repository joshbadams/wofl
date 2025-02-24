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
	scope = nil, -- where it's usable, like deck, site, etc
}

FakeSoftware = Software:new {
	scope = "fake",
}

Comlink = Software:new {
	name = "Comlink",
	scope = "jack",
	desc = "Database access software"
}

Skill = Item:new {
	type = "skill",
	scope = nil, -- where it's usable, like room, site, etc
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
	[2] = Item:new {
		name = "caviar"
	},
	[3] = Item:new {
		name = "sake"
	},
	[4] = Item:new {
		name = "guest pass",
		cost = 0
	},

	[100] = Deck:new { capacity =  5, buggy = true,  cyberspace = false, manufacturer = "Yamamitsu", name = "UXB" },
	[101] = Deck:new { capacity =  6, buggy = false, cyberspace = false, manufacturer = "Yamamitsu", name = "XXB" },
	[102] = Deck:new { capacity = 10, buggy = false, cyberspace = false, manufacturer = "Yamamitsu", name = "ZXB" },
	[103] = Deck:new { capacity = 10, buggy = false, cyberspace = false, manufacturer = nil, name = "Blue Light Special" },
	[104] = Deck:new { capacity =  5, buggy = false, cyberspace = false, manufacturer = "Ausgezeichnet", name = "188 BJB" },
	[105] = Deck:new { capacity = 11, buggy = false, cyberspace = false, manufacturer = "Ausgezeichnet", name = "350 SL" },
	[106] = Deck:new { capacity = 15, buggy = false, cyberspace = false, manufacturer = "Ausgezeichnet", name = "440 SDI" },
	[107] = Deck:new { capacity = 20, buggy = false, cyberspace = false, manufacturer = "Ausgezeichnet", name = "550 GT" },
	[108] = Deck:new { capacity =  5, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Hiki-Gaeru" },
	[109] = Deck:new { capacity = 10, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Gaijin" },
	[110] = Deck:new { capacity = 12, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Bushido" },
	[111] = Deck:new { capacity = 15, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Edokko" },
	[112] = Deck:new { capacity = 18, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Katana" },
	[113] = Deck:new { capacity = 20, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Tofu" },
	[114] = Deck:new { capacity = 24, buggy = false, cyberspace = false, manufacturer = "Moriyama", name = "Shogun" },
	[115] = Deck:new { capacity = 10, buggy = false, cyberspace = false, manufacturer = nil, name = "Ninja 2000" },
	[116] = Deck:new { capacity = 12, buggy = false, cyberspace = false, manufacturer = nil, name = "Ninja 3000" },
	[117] = Deck:new { capacity = 20, buggy = false, cyberspace = false, manufacturer = nil, name = "Ninja 4000" },
	[118] = Deck:new { capacity = 25, buggy = false, cyberspace = false, manufacturer = nil, name = "Ninja 5000" },
	[119] = Deck:new { capacity = 25, buggy = false, cyberspace = false, manufacturer = nil, name = "Samurai Seven" },
	[120] = Deck:new { capacity = 11, buggy = false, cyberspace = false, manufacturer = "Ono-Sendai", name = "Cyberspace II" },
	[121] = Deck:new { capacity = 15, buggy = false, cyberspace = false, manufacturer = "Ono-Sendai", name = "Cyberspace III" },
	[122] = Deck:new { capacity = 20, buggy = false, cyberspace = false, manufacturer = "Ono-Sendai", name = "Cyberspace VI" },
	[123] = Deck:new { capacity = 25, buggy = false, cyberspace = false, manufacturer = "Ono-Sendai", name = "Cyberspace VII" },

	
	[200] = Comlink:new {
		cost = 100,
		version = 1,
	},
	[201] = Comlink:new {
		cost = 0,
		version = 2,
	},
	[202] = Comlink:new {
		cost = 0,
		version = 3,
	},
	[203] = Comlink:new {
		cost = 0,
		version = 4,
	},
	[204] = Comlink:new {
		cost = 0,
		version = 5,
	},
	[205] = Comlink:new {
		cost = 0,
		version = 6,
	},
	[206] = Software:new {
		name = "Scout",
		version = 1,
		scope = "site",
	},
	[210] = Software:new {
		name = "BattleChess",
		version = 2,
		scope = "site",
	},
	[280] = FakeSoftware:new {
		name = "Mindbender",
		version = 3,
	},
	[281] = FakeSoftware:new {
		name = "Chaos Videosoft",
		version = 3,
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
	
	[400] = Skill:new { name = "CopTalk", cost = 100, scope = "room" },
	[401] = Skill:new { name = "Cryptology", cost = 0, scope = "anytime", box = "DecodeBox" },
	[402] = Skill:new { name = "Hwardware Repair", cost = 1000, scope = "room" },
}

CryptoDecode = {
	['dumbo'] = { result = "ROMCARDS", level = 1 },
	['vulcan'] = { result = "dunno", level = 2 },
	
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





