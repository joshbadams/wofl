
Cyberspace = Gridbox:new {
	x = 100,
	y = 40,
	w = 990,
	h = 530,

	curX = 0,
	curY = 0,
	
	maxX = 32,
	maxY = 32,
	
	bases = {}
}

function Cyberspace:OpenBox()
	self.bases = {}

	if (s.savedLocX ~= nil) then
		self.curX = s.savedLocX
		self.curY = s.savedLocY
		s.savedLocX = nil
		s.savedLocY = nil
	else
		self.curX = math.floor(currentRoom.locX / 16)
		self.curY = math.floor(currentRoom.locY / 16)
	end

	for k,v in pairs(_G) do
		if (type(v) == 'table' and v.comLinkLevel ~= nil) then
			if (v.baseX ~= nil and v.baseY ~= nil) then
				local loc = math.floor(v.baseX / 16 * 512 + v.baseY / 16)
				self.bases[loc] = string.lower(k)
			else
				print("missing base loc for site", k)
			end
		end
	end
end

function Cyberspace:Close()

end


function Cyberspace:GetEntries()
	local entries = {}

	print("Getting Entries", self.curX, self.curY)
	local centerX = math.floor(self.sizeX / 2)
	local centerY = math.floor(self.sizeY / 2) + 2
	for gridY = 0, self.sizeY - 3, 2 do
		for gridX = 0, self.sizeX - 1, 2 do
			local x = gridX
			local y = self.sizeY - gridY
			local csX = math.floor(self.curX - centerX / 2 + x / 2)
			local csY = math.floor(self.curY - centerY / 2 + y / 2)
--print(" local", csX, csY, self.curX, self.curY)
			if (csX >= 0 and csX <= self.maxX and csY >= 0 and csY <= self.maxY) then
				local cross = "+"
				local vert = "|"
				local horiz = "-"
				if (csX == 0 or csX == 16 or csX == 32) then
					vert = "/"
					cross = "/"
				end
				if (csY == 0 or csY == 8 or csY == 16 or csY == 24 or csY == 32) then
					cross = "="
					horiz = "="
				end
				if (self.bases[csX * 512 + csY] ~= nil) then
					cross = "B"
				end
				if (csX == self.curX and csY == self.curY) then
					cross = "X"
				end

				if (csY < 32) then
					table.append(entries, {x = gridX, y = gridY, text = vert})
				end
				if (csX < 32) then
					table.append(entries, {x = gridX, y = gridY + 1, text = cross .. horiz})
				else
					table.append(entries, {x = gridX, y = gridY + 1, text = horiz})
				end
			end
		end
	end

	self:AddExitMoreEntries(entries, false)

	return entries
	
--	"================================="
--	"/ | | | | | | | / | | | | | | | /"
--	"/-+-+-+-+-+-+-+-/-+-+-+-+-+-+-+-/"
--	"/ | | | | | | | / | | | | | | | /"
--	"/-+-+-+-+-+-+-+-/-+-+-+-+-+-+-+-/"

end


function Cyberspace:ShouldIgnoreAllInput()
	return Gridbox:ShouldIgnoreAllInput(self)
end


function Cyberspace:HandleClickedEntry(id)
end


function Cyberspace:HandleClickedExit()
	Gridbox.Close(self)
end

function Cyberspace:HandleKeyInput(keyCode, type)
	-- enter
	if (keyCode == 2) then
		local base = self.bases[self.curX * 512 + self.curY]
		if (base ~= nil) then
			Gridbox.Close(self)
			OpenBox(base)
			currentSite.fromCyberspace = true
			s.savedLocX = self.curX
			s.savedLocY = self.curY
		end
		return
	end

	local newX = self.curX
	local newY = self.curY

	-- up
	if (keyCode == 5) then
		newY = self.curY + 1
	-- down
	elseif (keyCode == 6) then
		newY = self.curY - 1
	-- left
	elseif (keyCode == 7) then
		newX = self.curX - 1
	-- right
	elseif (keyCode == 8) then
		newX = self.curX + 1
	end

	if (not s.canCrossZones) then
		if (newX == 0 or newX == 16 or newX == 32) then
			newX = self.curX
		end
		if (newY == 0 or newY == 8 or newY == 16 or newY == 24 or newY == 32) then
			newY = self.curY
		end
	end

	self.curX = newX
	self.curY = newY
end

cyberspace = Cyberspace
