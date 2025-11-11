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
	[5] = Item:new {
		name = "joystick",
		cost = 20
	},
	[6] = Item:new {
		name = "Security Pass",
		cost = 4000
	},
	
	[100] = Deck:new { capacity =  5, buggy = true,  cyberspace = false, cost = 0,     manufacturer = "Yamamitsu", name = "UXB" },
	[101] = Deck:new { capacity =  6, buggy = false, cyberspace = false, cost = 0,     manufacturer = "Yamamitsu", name = "XXB" },
	[102] = Deck:new { capacity = 10, buggy = false, cyberspace = false, cost = 7200,  manufacturer = "Yamamitsu", name = "ZXB" },
	[103] = Deck:new { capacity = 10, buggy = false, cyberspace = false, cost = 1000,  manufacturer = nil, name = "Blue Light Special" },
	[104] = Deck:new { capacity =  5, buggy = false, cyberspace = false, cost = 0,     manufacturer = "Ausgezeichnet", name = "188 BJB" },
	[105] = Deck:new { capacity = 11, buggy = false, cyberspace = false, cost = 7500,  manufacturer = "Ausgezeichnet", name = "350 SL" },
	[106] = Deck:new { capacity = 15, buggy = false, cyberspace = false, cost = 0,     manufacturer = "Ausgezeichnet", name = "440 SDI" },
	[107] = Deck:new { capacity = 20, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Ausgezeichnet", name = "550 GT" },
	[108] = Deck:new { capacity =  5, buggy = false, cyberspace = false, cost = 2000,  manufacturer = "Moriyama", name = "Hiki-Gaeru" },
	[109] = Deck:new { capacity = 10, buggy = false, cyberspace = false, cost = 3600,  manufacturer = "Moriyama", name = "Gaijin" },
	[110] = Deck:new { capacity = 12, buggy = false, cyberspace = false, cost = 7700,  manufacturer = "Moriyama", name = "Bushido" },
	[111] = Deck:new { capacity = 15, buggy = false, cyberspace = false, cost = 10000, manufacturer = "Moriyama", name = "Edokko" },
	[112] = Deck:new { capacity = 18, buggy = false, cyberspace = false, cost = 0,     manufacturer = "Moriyama", name = "Katana" },
	[113] = Deck:new { capacity = 20, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Moriyama", name = "Tofu" },
	[114] = Deck:new { capacity = 24, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Moriyama", name = "Shogun" },
	[115] = Deck:new { capacity = 10, buggy = false, cyberspace = false, cost = 0,     manufacturer = nil, name = "Ninja 2000" },
	[116] = Deck:new { capacity = 12, buggy = false, cyberspace = false, cost = 8400,  manufacturer = nil, name = "Ninja 3000" },
	[117] = Deck:new { capacity = 20, buggy = false, cyberspace = true,  cost = 0,     manufacturer = nil, name = "Ninja 4000" },
	[118] = Deck:new { capacity = 25, buggy = false, cyberspace = true,  cost = 0,     manufacturer = nil, name = "Ninja 5000" },
	[119] = Deck:new { capacity = 25, buggy = false, cyberspace = true,  cost = 0,     manufacturer = nil, name = "Samurai Seven" },
	[120] = Deck:new { capacity = 11, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Ono-Sendai", name = "Cyberspace II" },
	[121] = Deck:new { capacity = 15, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Ono-Sendai", name = "Cyberspace III" },
	[122] = Deck:new { capacity = 20, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Ono-Sendai", name = "Cyberspace VI" },
	[123] = Deck:new { capacity = 25, buggy = false, cyberspace = true,  cost = 0,     manufacturer = "Ono-Sendai", name = "Cyberspace VII" },
	
	
	[199] = Comlink:new {
		cost = 100,
		version = 1,
	},
	[200] = Comlink:new {
		cost = 0,
		version = 2,
	},
	[201] = Comlink:new {
		cost = 0,
		version = 3,
	},
	[202] = Comlink:new {
		cost = 0,
		version = 4,
	},
	[203] = Comlink:new {
		cost = 0,
		version = 5,
	},
	[204] = Comlink:new {
		cost = 0,
		version = 6,
	},
	[205] = Software:new {
		name = "Acid",
		version = 1,
		scope = "ice"
	},
	[206] = Software:new {
		name = "Acid",
		version = 3,
		scope = "ice"
	},
	[207] = Software:new {
		name = "Acid",
		version = 4,
		scope = "ice"
	},
	[208] = Software:new {
		name = "ArmorAll",
		version = 1,
		scope = "ice"
	},
	[209] = Software:new {
		name = "ArmorAll",
		version = 2,
		scope = "ice"
	},
	[210] = Software:new {
		name = "ArmorAll",
		version = 3,
		scope = "ice"
	},
	[211] = Software:new {
		name = "ArmorAll",
		version = 4,
		scope = "ice"
	},
	[212] = Software:new {
		name = "BattleChess",
		version = 2,
		scope = "site",
	},
	[213] = Software:new {
		name = "BattleChess",
		version = 4,
		scope = "site", -- TODO: Phantom also 'ai'?
	},
	[214] = Software:new {
		name = "Blammo",
		version = 1,
		scope = "ice",
	},
	[215] = Software:new {
		name = "BlowTorch",
		cost = 750,
		version = 1,
		scope = "ice",
	},
	[216] = Software:new {
		name = "BlowTorch",
		version = 3,
		scope = "ice",
	},
	[217] = Software:new {
		name = "BlowTorch",
		version = 4,
		scope = "ice",
	},
	[218] = Software:new {
		name = "Concrete",
		version = 1,
		scope = "jack",
	},
	[219] = Software:new {
		name = "Concrete",
		version = 2,
		scope = "jack",
	},
	[220] = Software:new {
		name = "Concrete",
		version = 5,
		scope = "jack",
	},
	[221] = Software:new {
		name = "Cyberspace",
		version = 1,
		scope = "jack",
	},
	[222] = Software:new {
		name = "Decoder",
		cost = 750,
		version = 1,
		scope = "ice",
	},
	[223] = Software:new {
		name = "Decoder",
		version = 2,
		scope = "ice",
	},
	[224] = Software:new {
		name = "Decoder",
		version = 4,
		scope = "ice",
	},
	[225] = Software:new {
		name = "DepthCharge",
		version = 3,
		scope = "ice",
	},
	[226] = Software:new {
		name = "DepthCharge",
		version = 8,
		scope = "ice",
	},
	[227] = Software:new {
		name = "DoorStop",
		version = 1,
		scope = "ice",
	},
	[228] = Software:new {
		name = "DoorStop",
		version = 4,
		scope = "ice",
	},
	[229] = Software:new {
		name = "Drill",
		cost = 1500,
		version = 1,
		scope = "ice",
	},
	[230] = Software:new {
		name = "Drill",
		version = 2,
		scope = "ice",
	},
	[231] = Software:new {
		name = "Drill",
		version = 3,
		scope = "ice",
	},
	[232] = Software:new {
		name = "EasyRider",
		version = 1,
		scope = "cyberspace",
	},
	[233] = Software:new {
		name = "Hammer",
		version = 1,
		scope = "ice",
	},
	[234] = Software:new {
		name = "Hammer",
		version = 2,
		scope = "ice",
	},
	[235] = Software:new {
		name = "Hammer",
		version = 4,
		scope = "ice",
	},
	[236] = Software:new {
		name = "Hammer",
		version = 5,
		scope = "ice",
	},
	[237] = Software:new {
		name = "Hammer",
		version = 6,
		scope = "ice",
	},
	[238] = Software:new {
		name = "Hemlock",
		version = 1,
		scope = "ai",
	},
	[239] = Software:new {
		name = "Injector",
		version = 1,
		scope = "ice",
	},
	[240] = Software:new {
		name = "Injector",
		version = 2,
		scope = "ice",
	},
	[241] = Software:new {
		name = "Injector",
		version = 3,
		scope = "ice",
	},
	[242] = Software:new {
		name = "Injector",
		version = 5,
		scope = "ice",
	},
	[243] = Software:new {
		name = "Jammies",
		version = 1,
		scope = "ice",
	},
	[244] = Software:new {
		name = "Jammies",
		version = 2,
		scope = "ice",
	},
	[245] = Software:new {
		name = "Jammies",
		version = 3,
		scope = "ice",
	},
	[246] = Software:new {
		name = "Jammies",
		version = 4,
		scope = "ice",
	},
	[247] = Software:new {
		name = "KGB",
		version = 1,
		scope = "ice",
	},
	[248] = Software:new {
		name = "KuangEleven",
		version = 1,
		scope = "ai",
	},
	[249] = Software:new {
		name = "LogicBomb",
		version = 3,
		scope = "ice",
	},
	[250] = Software:new {
		name = "LogicBomb",
		version = 6,
		scope = "ice",
	},
	[251] = Software:new {
		name = "Mimic",
		version = 1,
		scope = "ice",
	},
	[252] = Software:new {
		name = "Mimic",
		version = 2,
		scope = "ice",
	},
	[253] = Software:new {
		name = "Probe",
		cost = 500,
		version = 1,
		scope = "ice",
	},
	[254] = Software:new {
		name = "Probe",
		version = 3,
		scope = "ice",
	},
	[255] = Software:new {
		name = "Probe",
		version = 4,
		scope = "ice",
	},
	[256] = Software:new {
		name = "Probe",
		version = 10,
		scope = "ice",
	},
	[257] = Software:new {
		name = "Probe",
		version = 15,
		scope = "ice",
	},
	[258] = Software:new {
		name = "Python",
		version = 2,
		scope = "ice",
	},
	[259] = Software:new {
		name = "Python",
		version = 3,
		scope = "ice",
	},
	[260] = Software:new {
		name = "Python",
		version = 5,
		scope = "ice",
	},
	[261] = Software:new {
		name = "Scout",
		version = 1,
		scope = "site",
	},
	[262] = Software:new {
		name = "Sequencer",
		version = 1,
		scope = "site",
	},
	[263] = Software:new {
		name = "Slow",
		version = 1,
		scope = "ice",
	},
	[264] = Software:new {
		name = "Slow",
		version = 2,
		scope = "ice",
	},
	[265] = Software:new {
		name = "Slow",
		version = 3,
		scope = "ice",
	},
	[266] = Software:new {
		name = "Slow",
		version = 4,
		scope = "ice",
	},
	[267] = Software:new {
		name = "Slow",
		version = 5,
		scope = "ice",
	},
	[268] = Software:new {
		name = "ThunderHead",
		version = 1,
		scope = "ice",
	},
	[269] = Software:new {
		name = "ThunderHead",
		version = 2,
		scope = "ice",
	},
	[270] = Software:new {
		name = "ThunderHead",
		version = 3,
		scope = "ice",
	},
	[271] = Software:new {
		name = "ThunderHead",
		version = 4,
		scope = "ice",
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
	[402] = Skill:new { name = "Hardware Repair", cost = 1000, scope = "room" },
	[403] = Skill:new { name = "Icebreaking", cost = 1000, scope = "cyberspace" },
	[404] = Skill:new { name = "Debug", cost = 1000, scope = "room" },
	[405] = Skill:new { name = "Evasion", cost = 2000, scope = "cyberspace" },
	[406] = Skill:new { name = "Bargaining", cost = 2000, scope = "???" },
	[407] = Skill:new { name = "Psychoanalysis", cost = 2000, scope = "???" },
	[408] = Skill:new { name = "Philosophy", cost = 2000, scope = "???" },
	[409] = Skill:new { name = "Phenomenology", cost = 2000, scope = "???" },
	[410] = Skill:new { name = "Logic", cost = 1000, scope = "???" },
	[411] = Skill:new { name = "Warez Analysis", cost = 1000, scope = "???" },
	[412] = Skill:new { name = "Musicianship", cost = 1000, scope = "???" },
	[413] = Skill:new { name = "Zen", cost = 1000, scope = "???" },
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





