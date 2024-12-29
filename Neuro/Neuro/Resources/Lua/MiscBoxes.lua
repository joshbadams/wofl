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

function SystemBox:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)

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

	items = {},
}

function ShopBox:OpenBox(width, height)
	print("Opened a shop")
	Gridbox:OpenBox(width, height)

	self.firstVisibleIndex = 1
	self.numItemsPerPage = self.sizeY - 2
	self.boughtSold = false
end

function ShopBox:GetPrice(id)
	local template = Items[id]
	local price = 0

	if (template.type == "organ") then
		print("buy", template.buy, "sell", template.sell)
		price = template.sell
		if (self.isBuying) then
			price = template.buy
		end
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

		table.append(entries, {x = 0, y = curY, text = label, clickId = listIndex, key = keyPress})

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
		end
	else
		s.money = s.money + price
		self.boughtSold = true
		self:OnBoughtSoldItem(clickId)
	end
end

function ShopBox:OnBoughtSoldNothing()
end

function ShopBox:OnBoughtSoldItem(itemIndex)
end

function ShopBox:HandleClickedMore()
	self.firstVisibleIndex = self.firstVisibleIndex + self.numItemsPerPage
	if (self.firstVisibleIndex > #self.items) then
		self.firstVisibleIndex = 1
	end
end

function ShopBox:HandleClickedExit()
	self:Close()
end
