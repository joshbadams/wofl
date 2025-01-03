-- Globals, these will all be saved

c = {
	initialRoom = "chatsubo",
	secondsPerMinute = 1,
}

s = {
	
	money = 6,
	hp = 2000,

	inventory = {
		0, -- cash
		1, -- pawn ticket
		100, -- UXB
	},

	software = {
		200, -- Comlink 1.0
	},
	
	-- all organs by default
	organs = {
		300, 301, 302, 303, 304,
		305, 306, 307, 308, 309,
		310, 311, 312, 313, 314,
		315, 316, 317, 318, 319,
	},

	unlockedMessagesInfo = {},
	unlockedMessagesTracker = {},

	month = 11,
	day = 16,
	year = 58,
	date = 111558,
	hour = 0,
	minute = 0,
	bankaccount = 1941,
	name = "Badams",
	bamaid = "056306118",

}

function IncrementTime()
	s.minute = s.minute + 1
	if (s.minute == 60) then
		s.minute = 0
		s.hour = s.hour + 1
		if (s.hour == 24) then
			s.hour = 0
			s.day = s.day + 1
			s.date = s.month * 1000 + s.day * 100 + s.year
		end
	end

	-- make sure the UI is updated
	UpdateInfo();
end

currentRoom = nil


GameScripts = {
	-- helpers
	"Items",
	"Room",
	"Gridbox",
	"Site",
	"InvBox",
	"MiscBoxes",

	-- rooms
	"Chatsubo",
	"BodyShop",
	"MiscRooms",
	
	-- sites
	"IRS",
	"Cheapo",
	"PAX",
	"RegFellow",
}

function TablesMatch(g, a, b)
	return a == b
end



function table:removekey(key)
	local element = self[key]
	self[key] = nil
	return element
end

function table:removeArrayItem(item)
	for i, val in ipairs(self) do
		if (val == item) then
			table.remove(self, i)
			return vale
		end
	end

	return nil
end

function table:append(item)
	self[#self+1] = item
end

function table:containsArrayItem(item)
	for _, val in ipairs(self) do
		if (val == item) then
			return true
		end
	end
	return false
end


function string:appendPadded(str, width)
	local spaces = width - str:len()
	local res = self .. str
	for i=1,spaces do
		res = res .. ' '
	end

	return res
end

function string.fromTodaysDate()
	return string.format("%02d/%02d/%02d", s.month, s.day, s.year)
end

function string.fromDate(date)
	local month = math.floor((date % 1000000) / 10000)
	local day = math.floor((date % 10000) / 100)
	local year = math.floor((date % 100) / 1)
	return string.format("%02d/%02d/%02d", month, day, year)
end

function string.fromTime()
	return string.format("%02d:%02d", s.hour, s.minute)
end

LuaObj = { }
function LuaObj:new (obj)
  obk = obk or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end
