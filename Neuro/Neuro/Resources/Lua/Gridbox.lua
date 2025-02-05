
Gridbox = LuaObj:new {
	detailsIndex = 0,
	hasPassword = false,
	
	sizeX = 0,
	sizeY = 0
}

function Gridbox:OpenBox(width, height)
	self.detailsIndex = 0
	self.sizeX = width
	self.sizeY = height
	
	self.numMessagesPerPage = self.sizeY - 6
	if self.numMessagesPerPage > 9 then
		self.numMessagesPerPage = 9
	end
end

function Gridbox:Close()
	print("closing ", self, self.title)
	CloseBox(self)
end

function Gridbox:GetEntries()
	return {}
end

function Gridbox:ShouldIgnoreAllInput()
	return false
end

function Gridbox:HandleClickedEntry(id)
end

function Gridbox:HandleClickedGridEntry(id)
print("ClickedGridEntry")
	-- check if input needs to be tossed
	if (self:ShouldIgnoreAllInput()) then
		return
	end

	-- -1 is always the "exit" option
	if id == -1 then
		self:HandleClickedExit()
	-- -2 is always the "more" option
	elseif id == -2 then
		self:HandleClickedMore()
	else
print("calling clickedentry", self, id)
		self:HandleClickedEntry(id)
	end
end

function Gridbox:AddExitMoreEntries(entries, needsMore)
	local exitmoreCenter = self:CenteredX("exit more")
	table.append(entries, {x = exitmoreCenter, y = self.sizeY - 1, text = "exit", clickId = -1, key = "x" } )
	if needsMore then
		table.append(entries, {x = exitmoreCenter + 5, y = self.sizeY - 1, text = "more", clickId = -2, key = "m" } )
	end
end


function Gridbox:CenteredX(str)
	return math.floor((self.sizeX - str:len()) / 2)
end

function Gridbox:GetDetailsString()
	return "Unimplemented"
end

function Gridbox:OnMessageComplete()
	self.detailsIndex = 0
end

function Gridbox:OnTextEntryComplete(tag)
end

function Gridbox:OnTextEntryCancelled(tag)
end

function Gridbox:OnGenericContinueInput()
end

function Gridbox:HandleKeyInput(keyCode, char, type)
	return false
end

function Gridbox:HandleMouseInput(x, y, type)
	return false
end
