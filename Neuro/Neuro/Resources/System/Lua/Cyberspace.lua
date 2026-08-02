s.canCrossZones = false
s.savedLocX = nil
s.savedLocY = nil
s.jackDestX = 0
s.jackDestY = 0

CS = Room:new {
	name = "cybercenter",
	
	longDescription = "Test.",
	description = "Test.",
	
	north = "streetwest1",
	
	curX = 0,
	curY = 0,
	destX = 0,
	destY = 0,
	
	bases = {},
	
	x1 = 600,
	y1 = 300,
	
	namedAnims =
	{
		{
			name="right", x=32, y=32, width=1213, height=447, framerate = 15,    --x=0, y=0, width=136, height=266, framerate = 4,
			frames = { "cyberhoriz1", "cyberhoriz2", "cyberhoriz3", },
		},
		{
			name="left", x=32, y=32, width=1213, height=447, framerate = 15,    --x=0, y=0, width=136, height=266, framerate = 4,
			frames = { "cyberhoriz3", "cyberhoriz2", "cyberhoriz1" },
		},
		{
			name="up", x=32, y=32, width=1213, height=447, framerate = 15,    --x=0, y=0, width=136, height=266, framerate = 4,
			frames = { "cybervert1", "cybervert2", "cybervert3", },
		},
		{
			name="down", x=32, y=32, width=1213, height=447, framerate = 15,    --x=0, y=0, width=136, height=266, framerate = 4,
			frames = { "cybervert3", "cybervert2", "cybervert1" },
		},
	},
	
	baseSprite = {
		name="baseclose", x=0, y=0, width=100, height=100, framerate = 1,    --x=0, y=0, width=136, height=266, framerate = 4,
		frames = { "base" },
	},
}
cs = CS
cybercenter = CS

function CS:OnEnterRoom()
	Room.OnEnterRoom(self)

print("prevroom", s.previousRoomName)
	s.canCrossZones = false
	if (s.previousRoomName == "streetwest1") then
		self.curX = 16
		self.curY = 16
--		s.canCrossZones = true

--	elseif (self.openTag == "exitsite") then
--		self.curX = s.savedLocX
--		self.curY = s.savedLocY
--		s.savedLocX = nil
--		s.savedLocY = nil
	else
		local prevRoom = _G[s.previousRoomName]
		self.curX = prevRoom.locX
		self.curY = prevRoom.locY
	end

	self.destX = self.curX
	self.destY = self.curY

	for k,v in pairs(_G) do
		if (type(v) == 'table' and v.comLinkLevel ~= nil) then
			if (v.baseX ~= nil and v.baseY ~= nil) then
				local loc = math.floor(v.baseX * 512 + v.baseY)
				self.bases[k] = v
			else
				print("missing base loc for site", k)
			end
		end
	end
end

function CS:HandleKeyInput(keyCode, type)
	local handled = false
	local anim = nil

	local upframe = self:GetAnimationInfo("up")
	local downframe = self:GetAnimationInfo("down")
	local leftframe = self:GetAnimationInfo("left")
	local rightframe = self:GetAnimationInfo("right")
	if (upframe ~= -1 or downframe ~= -1 or leftframe ~= -1 or rightframe ~= -1) then
print("animating, can't move, sucking all input", upframe, downframe, leftframe, rightframe)
		return true
	end

	-- up
	if (keyCode == 5) then
		anim = "up"
		self.destY = self.curY + 16
		handled = true
	-- down
	elseif (keyCode == 6) then
		anim = "down"
		self.destY = self.curY - 16
		handled = true
	-- left
	elseif (keyCode == 7) then
		anim = "left"
		self.destX = self.curX - 16
		handled = true
	-- right
	elseif (keyCode == 8) then
		anim = "right"
		self.destX = self.curX + 16
		handled = true
	-- enter
	elseif (keyCode == 2) then
		local onBase, baseName = self:FindClosestBase(true)
		if (onBase ~= nil) then
print("Opening base", baseName)
			OpenBox(baseName, "cyberspace")
		end
		handled = true
	-- esc
	elseif (keyCode == 1) then
		GoToRoom(s.previousRoomName)
		handled = true
	end

	if (not s.canCrossZones) then
		-- every 256 on X is a boundary
		if ((self.destX % 256) == 0) then
			self.destX = self.curX
		end
		-- every 128 on Y is a boundary
		if ((self.destY % 128) == 0) then
			self.destY = self.curY
		end
	end

	if (self.destX ~= self.curX or self.destY ~= self.curY) then
		self:PlayOneShotAnimation(anim)
	end

	return handled
end

function CS:FindClosestBase(currentLocOnly)
	for k,v in pairs(self.bases) do
		local distX = math.abs(v.baseX - self.curX)
		local distY = v.baseY - self.curY
		if (currentLocOnly) then
			if (distX == 0 and distY == 0) then
				return v, k
			end
		elseif (distY >= 0 and distY < 16 and distX <= 20) then
			return v, k
		elseif (distY >= 16 and distY < 48 and distX <= 32) then
			return v, k
		end
	end
	return nil
end

function CS:ProjectBase(base)
	-- pixels
	local centerX = 615
	local width = 615 - 80
	local bottomY = 450
	local height = 200

	-- CS coords
	local edgeDistX = 16
	local edgeDistY = 48

	local baseX = base.baseX
	local baseY = base.baseY
	local distX = self.curX - baseX
	local distY = self.curY - baseY

	-- ratios
	local pixPerX = width / edgeDistX
	local pixPerY = height / edgeDistY

	local xyratio = 0.5
	local distOverMax = (height - distY) / height
	local distOverMax2 = -distY / edgeDistY

	local x = math.floor(centerX - distX * pixPerX * (1 - distOverMax * xyratio))
	local y = math.floor(bottomY + distY * pixPerY)

	local minSize = 50
	local maxSize = 200
	local size = math.floor(minSize + (maxSize - minSize) * (1 - distOverMax2))
	return x,y, size, distY, height, distOverMax2
end

function CS:Tick(deltaTime)
	local upframe = self:GetAnimationInfo("up")
	local downframe = self:GetAnimationInfo("down")
	local leftframe = self:GetAnimationInfo("left")
	local rightframe = self:GetAnimationInfo("right")

	if (upframe ~= -1) then
		self.curY = self.destY - 16 + 4 * upframe
--		print("up " .. upframe, self.curX, self.curY)
	elseif (downframe ~= -1) then
		self.curY = self.destY + 16 - 4 * downframe
--		print("down " .. downframe, self.curX, self.curY)
	elseif (leftframe ~= -1) then
		self.curX = self.destX + 16 - 4 * leftframe
--		print("left " .. leftframe, self.curX, self.curY)
	elseif (rightframe ~= -1) then
		self.curX = self.destX - 16 + 4 * rightframe
--		print("right " .. rightframe, self.curX, self.curY)
	else
		self.curX = self.destX
		self.curY = self.destY
	end


	local fakeBase = { locX = 64, locY = 64 }
	local closestBase, baseName = self:FindClosestBase()

	ShowMessage(string.format("loc: %d %d, base: %s", self.curX, self.curY, baseName))

	self:RemoveAnimation(self.baseSprite)

	if (closestBase == nil) then
		return
	end
	
	local x, y, size, a, b, c = self:ProjectBase(closestBase)

	ShowMessage(string.format("loc: %d %d, base: %s - pos: %d,%d - size: %d [%d %d %f]", self.curX, self.curY, baseName, x, y, size, a, b, c))

--	print(string.format("distOverMax = %f, scaled = %f, x = %d", distOverMax, distOverMax * xyratio, x))
	self.baseSprite.x = math.floor(x - size / 2)
	self.baseSprite.y = y - size
	self.baseSprite.width = size
	self.baseSprite.height = size
	self:AddAnimation(self.baseSprite)

--	if ()
end

































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

	s.canCrossZones = false
	if (self.openTag == "debug") then
		self.curX = 10
		self.curY = 10
		s.canCrossZones = true

	elseif (self.openTag == "exitsite") then
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
				self.bases[loc] = k
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
print("Opening base", base)
			OpenBox(base, "cyberspace")
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

