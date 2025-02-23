-----------------------------------------------------------------------------------------------------------------
-- SystemBox
-----------------------------------------------------------------------------------------------------------------

SystemPhase = {
	Menu = {},
	Save = {},
	Load = {},
	Pausing = {},
	Quit = {},
}

SystemBox = Gridbox:new {
	x = 150,
	y = 480,
	w = 400,
	h = 280,

}

function SystemBox:OpenBox()
	self.Phase = SystemPhase.Menu
end

function SystemBox:GetEntries()

	local entries = {}

	if (self.Phase == SystemPhase.Menu) then
		table.append(entries, {x = self:CenteredX("Disk Options"), y = 0, text = "Disk Options" } )
	
		local curY = 1
		table.append(entries, {x = 1, y = curY, text = "L. Load", key = "l", onClick = function() self.Phase = SystemPhase.Load; end } )
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "S. Save", key = "s", onClick = function() self.Phase = SystemPhase.Save; end })
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "P. Pause", key = "p", onClick = function() self.Phase = SystemPhase.Pausing; end })
		curY = curY + 1
		table.append(entries, {x = 1, y = curY, text = "Q. Quit", key = "q", onClick = function() self.Phase = SystemPhase.Quit; end })
	elseif (self.Phase == SystemPhase.Load) then
		table.append(entries, {x = 3, y = 2, text = "1", key = "1", onClick = function() LoadGame(1); self:Close() end })
		table.append(entries, {x = 5, y = 2, text = "2", key = "2", onClick = function() LoadGame(2); self:Close() end })
		table.append(entries, {x = 7, y = 2, text = "3", key = "3", onClick = function() LoadGame(3); self:Close() end })
		table.append(entries, {x = 9, y = 2, text = "4", key = "4", onClick = function() LoadGame(4); self:Close() end })
	elseif (self.Phase == SystemPhase.Save) then
		table.append(entries, {x = 3, y = 2, text = "1", key = "1", onClick = function() SaveGame(1); self:Close() end })
		table.append(entries, {x = 5, y = 2, text = "2", key = "2", onClick = function() SaveGame(2); self:Close() end })
		table.append(entries, {x = 7, y = 2, text = "3", key = "3", onClick = function() SaveGame(3); self:Close() end })
		table.append(entries, {x = 9, y = 2, text = "4", key = "4", onClick = function() SaveGame(4); self:Close() end })
	end
	
	self:AddExitMoreEntries(entries, false)

	return entries
end

function SystemBox:HandleClickedExit()
	if (self.Phase == SystemPhase.Menu) then
		self:Close()
	else
		self.Phase = SystemPhase.Menu
	end
end

-----------------------------------------------------------------------------------------------------------------
-- ShopBox
-----------------------------------------------------------------------------------------------------------------

ShopBox = Gridbox:new {
	x = 150,
	y = 430,
	w = 700,
	h = 330,
	
	heading = "PRICE LIST",

	isBuying = true,
	isBasicItemShop = true,

	items = {},
}

function ShopBox:OpenBox()
	print("Opened a shop")

	self.firstVisibleIndex = 1
	self.numItemsPerPage = self.sizeY - 2
	self.boughtSold = false
end

function ShopBox:GetPrice(id)
	local template = Items[id]
	local price = 0

	if (template.type == "organ") then
		price = template.sell
		if (self.isBuying) then
			price = template.buy
		end
	else --if (template.type == "skill" || template.type == ) then
		price = template.cost
	end

	return price
end

function ShopBox:GetEntries()
	local entries = {}

	local headingText = string.format("%s  credits--%d", self.heading, s.money)
	table.append(entries, {x = 0, y = 0, text = headingText})

	-- init loop counters
	local localIndex = 1
	local listIndex = self.firstVisibleIndex
	local label = ""
	local curY = 1

print("num items", #self.items)

	-- go until we are end of page or end of list
	while listIndex <= #self.items and localIndex <= self.numItemsPerPage do

		local id = self.items[listIndex]
		local template = Items[id]

		-- organs can only buy/sell one, so check inventory
		local inactive = false
		if (template.type == "organ") then
			if (self.isBuying) then
				inactive = table.containsArrayItem(s.organs, id)
			else
				inactive = not table.containsArrayItem(s.organs, id)
			end
		end

		local prefix = " "
		if (inactive) then
			prefix = "-"
		end

		label = string.format("%d %s", localIndex, prefix)
		label = label:appendPadded(template.name, self.sizeX - 9)
		local priceString = string.format("%d", self:GetPrice(id))
		label = label:appendPadded(priceString, 6)

		table.append(entries, {x = 0, y = curY, text = label, clickId = listIndex, key = tostring(localIndex) })

		listIndex = listIndex + 1
		localIndex = localIndex + 1
		curY = curY + 1
	end

	local needsMore = #self.items > self.numItemsPerPage
	self:AddExitMoreEntries(entries, needsMore)
	
	return entries;
end

function ShopBox:HandleClickedEntry(clickId)

	print("shop clicked", self, clickId, self.isBuying)

	local id = self.items[clickId]
	local item = Items[id];
	local price = self:GetPrice(id)
	print("clicked on ", item.name, id, price)

	if (self.isBuying) then
		if (s.money >= price) then
			s.money = s.money - price
			self.boughtSold = true
			self:OnBoughtSoldItem(clickId)
		else
			self:CannotAfford(itemIndex)
		end
	else
		s.money = s.money + price
		self.boughtSold = true
		self:OnBoughtSoldItem(clickId)
	end
end

function ShopBox:OnBoughtSoldNothing()
end

function ShopBox:OnBoughtSoldItem(clickId)
	if (self.isBasicItemShop) then
		table.append(s.inventory, self.items[clickId])
		CloseBox(self)
	end
end

function ShopBox:CannotAfford(itemIndex)
	if (self.isBasicItemShop) then
		CloseBox(self)
	end
end

function ShopBox:HandleClickedMore()
	self.firstVisibleIndex = self.firstVisibleIndex + self.numItemsPerPage
	if (self.firstVisibleIndex > #self.items) then
		self.firstVisibleIndex = 1
	end
end

function ShopBox:HandleClickedExit()
	if (not self.boughtSold) then
		self:OnBoughtSoldNothing()
	end

	self:Close()
end




-----------------------------------------------------------------------------------------------------------------
-- TextEntry
-----------------------------------------------------------------------------------------------------------------

TextEntryBox = Gridbox:new {
	x = 150,
	y = 200,
	w = 400,
	h = 200,
	
	prompt = "Enter:"
}

function TextEntryBox:GetEntries()
	local entries = {}

	table.append(entries, {x = 0, y = 0, text = self.prompt})
	table.append(entries, {x = 0, y = 1, entryTag = "entry"})

	return entries
end

DialogTextEntry = TextEntryBox:new {
	prompt = "Ask about:"
}

function DialogTextEntry:OnTextEntryComplete(text, tag)
	currentRoom:DialogTextEntered(text)
	CloseBox(self)
end



-----------------------------------------------------------------------------------------------------------------
-- MessageBox
-----------------------------------------------------------------------------------------------------------------

MessageBox = Gridbox:new {
	x = 200,
	y = 600,
	w = 500,
	h = 100,
	
	message = ""
}

function MessageBox:GetEntries()
	local entries = {}
	table.append(entries, {x = self:CenteredX(self.message), y = 0, text = self.message})
	return entries
end

function MessageBox:SetMessage(msg)
	self.message = msg
	UpdateBoxes()
end

function MessageBox:OnGenericContinueInput()
	self:Close()
end



DecodePhase = {
	Prompt = {},
	Success = {},
	Failed = {},
}

DecodeBox = Gridbox:new {
	x = 250,
	y = 430,
	w = 520,
	h = 250,
}

function DecodeBox:OpenBox()
	self.phase = DecodePhase.Prompt
end

function DecodeBox:GetEntries()
	local entries = {}
	table.append(entries, {x = self:CenteredX("Cryptology"), y = 0, text = "Cryptology"})
	table.append(entries, {x = 0, y = 1, text = "Enter word to decode:"})
	if (self.phase == DecodePhase.Prompt) then
		table.append(entries, {x = 0, y = 2, entryTag = "encrypted" })
	elseif (self.phase == DecodePhase.Success) then
		table.append(entries, {x = 0, y = 2, text = self.input })
		table.append(entries, {x = 0, y = 3, text = "Uncoded word is:" })
		table.append(entries, {x = 0, y = 4, text = self.decoded })

		self:GetButtonOrSpaceEntries(entries)
	elseif (self.phase == DecodePhase.Failed) then
		table.append(entries, {x = 0, y = 2, text = self.input })
		table.append(entries, {x = 0, y = 3, text = "Unable to decode word." })

		self:GetButtonOrSpaceEntries(entries)
	end
	return entries
end

function DecodeBox:OnGenericContinueInput()
	self.phase = DecodePhase.Prompt
end

function DecodeBox:OnTextEntryComplete(text, tag)
	self.input = text
	local decodedEntry = CryptoDecode[string.lower(text)]
	local cryptoLevel = s.skillLevels[401]
print("dcodingL ", self.input, self.decoded, cryptoLevel)
	if (decodedEntry == nil or cryptoLevel < decodedEntry.level) then
		self.phase = DecodePhase.Failed
	else
		self.phase = DecodePhase.Success
		self.decoded = decodedEntry.result
	end
end

function DecodeBox:OnTextEntryCancelled()
	self:Close()
end
