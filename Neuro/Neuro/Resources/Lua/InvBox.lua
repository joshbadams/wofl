InvPhase = {
	List = {},
	Software = {},
	Action = {},
	Amount = {},
	ConfirmDiscaard = {},
	ConfirmGive = {},
	Login = {},
	LoginError = {},
}

InvAction = {
	Exit = 1,
	Operate = 2,
	Give = 3,
	Discard = 4,
	Erase = 5,
	Yes = 6,
	No = 7,
}

InvBox = Gridbox:new {
	x = 150,
	y = 480,
	w = 500,
	h = 280,
}

function InvBox:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)

	self.phase = InvPhase.List
	self.page = 0
	self.numInvPerPage = self.sizeY - 2;
	self.numPages = math.ceil(#s.inventory / self.numInvPerPage);
	
	self.activeSoftware = nil
	self.invItem = 0
end

function InvBox:GetEntries()

	local entries = {}

	if (self.phase == InvPhase.List) then
		self:GetInvEntries(entries, s.inventory, "Items")
	elseif (self.phase == InvPhase.Software) then
		self:GetInvEntries(entries, s.software, "Software")
	elseif (self.phase == InvPhase.Action) then
		self:GetActionEntries(entries)
	elseif (self.phase == InvPhase.Amount) then
		self:GetAmountEntries(entries)
	elseif (self.phase == InvPhase.Login) then
		self:GetLoginEntries(entries)
	elseif (self.phase == InvPhase.LoginError) then
		self:GetLoginErrorEntries(entries)
	end

	return entries
end

function InvBox:GetInvEntries(entries, inv, heading)
	
	table.append(entries, { x = 1, y = 0, text = heading })

	local itemIndex = self.page * self.numInvPerPage + 1
	for line=1, self.numInvPerPage do

		if (itemIndex > #inv) then
			break
		end
		
		local desc = GetListItemDesc(inv[itemIndex], self.sizeX - 3)
		table.append(entries, { x = 0, y = line, text = string.format("%d. %s", line, desc), clickId = itemIndex, key = tostring(line) })

		itemIndex = itemIndex + 1
	end

	-- exit / more buttons
	needsMore = #inv > self.numInvPerPage
	self:AddExitMoreEntries(entries, needsMore)
end

function InvBox:GetActionEntries(entries)
	
	table.append(entries, {x = 0, y = 0, text = GetItemDesc(s.inventory[self.invItem])})
	
	local curY = 1
	table.append(entries, {x = 0, y = curY, text = "X. Exit", clickId = InvAction.Exit, key = "x" })
	curY = curY + 1
	table.append(entries, {x = 0, y = curY, text = "O. Operate Item", clickId = InvAction.Operate, key = "o" })
	curY = curY + 1
	table.append(entries, {x = 0, y = curY, text = "D. Discard Item", clickId = InvAction.Discard, key = "d" })
	curY = curY + 1
	if (currentRoom.hasPerson) then
		table.append(entries, {x = 0, y = curY, text = "G. Give Item", clickId = InvAction.Give, key = "g" })
		curY = curY + 1
	end
	if (Items[s.inventory[self.invItem]].type == "deck") then
		table.append(entries, {x = 0, y = curY, text = "E. Erase Software", clickId = InvAction.Erase, key = "e" })
		curY = curY + 1
	end
end

function InvBox:GetAmountEntries(entries)
	table.append(entries, { x = 0, y = 0, text = GetItemDesc(s.inventory[self.invItem]) })
	table.append(entries, { x = 0, y = 1, text = "Give how much?" })
	table.append(entries, { x = 0, y = 2, text = "> " })
	table.append(entries, { x = 2, y = 2, entryTag = "amount", numeric = true })
end

function InvBox:GetLoginEntries(entries)
	table.append(entries, { x = 0, y = 0, text = string.format("%s %d.0", self.activeSoftware.name, self.activeSoftware.version) })
	table.append(entries, { x = 0, y = 1, text = "Enter link code:" })
	table.append(entries, { x = 0, y = 2, text = "> " })
	table.append(entries, { x = 2, y = 2, entryTag = "sitename" })
end

function InvBox:GetLoginErrorEntries(entries)
	table.append(entries, { x = 0, y = 0, text = string.format("%s %d.0", self.activeSoftware.name, self.activeSoftware.version) })
	table.append(entries, { x = 0, y = 1, text = "Unknown link." })
end







function InvBox:HandleClickedEntry(id)

	print("Inv clicked", self, self.phase, id)

	-- handle non-zero ids
	if (id > 0) then
		if (self.phase == InvPhase.List) then
			self.invItem = id
			self.phase = InvPhase.Action
		elseif (self.phase == InvPhase.Action) then
			self:PerformAction(id)
		elseif (self.phase == InvPhase.Software) then
			self:UseSoftware(id)
		elseif (self.phase == InvPhase.ConfirmGive) then
			if (id == InvAction.Yes) then
				currentRoom:GiveItem(self.invItem)
				table.removeKey(self.invItem)
			elseif (id == InvAction.No) then
				self.phase = InvPhase.List
			end
		elseif (self.phase == InvPhase.ConfirmDiscard) then
			if (id == InvAction.Yes) then
				table.removeKey(self.invItem)
			elseif (id == InvAction.No) then
				self.phase = InvPhase.List
			end
		end


	-- -1 is always the "exit" option
	elseif id == -1 then
		print("closing box")
		self:Close()
	-- -2 is always the "more" option
	elseif id == -2 then
		-- self.page = math.fmod(self.page + 1, self.numPages)
		self.page = self.page + 1
		if (self.page == self.numPages) then self.page = 0 end
	end
end

function InvBox:OnTextEntryComplete(text, tag)
	if (self.phase == InvPhase.Login) then
		if (text == "") then
			self:Close()
			return
		end

		local site = _G[text]
		if (site == nil or site.comLinkLevel == nil) then
			self.phase = InvPhase.LoginError
		else
			OpenBox(text)
			self:Close()
		end


		return
	end

	if (text == "") then
		self.phase = InvPhase.List
		return
	end

	local amount = tonumber(text)
	currentRoom:GiveMoney(amount)

	self:Close()
end

function InvBox:OnTextEntryCancelled(tag)
	self:Close()
end

function InvBox:OnGenericContinueInput()
	if (self.phase == InvPhase.LoginError) then
		self.phase = InvPhase.Login
	end
end


function InvBox:PerformAction(action)
	if (self.invItem == 0) then
		error("Performing action without an item")
	end

	-- item tamplate object
	local item = Items[s.inventory[self.invItem]]

	if (action == InvAction.Exit) then
		self.phase = InvPhase.List
	elseif (action == InvAction.Operate) then
		if (item.type == "deck") then
			self.phase = InvPhase.Software
		end
	elseif (action == InvAction.Give) then
		-- credits are special
		if (s.inventory[self.invItem] == 0) then
			self.phase = InvPhase.Amount
		else
			self.phase = InvPhase.ConfirmGive
		end
	elseif (action == InvAction.Discard) then
		-- credits are special
		if (s.inventory[self.invItem] == 0) then
			self.phase = InvPhase.List
		else
			self.phase = InvPhase.ConfirmDiscard
		end
	elseif (action == InvAction.Erase) then
	end
		
end

function InvBox:UseSoftware(softwareItem)
	item = Items[s.software[softwareItem]]

	if (item.subtype == "comlink") then
		self.activeSoftware = item
		self.phase = InvPhase.Login
--		OpenBox("Login")
--		self:Close()
	end
end


