InvPhase = {
	List = {},
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
	self.numPages = math.ceil(#inventory / self.numInvPerPage);

	self.invItem = 0
end

function InvBox:GetEntries()

	entries = {}

	if (self.phase == InvPhase.List) then
		self:GetInvEntries(entries)
	elseif (self.phase == InvPhase.Action) then
		self:GetActionEntries(entries)
	elseif (self.phase == InvPhase.Amount) then
		self:GetAmountEntries(entries)
	end

	return entries
end

function InvBox:GetInvEntries(entries)
	
	table.append(entries, { x = self:CenteredX("Items"), y = 0, text = "Items" })

	local itemIndex = self.page * self.numInvPerPage + 1
	for line=1, self.numInvPerPage do

		if (itemIndex > #inventory) then
			break
		end
		
		local desc = GetItemDesc(itemIndex)
		table.append(entries, { x = 0, y = line, text = string.format("%d. %s", line - 1, desc), clickId = itemIndex, key = tostring(line - 1) })

		itemIndex = itemIndex + 1
	end

	-- exit / more buttons
	needsMore = #inventory > self.numInvPerPage
	self:AddExitMoreEntries(entries, needsMore)
end


function InvBox:GetActionEntries(entries)
	
	table.append(entries, {x = 0, y = 0, text = GetItemDesc(self.invItem)})
	
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
	if (Items[inventory[self.invItem]].type == "deck") then
		table.append(entries, {x = 0, y = curY, text = "E. Erase Software", clickId = InvAction.Erase, key = "e" })
		curY = curY + 1
	end
end

function InvBox:GetAmountEntries(entries)
	table.append(entries, { x = 0, y = 0, text = GetItemDesc(self.invItem) })
	table.append(entries, { x = 0, y = 1, text = "Give how much?" })
	table.append(entries, { x = 0, y = 2, text = "> " })
	table.append(entries, { x = 2, y = 2, entryTag = "amount", numeric = true })
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
print("complete 1", text, tag)
	if (text == "") then
print("complete 2")
		self.phase = InvPhase.List
		return
	end

	local amount = tonumber(text)
print("complete 1", amount)

	currentRoom:GiveMoney(amount)

	self:Close()

end

function InvBox:OnTextEntryCancelled(tag)
	self.phase = InvPhase.List
end


function InvBox:PerformAction(action)
	if (self.invItem == 0) then
		error("Performing action without an item")
	end

	-- item tamplate object
	local item = Items[inventory[self.invItem]]

	if (action == InvAction.Exit) then
		self.phase = InvPhase.List
	elseif (action == InvAction.Operate) then
		if (item.type == "deck") then
			self.phase = InvPhase.Login
		end
	elseif (action == InvAction.Give) then
		-- credits are special
		if (inventory[self.invItem] == 0) then
			self.phase = InvPhase.Amount
		else
			self.phase = InvPhase.ConfirmGive
		end
	elseif (action == InvAction.Discard) then
		-- credits are special
		if (inventory[self.invItem] == 0) then
			self.phase = InvPhase.List
		else
			self.phase = InvPhase.ConfirmDiscard
		end
	elseif (action == InvAction.Erase) then
	end
		
end

--			currentRoom.Giveitem(self.invItem)

