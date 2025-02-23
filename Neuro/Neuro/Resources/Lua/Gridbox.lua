
Gridbox = LuaObj:new {
	detailsIndex = 0,
	hasPassword = false,
	
	sizeX = 0,
	sizeY = 0
}

function Gridbox:OpenBox()
end

function Gridbox:OnOpenBox(width, height, this)
	self.detailsIndex = 0
	self.sizeX = width
	self.sizeY = height
	self.cppthis = this
	self.blockInput = false

	self.numMessagesPerPage = self.sizeY - 6
	if self.numMessagesPerPage > 9 then
		self.numMessagesPerPage = 9
	end

	self:OpenBox()
end

function Gridbox:Close()
	print("closing ", self)
	CloseBox(self)
end

function Gridbox:GetEntries()
	return {}
end

function Gridbox:ShouldIgnoreAllInput()
	return self.blockInput
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

function Gridbox:GetButtonOrSpaceEntries(entries)
	local footer = "Button or [space] to continue"
	if (string.len(footer) > self.sizeX) then
		footer = "Button or [space]"
	end
	table.append(entries, {x = self:CenteredX(footer), y = self.sizeY - 1, text = footer} )
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

function Gridbox:HandleKeyInput(keyCode, type)
	if (type > 0) then
		return false
	end

	self:OnGenericContinueInput()
	return true
end


function Gridbox:HandleMouseInput(x, y) --, type)
	self:OnGenericContinueInput()
	return true
end
