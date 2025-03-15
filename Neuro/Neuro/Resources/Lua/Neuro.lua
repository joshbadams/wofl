-- Globals, these will all be saved

local level=0

local function hook(event)
 local t=debug.getinfo(3)
 io.write(level," >>> ",string.rep(" ",level))
 if t~=nil and t.currentline>=0 then io.write(t.short_src,":",t.currentline," ") end
 t=debug.getinfo(2)
 if event=="call" then
  level=level+1
 else
  level=level-1 if level<0 then level=0 end
 end
 if t.what=="main" then
  if event=="call" then
   io.write("begin ",t.short_src)
  else
   io.write("end ",t.short_src)
  end
 elseif t.what=="Lua" then
  io.write(event," ",t.name or "(Lua)"," <",t.linedefined,":",t.short_src,">")
 else
 io.write(event," ",t.name or "(C)"," [",t.what,"] ")
 end
 io.write("\n")
end

--debug.sethook(hook,"cr")
level=0











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
	
	-- which skills we currently have learned, and their level (stored separately so the opened skills are in order by unlocking order)
	skills = {
		
	},
	skillLevels = {
	},

	unlockedMessagesInfo = {},

	month = 11,
	day = 16,
	year = 58,
	date = 111558,
	hour = 0,
	minute = 0,
	bankaccount = 1941,
	name = "Badams",
	bamaid = "056306118",
	
	hasTalkedInRoom = false,
}

function s:ApplyLoadedGame(game)
print("loading from save ", game)
	for k,v in pairs(game) do
		s[k] = v
	end
end

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
currentSite = nil
currentDeck = nil


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
	"Loser",
	
	-- sites
	"IRS",
	"Cheapo",
	"PAX",
	"RegFellow",
	"WorldChess",
}

function TablesMatch(g, a, b)
	return a == b
end

function table:count()
	local size = 0
	for k,v in pairs(self) do
		size = size + 1
	end
	return size
end

function table:removeKey(key)
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

function table:concat(other)
	for i=1,#other do
		self[#self+1] = other[i]
	end
	return self
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
	return self .. str .. string.rep(" ", spaces)
end

function string:appendRightPadded(str, width)
	local spaces = width - str:len()
	return self .. string.rep(" ", spaces) .. str
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

function string.SplitLines(s, width)
	local lines = {}
	local index = 1
	local len = string.len(s)

    for paragraph in string.gmatch(s, "[^\n]+") do
		-- trim any spaces
		local p = string.gsub(paragraphs, '^%s*(.-)%s*$', '%1')
		print("para", p, "width", width)
		if (p.len() <= width) then
			table.insert(lines, p)
		else
			local line = ""
			repeat
				local wrapped = false
				for w in string.gmatch(p, "(%a+)") do
					print("word:", w)
					local line2 = line .. w .. " "
					if (line2:len() > width + 1) then
						table.insert(lines, line)
						print("line:", line)
						print("p before", p)
						p = string.sub(p, string.len(line) + 1, -1)
						print("p after", p)
						wrapped = true
						break
					end
					line = line2
				end
			until not wrapped
			table.insert(lines, line)
		end

--      table.insert(paragraphs, p)
    end

	return lines

end


LuaObj = { }
function LuaObj:new (obj)
  obk = obk or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end
