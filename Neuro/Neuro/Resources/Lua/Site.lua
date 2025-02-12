
Site = Gridbox:new {
	x = 100,
	y = 40,
	w = 1000,
	h = 600,

	comLinkLevel = 1,
	
	pwdLevel = 0,
	currentPage = "main",
	firstVisibleIndex = 1,
	
	downloadPhase = 0,

	passwords = {},
}

function Site:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)

	for i,v in pairs(self.pages) do
		if (v.unlockid ~= nil) then
			self:CheckForUnlocks(v)
		end
	end

	self.passwordLevel = 0
	self.passwordFailed = false
	if (#self.passwords > 0) then
		self:GoToPage("title")
	else
		self:GoToPage("main")
	end
end

function Site:HasUnlocked(index)
	for k,v in pairs(s.unlockedMessagesInfo) do
		if (v.index == index) then
			return true
		end
	end
	return false
end

function Site:CheckForUnlocks(page)
	local unlockedInfo = s.unlockedMessagesInfo[page.unlockid]

	if (unlockedInfo == nil) then
		unlockedInfo = {}
		s.unlockedMessagesInfo[page.unlockid] = unlockedInfo
	end

	for i,v in ipairs(page.items) do
		if (self:HasUnlocked(i) == false and s.date >= v.date) then
			-- for the pure date unlocks, remember it's original date
			if (v.condition == nil) then
				table.insert(unlockedInfo, { index = i, date = v.date })
			-- for unlock callbacks, remember the current date was when it was unlocked
			elseif (pcall(v.condition)) then
				table.insert(unlockedInfo, { index = i, date = s.date })
			end
		end
	end
end

function Site:GoToPage(pageName)
	self.currentPage = pageName
	
	page = self:GetCurrentPage()

	if (page == nil) then
		error(string.format("Tried to GotoPage unknown page %s", pageName))
	end

	self.downloadPhase = 0
	self.firstVisibleIndex = 1
	self.lastShownItem = -1
	self.bShowingItemDetails = false

	-- go right into details mode for the message
	if (page.type == "message") then
		self.detailsIndex = 1
	end
end

function Site:GetCurrentPage()
	return self.pages[self.currentPage]
end

function Site:GetEntries()
	local page = self:GetCurrentPage()

	if (page.type == "menu") then
		return self:GetMenuEntries(page)
	elseif (page.type == "title") then
		return self:GetTitleEntries(page)
	elseif (page.type == "password") then
		return self:GetPasswordEntries(page)
	elseif (page.type == "download") then
		return self:GetDownloadEntries(page)
	elseif (page.type == "list" or page.type == "store") then
		return self:GetListEntries(page)
	end

	return {}
end

function Site:GetDetailsString()
	local page = self:GetCurrentPage()

	if (page.type == "message") then
		return page.message
	end

	local item = page.items[self.detailsIndex]

	if page.formatDetails ~= nil then
		return page.formatDetails(item)
	elseif item.message ~= nil then
		return item.message
	end
	
	return "~~unhandled details~~"
end

function Site:OnMessageComplete()
	Gridbox.OnMessageComplete(self)

	local page = self:GetCurrentPage()

	if (page.type == "message") then
		local exit = page.exit
		if (exit == nil) then exit = "main" end
		self:GoToPage(exit)
	end
end

function Site:GetPageHeaderFooterEntries(page, entries)
	table.append(entries, {x = self:CenteredX(self.title), y = 0, text = self.title} )
end

function Site:GetButtonOrSpaceEntries(entries)
	local footer = "Button or [space] to continue"
	table.append(entries, {x = self:CenteredX(footer), y = self.sizeY - 1, text = footer} )
end

function Site:GetMenuEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	for i,v in ipairs(page.items) do
		if (v.level ~= nil and v.level > self.passwordLevel) then
			break
		end
		table.append(entries, {
			x = 10, y = 4 + i,
			text = string.format("%s. %s", v.key:upper(), v.text),
			clickId = i,
			key = v.key,
		})
	end

	return entries
end

function Site:GetTitleEntries(page)
	local entries = {}
	self:GetPageHeaderFooterEntries(page, entries)
	self:GetButtonOrSpaceEntries(entries)

	table.append(entries, {x=0, y=3, text=page.message, wrap=self.sizeX })

	return entries

--	local line = 2
--	local lines = string.SplitLines(page.message, self.sizeX)
--	for i,l in ipairs(lines) do
--		table.append(entries, {x=0, y=line, text=l })
--		line = line + 1
--	end
--	return entries
end

function Site:GetPasswordEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	local X = self:CenteredX("Enter password:")
	table.append(entries, {x = X, y = 2, text = "Enter password:"})
	if (self.passwordFailed) then
		table.append(entries, {x = X + 4, y = 6, text = "Access denied."})
		self:GetButtonOrSpaceEntries(entries)
	else
		table.append(entries, {x = X, y = 4, entryTag = "password"})
	end
	return entries
end

function Site:GetDownloadEntries(page)
	local entries = {}
	for i,v in ipairs(page.items) do
		if (v.software == nil) then
			table.append(entries, {
				x = 10, y = 4 + i,
				text = string.format("%s. %s", v.key:upper(), v.text),
				clickId = i,
				key = v.key,
			})
		else
			print("software: ", v.software)
			print("name: ", Items[v.software].name)
			local name = Items[v.software].name
			local version = Items[v.software].version
			table.append(entries, {
				x = 10, y = 4 + i,
				text = string.format("%s. %s %d.0", v.key, name, version),
				clickId = i,
				key = v.key,
			})
		end
	end

	if (self.downloadPhase == 1 or self.downloadPhase == 3) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . ."})
	elseif (self.downloadPhase == 2) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . . download complate"})
	elseif (self.e == 4) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . . deck is full"})
	end

	return entries
end

function Site:IsItemVisible(item)
	if (item.condition ~= nil) then
		local succeeded, cond = pcall(item.condition)
		if not (succeeded and cond) then
			-- function asserted, or returned false, skip
			return false
		end
	end

	return true
end

function Site:GetListEntries(page)
	local entries = {}

	-- page headers
	self:GetPageHeaderFooterEntries(page, entries)

	if self.detailsIndex > 0 then
		
	else
		local curY = 2
		-- column headers
		local headers = ""
		for i,v in ipairs(page.columns) do
			-- add 1 for space between columns
			headers = headers:appendPadded(v.field, v.width + 1)
		end
		table.append(entries, {x = 3, y = curY, text = headers})

		if (page.type == "store") then
			table.append(entries, {x = 0, y = curY + 1, text = "--------------------------------------------------------------------------"})
		end

		-- items
		curY = curY + 2

		-- init loop counters
		local localIndex = 1
		local listIndex = self.firstVisibleIndex
		local label = ""
		

		-- use unlock table, or the message table itself
		local unlockTable = nil
		if (page.unlockid ~= nil) then
			unlockTable = s.unlockedMessagesInfo[page.unlockid]
		end

		local numTotalItems = #page.items
		if (unlockTable ~= nil) then
			numTotalItems = #unlockTable
		end
		
		-- go until we are end of page or end of list
		while listIndex <= numTotalItems and localIndex <= self.numMessagesPerPage do
			
			local itemIndex = listIndex

			-- use unlock table if used
			if (unlockTable ~= nil) then
				itemIndex = unlockTable[listIndex].index
			end

			local item = page.items[itemIndex]


			if (not self:IsItemVisible(item)) then
				goto loopend
			end

			label = string.format("%d. ", localIndex)
			for i,v in ipairs(page.columns) do
				if v.field == 'date' then
					local date = item[v.field]
					if (unlockTable ~= nil) then
						date = unlockTable[listIndex].date
					end
					field = string.fromDate(date)
				elseif v.field == 'cost' then
					field = string.format("$%d", item[v.field])
				elseif v.field == 'in stock' then
					local numPurchased = s['purchased_' .. item.tag] or 0
					field = tostring(item[v.field] - numPurchased)
				else
					field = tostring(item[v.field])
				end

				-- add 1 for space between columns
				label = label:appendPadded(field, v.width + 1)
			end

			-- add the item with a clickId with list index, and '0'+itemIndex as a key to press
			if (page.hasDetails or page.type == "store") then
				keyPress = string.format("%c", 48 + localIndex)
				table.append(entries, {x = 0, y = curY, text = label, clickId = itemIndex, key = keyPress})
			else
				table.append(entries, {x = 0, y = curY, text = label })
			end

			-- remember last shown item for <more> option
			self.lastShownItem = listIndex

			-- move to next on-screen line
			localIndex = localIndex + 1
			curY = curY + 1

			::loopend::
			-- move to next item in list
			listIndex = listIndex + 1
		end

		if (page.type == "store") then
			table.append(entries, {x = 0, y = curY, text = "--------------------------------------------------------------------------"})
		end

		-- look to see if we need "more" when on the first page
--		local needsMore = false
--		if (self.firstVisibleIndex == 1) then
--			local testItem = self.lastShownItem + 1
--			while (testItem <= #page.items) do
--				if (self:IsItemVisible(page.items[testItem])) then
--					needsMore = true
--					break
--				end
--				testItem = testItem + 1
--			end
--		else
--			needsMore = true
--		end
		local needsMode = numTotalItems > self.numMessagesPerPage

		-- exit / more buttons
		self:AddExitMoreEntries(entries, needsMore)
	end

	return entries
end

function Site:ShouldIgnoreAllInput()
	-- ignore input if downloading
	if (self.downloadPhase > 0) then
		return true
	end

	return false
end


function Site:HandleClickedEntry(id)
	local page = self:GetCurrentPage()

print("Handle cliecked entry", self, page.type, id)

	if page.type == "menu" then
		-- menu click id is index
		self:OnItemSelected(page, page.items[id])
	elseif page.type == "list" then
		self.detailsIndex = id
	elseif page.type == "store" then
		self:SelectStoreItem(id)
	elseif page.type == "download" then
		self:OnDownloadSelected(page, page.items[id])
	end
end

function Site:OnPurchasedStoreItem(item)
end

function Site:SelectStoreItem(id)
	local page = self:GetCurrentPage()
	local item = page.items[id]

	-- by default, we purchas it if able, and then call a function to manage it

	local puchasedVarName = 'purchased_' .. item.tag
	local numPurchased = s[puchasedVarName] or 0

	if (s.money >= item.cost and item['in stock'] - numPurchased > 0) then
		s.money = s.money - item.cost

		-- mark one as purchased
		s[puchasedVarName] = numPurchased + 1

		self:OnPurchasedStoreItem(item)
	end
end

function Site:OnItemSelected(page, item)
print("onitemselected", page.type)
	if page.type == "menu" then

		print(item.target)

		if item.target == "exit" then
			self:Close()
			return
		end

		self:GoToPage(item.target)
	end
end

function Site:OnDownloadSelected(page, item)

	if (item.target ~= nil) then
		self:GoToPage(item.target)
		return
	end

	-- add the software item by index to the deck
	table.append(s.software, item.software)

	-- todo: check deck storage
	self.downloadPhase = 1
	local t1 = StartTimer(2, self, function() self.downloadPhase = self.downloadPhase + 1 end)
	local t2 = StartTimer(3, self, function() self.downloadPhase = 0 end)

end

function Site:HandleClickedExit()
	local page = self:GetCurrentPage()
	self:GoToPage(page.exit)
end

function Site:HandleClickedMore()
	assert(self.lastShownItem > 0)

	local page = self:GetCurrentPage()
	self.firstVisibleIndex = self.lastShownItem + 1
	if self.firstVisibleIndex > #page.items then
		self.firstVisibleIndex = 1
	end
end

function Site:OnGenericContinueInput()
print("GenerticCIntinue - ", self:GetCurrentPage().type, self.currentPage)
	if (self.detailsIndex > 0) then
		detailsIndex = 0
	elseif (self.currentPage == "title") then
		self:GoToPage("password")
	elseif (self.currentPage == "password" and self.passwordFailed) then
		self:Close()
	end
end

function Site:HandleKeyInput(keyCode, type)
print("Site:HandleKeyInput", type)
	if (type > 0) then
		return false
	end

	self:OnGenericContinueInput()
	return true
end


function Site:HandleMouseInput(x, y) --, type)
print("Site:HandleMouseInput")
	self:OnGenericContinueInput()
	return true
end


function Site:HandleInput(char)

	error("unimplemented")

	page = self:GetCurrentPage()
	char = char:lower()

	if page.type == "menu" then
		-- get the corresponding menu item's target page as current
		for i,v in ipairs(page.items) do
			if v.key == char then
				self:OnItemSelected(page, v)
				return
			end
		end
	end
end

function Site:OnTextEntryComplete(text, tag)
	if (tag == "password") then
		self.passwordFailed = true
print("passwords", self.passwords)
		for i,v in ipairs(self.passwords) do
print("checking ", v)
			if (v == string.lower(text)) then
				self.passwordLevel = i
				self.passwordFailed = falsde
				self:GoToPage("main")
			end
		end
	end
end



ComingSoon = Site:new {
	title = "* UNDER CONSTRUCTION *",
	comLinkLevel = 1,
	
	pages = {
		['title'] = {
			type = "title",
			message = "Nothing to see here yet, it will be in the game eventually."
		},
		
		['password'] = {
			type = "password",
		},
		
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
			}
		}
	}
}

worldchess=ComingSoon
