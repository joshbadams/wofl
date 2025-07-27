
Site = Gridbox:new {
	x = 100,
	y = 40,
	w = 990,
	h = 530,

	comLinkLevel = 1,
	
	currentPage = "main",
	firstVisibleIndex = 1,
	
	downloadPhase = 0,

	passwords = {},
}

function Site:CheckAllPagesForUnlocks()
	for i,v in pairs(self.pages) do
		if (v.unlockid ~= nil) then
			self:CheckForUnlocks(v)
		end
	end
end

function Site:OpenBox()

	self:CheckAllPagesForUnlocks()

	self.passwordLevel = 0
	self.passwordFailed = false
print("num passwrords = ", #self.passwords)
	if (#self.passwords > 0) then
		self:GoToPage("title")
	else
		self:GoToPage("main")
	end

	currentSite = self
end

function Site:Close()
	currentSite = nil
	Gridbox.Close(self)
end


function Site:HasUnlocked(unlockedInfo, index)
	for k,v in pairs(unlockedInfo) do
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
		if (self:HasUnlocked(unlockedInfo, i) == false and s.date >= v.date) then
			-- for the pure date unlocks, remember it's original date
			if (v.condition == nil) then
				table.insert(unlockedInfo, { index = i, date = v.date })
			-- for unlock callbacks, remember the current date was when it was unlocked
			elseif (v.condition(self)) then
				table.insert(unlockedInfo, { index = i, date = s.date })
			end
		end
	end
end

function Site:GoToPage(pageName)
	-- process leaving a page
	if (self.currentPage == "title") then
		ReorderBox(self, 0)
	end

	-- set next page
	self.currentPage = pageName
	local page = self:GetCurrentPage()
	if (page == nil) then
		error(string.format("Tried to GotoPage unknown page %s", pageName))
	end

	-- reset stuff
	self.downloadPhase = 0
	self.firstVisibleIndex = 1
	self.lastShownItem = -1
	self.bShowingItemDetails = false
	self.sendMessagePhase = 1
	self.sequencing = false


	-- go right into details mode for the message
	if (page.type == "message") then
		self.detailsIndex = 1
	end

	-- allow inv button press on title page
	if (pageName == "title") then
		ReorderBox(self, 1)
	end
end

function Site:GetCurrentPage()
	return self.pages[self.currentPage]
end

function Site:GetEntries()
	local entries = {}
	local page = self:GetCurrentPage()

	if (page.type == "menu") then
		entries = self:GetMenuEntries(page)
	elseif (page.type == "title") then
		entries = self:GetTitleEntries(page)
	elseif (page.type == "password") then
		entries = self:GetPasswordEntries(page)
	elseif (page.type == "download") then
		entries = self:GetDownloadEntries(page)
	elseif (page.type == "skills") then
		entries = self:GetSkillsEntries(page)
	elseif (page.type == "list" or page.type == "store") then
		entries = self:GetListEntries(page)
	elseif (page.type == "sendmessage") then
		entries = self:GetSendMessageEntries(page)
	elseif (page.type == "generic") then
		entries = self:GetGenericEntries(page)
	elseif (page.type == "custom") then
		entries = self:GetCustomEntries(page)
	end

	-- if the page has any 'entries', then append them, allowing for function calls as needed
	if (page.entries ~= nil) then
		for _,entry in ipairs(page.entries) do
			local new = {}
			for k,v in pairs(entry) do
				if (type(v) == 'function') then
					new[k] = v(self)
				else
					new[k] = v
				end
			end
			table.append(entries, new)
		end
	end

	return entries
end

function Site:GetDetailsString()
	local page = self:GetCurrentPage()
print("getting details", self.currentPage, page, page.type, page.message)
	if (page.type == "message") then
		if (type(page.message) == 'function') then
			return page.message(self)
		else
			return page.message
		end
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

function Site:GetMenuEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	local startY = 3
	if (startY >= self.sizeY - #page.items) then
		startY = self.sizeY - #page.items - 1
	end
	for i,v in ipairs(page.items) do
		if (v.level ~= nil and v.level > self.passwordLevel) then
			break
		end
		table.append(entries, {
			x = 10, y = startY + i,
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
	elseif (self.passwordLevel > 0) then
		table.append(entries, {x = X, y = 4, text = self.passwords[self.passwordLevel]})
		local message = "Cleared for level " .. self.passwordLevel .. " access."
		table.append(entries, {x = self:CenteredX(message), y = 6, text = message})
		self:GetButtonOrSpaceEntries(entries)
	elseif (self.sequencing) then
		table.append(entries, {x = X, y = 4, text = "<sequencing...>"})
	else
		table.append(entries, {x = X, y = 4, entryTag = "password"})
	end
	return entries
end

function Site:GetDownloadEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)
	if (page.title ~= nil) then
		table.append(entries, { x = self:CenteredX(page.title), y = 2, text = page.title})
	end


	for i,v in ipairs(page.items) do
		if (v.software == nil) then
			table.append(entries, {
				x = 10, y = 4 + i,
				text = string.format("%s. %s", v.key:upper(), v.text),
				clickId = i,
				key = v.key,
			})
		else
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

	if (self.downloadPhase == 1) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . ."})
	elseif (self.downloadPhase == 2) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . . download complate"})
	elseif (self.downloadPhase == 3) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . . deck is full"})
	elseif (self.downloadPhase == 4) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Transmitting . . . incompatible deck"})
	end

	return entries
end

function Site:GetSkillsEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)
	
	for i,v in ipairs(page.items) do
		if (v.skill == nil) then
			table.append(entries, {
				x = 10, y = 4 + i,
				text = string.format("%s. %s", v.key:upper(), v.text),
				clickId = i,
				key = v.key,
			})
		else
			local name = Items[v.skill].name
			table.append(entries, {
				x = 10, y = 4 + i,
				text = string.format("%s. %s (lvl %d)", v.key, name, v.level),
				clickId = i,
				key = v.key,
			})
		end
	end

	if (self.downloadPhase == 1) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Upgrading . . ."})
	elseif (self.downloadPhase == 2) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Upgrading . . . Upgrade complete."})
	elseif (self.downloadPhase == 3) then
		table.append(entries, { x = 0, y = self.sizeY - 2, text = "Upgrading . . . Unable to upgrade."})
	end


	return entries
end



function Site:GetGenericEntries(page)
	local entries = {}

	if (page.showHeader) then
		self:GetPageHeaderFooterEntries(page, entries)
	end
	
	if (page.showButtonOrSpace) then
		self:GetButtonOrSpaceEntries(entries)
	end

	return entries
end

function Site:GetCustomEntries(page)
	return {}
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

	if (self.detailsIndex == 0) then
		self:GetListEntriesEx(page, entries, 1, self.numMessagesPerPage, false, page.type == "store", page.type == "store" or page.hasDetails or page.targetOnClick ~= nil)
	end

	return entries
end

function Site:GetSendMessageEntries(page)
	local entries = {}

	-- skip the To: phase if there isn't one'
	if (page.noDateTo and self.sendMessagePhase == 1) then
		self.sendMessagePhase = 2
	end

	table.append(entries, { x = 5, y = 0, text = page.messagePrompt or "Send Message:" })
	if (not page.noDateTo) then
		table.append(entries, { x = 0, y = 4, text = "date: " .. string.fromTodaysDate() })
		table.append(entries, { x = 0, y = 5, text = "to:   " })
	end

	if (self.sendMessagePhase == 3) then
		table.append(entries, { x = 5, y = 2, text = (page.sendPrompt or "Send this message") .. " (" })
		table.append(entries, { x = 24, y = 2, text = "Y", clickId = 1, key = "y" })
		table.append(entries, { x = 25, y = 2, text = "/" })
		table.append(entries, { x = 26, y = 2, text = "N", clickId = 2, key = "n" })
		table.append(entries, { x = 27, y = 2, text = ")" })
		table.append(entries, { x = 1, y = 6, text = self.message, wrap = -1 })
	elseif (self.sendMessagePhase == 2) then
		table.append(entries, { x = 5, y = 2, text = "Press ESC when done" })
		table.append(entries, { x = 0, y = 6, text = ">" })
		table.append(entries, { x = 1, y = 6, entryTag = "sendmessage_message", multiline = true })
	end

	if (not page.noDateTo) then
		if (self.sendMessagePhase == 1) then
			table.append(entries, { x = 6, y = 5, entryTag = "sendmessage_to" })
		else
			table.append(entries, { x = 6, y = 5, text = self.recipient })
		end
	end

	return entries
end

function Site:GetListEntriesEx(page, entries, startY, numItemsPerPage, lineBeforeHeader, listEntryLines, selectableItems)
	local curY = startY
	local numberColumnWidth = 0
	
	if (selectableItems) then
		numberColumnWidth = 3
	end

	if (lineBeforeHeader) then
		table.append(entries, {x = 0, y = curY, text = string.rep("-", self.sizeX)})
	end
	curY = curY + 1

	
	-- column headers
	local headers = ""
	for i,v in ipairs(page.columns) do
		-- add 1 for space between columns
		local width = v.width
		if (width < 0) then
			width = self.sizeX + width - numberColumnWidth
		end
		headers = headers:appendPadded(v.field, width + 1)
	end
	table.append(entries, {x = numberColumnWidth, y = curY, text = headers})

	if (listEntryLines) then
		table.append(entries, {x = 0, y = curY + 1, text = string.rep("-", self.sizeX)})
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
	while listIndex <= numTotalItems and localIndex <= numItemsPerPage do
		
		local itemIndex = listIndex

		-- use unlock table if used
		if (unlockTable ~= nil) then
			itemIndex = unlockTable[listIndex].index
		end

		local item = page.items[itemIndex]


		if (not self:IsItemVisible(item)) then
			goto loopend
		end

		label = ""
		if (selectableItems) then
			label = string.format("%d. ", localIndex)
		end
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
			local width = v.width
			if (width < 0) then
				width = self.sizeX + width - string.len(label)
			end
			label = label:appendPadded(field, width + 1)
		end

		-- add the item with a clickId with list index, and '0'+itemIndex as a key to press
		if (selectableItems) then
			table.append(entries, {x = 0, y = curY, text = label, clickId = itemIndex, key = tostring(localIndex)})
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

	if (listEntryLines) then
		table.append(entries, {x = 0, y = curY, text = string.rep("-", self.sizeX)})
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
	local needsMore = numTotalItems > numItemsPerPage

	-- exit / more buttons
	self:AddExitMoreEntries(entries, needsMore)

	return entries
end

function Site:ShouldIgnoreAllInput()
	-- ignore input if downloading or base class wants to block
	return (self.downloadPhase > 0 or Gridbox:ShouldIgnoreAllInput(self))
end


function Site:HandleClickedEntry(id)
	local page = self:GetCurrentPage()

	if page.type == "menu" then
		-- menu click id is index
		self:OnItemSelected(page, id, page.items[id])
	elseif page.type == "list" then
		if (page.targetOnClick ~= nil) then
			self.selectedListItem = id
			self:GoToPage(page.targetOnClick)
		else
			self.detailsIndex = id
		end
	elseif page.type == "store" then
		self:SelectStoreItem(id)
	elseif page.type == "download" then
		self:OnDownloadSelected(page, page.items[id])
	elseif page.type == "skills" then
		self:OnSkillUpgradeSelected(page, page.items[id])
	elseif page.type == "sendmessage" then
		self:OnSendMessageSelected(page, id)
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

function Site:OnItemSelected(page, id, item)
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

	self.downloadPhase = 1

	local deck = Items[s.currentDeckId]

	-- add the software item by index to the deck
	if (Items[item.software].scope == "fake") then
		StartTimer(2, self, function() self.downloadPhase = 4 end)
	elseif (#s.software >= deck.capacity) then
		StartTimer(2, self, function() self.downloadPhase = 3 end)
	else
		table.append(s.software, item.software)
		StartTimer(2, self, function() self.downloadPhase = 2 end)
	end
	
	-- allow input after a bit
	StartTimer(3, self, function() self.downloadPhase = 0 end)

end

function Site:OnSkillUpgradeSelected(page, item)

	if (item.target ~= nil) then
		self:GoToPage(item.target)
		return
	end

	self.downloadPhase = 1

	-- add the software item by index to the deck
--	if (Items[item.software].scope == "fake") then
--		StartTimer(2, self, function() self.downloadPhase = 4 end)
	if (s.skillLevels[item.skill] == 0 or s.skillLevels[item.skill] >= item.level) then
		StartTimer(2, self, function() self.downloadPhase = 3 end)
	else
		s.skillLevels[item.skill] = item.level
		StartTimer(2, self, function() self.downloadPhase = 2 end)
	end
	
	-- allow input after a bit
	StartTimer(3, self, function() self.downloadPhase = 0 end)

end
function Site:ProcessMessage(recipient, message)
end

function Site:OnSendMessageSelected(page, id)
	if (self.sendMessagePhase == 3) then
		if (id == 1) then
			self:ProcessMessage(self.recipient, self.message)
			self:CheckAllPagesForUnlocks()
		end
		self:GoToPage(page.exit or "main")
	end
end

function Site:HandleClickedExit()
	local page = self:GetCurrentPage()
	self:GoToPage(page.exit)
end

function Site:HandleClickedMore()
	assert(self.lastShownItem > 0)

	local page = self:GetCurrentPage()
	self.firstVisibleIndex = self.lastShownItem + 1

	-- use unlock table, or the message table itself
	local unlockTable = nil
	if (page.unlockid ~= nil) then
		unlockTable = s.unlockedMessagesInfo[page.unlockid]
	end

	local numTotalItems = #page.items
	if (unlockTable ~= nil) then
		numTotalItems = #unlockTable
	end
	if (self.firstVisibleIndex > numTotalItems) then
		self.firstVisibleIndex = 1
	end
end

function Site:OnGenericContinueInput()
	local page = self:GetCurrentPage()

	if (self.detailsIndex > 0) then
		self.detailsIndex = 0
	elseif (page.type == "generic" and page.exit ~= nil) then
		self:GoToPage(page.exit)
	elseif (self.currentPage == "title") then
		self:GoToPage("password")
	elseif (self.currentPage == "password") then
		if (self.passwordFailed) then
			self:Close()
		elseif (self.passwordLevel > 0) then
			self:GoToPage("main")
		end
	end
end

function Site:HandleInput(char)

	error("unimplemented")

	page = self:GetCurrentPage()
	char = char:lower()

	if page.type == "menu" then
		-- get the corresponding menu item's target page as current
		for i,v in ipairs(page.items) do
			if v.key == char then
				self:OnItemSelected(page, i, v)
				return
			end
		end
	end
end

function Site:OnTextEntryComplete(text, tag)

	if (tag == "password") then
		self.passwordFailed = true
		if (text == "1") then
			self.passwordLevel = 1
			self.passwordFailed = false
		elseif (text == "2") then
			self.passwordLevel = 2
			self.passwordFailed = false
		elseif (text == "3") then
			self.passwordLevel = 3
			self.passwordFailed = false
		elseif (text == "4") then
			self.passwordLevel = 4
			self.passwordFailed = false
		end
		for i,v in ipairs(self.passwords) do
			if (v == string.lower(text)) then
				self.passwordLevel = i
				self.passwordFailed = false
			end
		end
	elseif (tag == "sendmessage_to") then
		self.recipient = text
		self.sendMessagePhase = 2
	elseif (tag == "sendmessage_message") then
		self.message = text
		self.sendMessagePhase = 3
	end

end

-- returns error if it can't be used:
--   nil: can be used now
--   message: the error when trying to use it
--   empty string: can't be used but don't show an error, just don't use it
function Site:CanUseSoftware(software)
	if (software.scope == "site") then
		if (self.currentPage == "title" and (software.name == "Scout" or software.name == "Sequencer")) then
			return nil
		else
			return "Nothing happens."
		end
	else
		return ""
	end
end

function Site:UseSoftware(software)
	if (software == nil) then
		return
	end

	if (self.currentPage == "title") then
		if (software.name == "Scout") then
			self.messageBox = OpenBox("MessageBox")
			self.messageBox:SetMessage("scouting....")
			self.messageBox.blockInput = true
			StartTimer(3, self, function() self.messageBox.blockInput = false; self.messageBox:SetMessage("The are " .. #self.passwords .. " level(s)."); end )
		elseif (software.name == "Sequencer") then
			self:StartSequencing()
		end
	else
--		self:Close()
	end

end


function Site:StartSequencing()
	self:GoToPage("password")
	self.sequencing = true
	self.blockInput = true

	local time = 10
	StartTimer(time, self, function() self.sequencing = false; self.blockInput = false; self.passwordLevel = 1; end)

	UpdateBoxes()
end


ComingSoon = Site:new {
	title = "* UNDER CONSTRUCTION *",
	comLinkLevel = 1,
	
	pages = {
		['title'] = {
			type = "title",
			message = "Nothing to see here yet, it will be in the game eventually. Hit Enter a few times to exit."
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

BankGemein = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"eintritt",
		"verboten"
	}
}
bankgemein=BankGemein
-- Coordinates--5-304/320  AI--none

BozoBank = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"<sequencer>"
	}
}
bozobank=BozoBank
-- Coord.--5-336/368  AI--none

Justice = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"<sequencer>"
	}
}
justice=Justice
-- Coord.--1-416/112  AI--none

FreeMatrix = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"CFM",
		"<cyberspace>"
	}
}
freematrix=FreeMatrix
-- Coord.--1-352/112  AI--Sapphire weakness=Sophistry

Brainstorm = ComingSoon:new {
	comLinkLevel = 4,
	passwords = {
		"perilous",
		"<cyberspace>"
	}
}
brainstorm=Brainstorm
-- Coord.--1-320/32  AI--none

EastSeaBod = ComingSoon:new {
	comLinkLevel = 4,
	passwords = {
		"longisland",
		"<cyberspace>"
	}
}
eastseabod=EastSeaBod
-- Coord.--1-384/32  AI--none

HosakaCorp = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"biosoft",
		"fungeki",
		"<cyberspace>"
	}
}
hosakacorp=HosakaCorp
-- Coord.--2-144/160  AI--none

Musaborind = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"subaru",
		"<cyberspace>",
	}
}
musaborind=Musaborind
-- Coord.--2-208/208  AI--Greystoke (badass!) weakness=hemlock 1.0

Voyager = ComingSoon:new {
	comLinkLevel = 6,
	passwords = {
		"apollo",
		"<cyberspace>",
	}
}
voyager=Voyager
-- Coord.--1-448/32  AI--Hal weakness=Logic


Yakuza = ComingSoon:new {
	comLinkLevel = 5,
	passwords = {
		"yak",
		"<cyberspace>"
	}
}
yakuza = Yakuza
-- Coord.--1-480/80  AI--none



--------------------------------------------------------------------

Soften = Site:new {
	title = "* Software Enforcement Agency *",
	comLinkLevel = 3,
	passwords = {
		"permafrost",
		"<cyberspace>"
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = " ",
		},

		['password'] = { type = "password" },

		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Supervisor's Memo", target = "memo" },
				{ key = '2', text = "Bulletin Board", target = "bbs" },
				{ key = '3', text = "Software Library", target = "library" },
				{ key = '4', text = "Skill Upgrade", target = "skills" },
				{ key = '5', text = "View Arrest Warrant List", target = "warrants" },
			}
		},
		
		['memo'] = {
			type = "message",
			message = "\nSEA FIELD SUPERVISORS:\n\nField Supervisors should take note of the new matrix simulator protection softwarez that have just been made available on this system. It will be the responsibility of the Field Supervisors to disseminate copies of these warez to their qualified cyberspace operatives.\nDue to the high number of requests for current information, the Administrative Bureau has approved the activation of of a question-and-answer bulletin board service should increase the speed of response for Field Supervisor information-gathering purposes.\n\nSEA FIELD AGENTS:\n\nField agents who would like to improve their interrogation and conversational abilities would be well advisted to make use of the COPTALK tutorial. Fourth level CopTalk ability is required for Senior Field Agent status. While this tutorial has been available to download for the last eight months, our records show that usage has been light. Let's see more ambition out there!"
		},
		
		['library'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 202 }, -- COMLINK 4.0
				{ key = '2', software = 259 }, -- SEQUENCER
			}
		},

		['bbs'] = {
			type = "list",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item)
				if (item.to == "SEA") then
					return string.format("Date: %s\nFrom: Gibson, W.\n%s", string.fromDate(item.date), item.message)
				else
					return string.format("Date: %s\nTo: Gibson, W.\n%s", string.fromDate(item.date), item.message)
				end
			end,
			items = {
				{ date = 111658, to = "SEA", from = "W. Gibson", message = "One of my field agents, working undercover as a cyberspace cowboy known as \"MR. DOS,\" seems to have vanished. He was on the trail of some microsoft design thieves in cyberspace when I last heard from him. Now he's been missing for two weeks. Has he been reassigned to a deep cover on another operation? Is he on loan to the Turing people? And why wasn't I informed that he was off my team?" },
				{ date = 111658, to = "W. Gibson", from = "SEA", message = "With regard to your missing field agent, operating as \"MR. DOS,\"we have no idea where he is. He has not been reassigned elsewhere. Maybe you misplaced him?" },
				{ date = 111658, to = "SEA", from = "W. Gibson", message = "Regarding my field agent, \"MR. DOS,\" I respectfully request an explanation as to how you think I could have misplaced him. This isn't a piece of software we're talking about. MR. DOS is a human field agent." },
				{ date = 111658, to = "W. Gibson", from = "SEA", message = "Solve your own problems. That's what we hired you for in the first place." },
			}
		},
		['skills']  = {
			type = "skills",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', skill = 400, level = 2 }
			}
		},
		['warrants'] = {
			type = "list",
--			title = "Arrest Warrants",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "MATSUMOTU MIKI", ['BAMA ID'] = "781346759", message = "Wanted for Smuggling." },
				{ Name = "PARSIFAL", ['BAMA ID'] = "673638269", message = "Wanted for Piracy." },
				{ Name = "FARGO FERGUS", ['BAMA ID'] = "666999666", message = "Wanted for Supercode programming." },
				{ Name = "STACKPOLNIK MIKL", ['BAMA ID'] = "426813202", message = "Wanted for Software pandering." },
				{ Name = "ROBINSON ASHLEY", ['BAMA ID'] = "042385003", message = "Wanted for Smuggling." },
			}
		}

	},
	
	-- Coord.--1-352/64  AI--none
}
soften=Soften




function MakeRAMColumn(id)
	return string.appendRightPadded("", tostring(Items[id].capacity), 3)
end

function MakeNameColumn(id)
	local out = ""
	if (Items[id].manufacturer ~= nil) then
		out = Items[id].manufacturer .. " "
	end
	out = out .. Items[id].name
	return out
end

AsanoComp = ComingSoon:new {
	title = "* Asano Computing *",

	comLinkLevel = 1,
	passwords = {
		"customer",
		"vendors",
		"<cyberspace>"
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = "When you use the best, you are never disappointed....\n\nTo look at our current hardware list, just enter the password \"CUSTOMER\".",
		},

		['password'] = { type = "password" },

		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Catalog", target = "catalog" },
				{ key = '2', text = "Manufacturers", target = "vendors", level = 2 },
			}
		},
		
		['catalog'] = {
			type = "custom",
			columns = { { field = 'Manufacturer and Model', width = -4 }, { field = 'RAM', width = 3 } },
			items = {
				{ ['Manufacturer and Model'] = MakeNameColumn(100), RAM = MakeRAMColumn(100) },
				{ ['Manufacturer and Model'] = MakeNameColumn(101), RAM = MakeRAMColumn(101) },
				{ ['Manufacturer and Model'] = MakeNameColumn(102), RAM = MakeRAMColumn(102) },
				{ ['Manufacturer and Model'] = MakeNameColumn(103), RAM = MakeRAMColumn(103) },
				{ ['Manufacturer and Model'] = MakeNameColumn(104), RAM = MakeRAMColumn(104) },
				{ ['Manufacturer and Model'] = MakeNameColumn(105), RAM = MakeRAMColumn(105) },
				{ ['Manufacturer and Model'] = MakeNameColumn(106), RAM = MakeRAMColumn(106) },
				{ ['Manufacturer and Model'] = MakeNameColumn(107), RAM = MakeRAMColumn(107) },
				{ ['Manufacturer and Model'] = MakeNameColumn(108), RAM = MakeRAMColumn(108) },
				{ ['Manufacturer and Model'] = MakeNameColumn(109), RAM = MakeRAMColumn(109) },
				{ ['Manufacturer and Model'] = MakeNameColumn(110), RAM = MakeRAMColumn(110) },
				{ ['Manufacturer and Model'] = MakeNameColumn(111), RAM = MakeRAMColumn(111) },
				{ ['Manufacturer and Model'] = MakeNameColumn(112), RAM = MakeRAMColumn(112) },
				{ ['Manufacturer and Model'] = MakeNameColumn(113), RAM = MakeRAMColumn(113) },
				{ ['Manufacturer and Model'] = MakeNameColumn(114), RAM = MakeRAMColumn(114) },
				{ ['Manufacturer and Model'] = MakeNameColumn(115), RAM = MakeRAMColumn(115) },
				{ ['Manufacturer and Model'] = MakeNameColumn(116), RAM = MakeRAMColumn(116) },
				{ ['Manufacturer and Model'] = MakeNameColumn(117), RAM = MakeRAMColumn(117) },
				{ ['Manufacturer and Model'] = MakeNameColumn(118), RAM = MakeRAMColumn(118) },
				{ ['Manufacturer and Model'] = MakeNameColumn(119), RAM = MakeRAMColumn(119) },
				{ ['Manufacturer and Model'] = MakeNameColumn(120), RAM = MakeRAMColumn(120) },
				{ ['Manufacturer and Model'] = MakeNameColumn(121), RAM = MakeRAMColumn(121) },
				{ ['Manufacturer and Model'] = MakeNameColumn(122), RAM = MakeRAMColumn(122) },
				{ ['Manufacturer and Model'] = MakeNameColumn(123), RAM = MakeRAMColumn(123) },
			}
		},
		
		['vendors'] = {
			type = "generic",
			showHeader = true,
			showButtonOrSpace = true,
			exit = "main",
			entries = {
				{x = 5,  y = 2, text = "Manufacturer"},
				{x = 30, y = 2, text = "Link Code"},
				{x = 0,  y = 3, text = function(self) return string.rep("-", self.sizeX) end},
				{x = 5,  y = 4, text = "Fuji Electric"},
				{x = 30, y = 4, text = "FUJI"},
				{x = 5,  y = 5, text = "Hosaka"},
				{x = 30, y = 5, text = "HOSAKACORP"},
				{x = 5,  y = 6, text = "Musabori Industries"},
				{x = 30, y = 6, text = "MUSABORIND"},
				{x = 0,  y = 7, text = function(self) return string.rep("-", self.sizeX) end},
				{x = 0,  y = 8, text = "For reordering, these mfg. sales reps. must be seen personally:", wrap = -1},
				{x = 7,  y = 10, text = "Cray"},
				{x = 27, y = 10, text = "Yamamitsu"},
				{x = 7,  y = 11, text = "Moriyama"},
				{x = 27, y = 11, text = "Ono-Sendai"},
				{x = 7,  y = 12, text = "Ausgezeichnet"},
				{x = 27, y = 12, text = "Ninja"},
			}
		}

	},
	-- Coordinates-- 0-16/112  AI--none
}
asanocomp=AsanoComp

function AsanoComp:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)
	
	if (self.currentPage == "catalog") then
		local title = "Current Hardware For Sale"
		table.append(entries, {x = self:CenteredX(title), y = 2, text = title})
		table.append(entries, {x = 0, y = self.sizeY - 3, wrap = -1, text = "Come to our store for the latest in up to date software and hardware."})

		self:GetListEntriesEx(page, entries, 3, self.sizeY - 10, true, true, false)
	end

	return entries
end



Consumerev = Site:new {
	title = "$ Consumer Review $",
	comLinkLevel = 1,
	passwords = {
		"review",
		"<cyberspace>"
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = "Did you know that there are currently 24 cyberdecks avilable from 9 different manufacturers? How do you choose between them? CONSUMER REVIEW gives you up-to-date ratings by experts, telling you which products to off the most in terms of performance, value and, quality.",
			entries = {
				{x = 0, y = 10, text = "      Type 'REVIEW' for access."}
			}
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "generic",
			exit = "menu",
			entries = {
				{ x = 0, y = function(self) return self.sizeY - 3 end, wrap = -1, text = function(self)
						if (self.hadMoney) then return "200 credits have been deducted from your chip."
						else return "Insufficient credits in chip."
						end
					end
				}
			}
		},
		['menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Rankings of all models", target = "all" },
				{ key = '2', text = "Flatline category", target = "flatline" },
				{ key = '3', text = "Triff category", target = "triff" },
				{ key = 'a', text = "Ausgezeichnet", target = "a" },
				{ key = 'b', text = "Blue Light Special", target = "b" },
				{ key = 'm', text = "Moriyama", target = "m" },
				{ key = 'n', text = "Ninja", target = "n" },
				{ key = 'o', text = "Ono-Sendai", target = "o" },
				{ key = 's', text = "Samurai", target = "s" },
				{ key = 'y', text = "Yamamitsu", target = "y" },
			},
			entries = {
				{x = 0, y = 2, text = "    * denots cyberspace capable decks."}
			}
		},
		['all'] = {
			type = "message",
			exit = "menu",
			message = "Rankings of all tested models in order of preference:\n\nOno-Sendai Cyberspace VII *\nSamurai Seven *\nNinja 5000 *\nMoriyama Bushido\nBlue Light Special\nAsugezeichnet 188 BJB\nYamamitsu UXB",
		},
		['flatline'] = {
			type = "message",
			exit = "menu",
			message = "FLATLINE\nThe special FLATLINE category is reserved for those decks that our experts \"wouldn't touch with a ten foot logic probe.\"\n\nManufacturer: YAMAMITSU\nModel: UXB\nRAM: 5\n\nOur experts agreethat the Yamamitsu UXB is the absolute worst of the worst. When our test was powered up, it exploded and put our expert operator in hospital downtime for two weeks.\n\nManufacturer: AUSGEZEICHNET\nModel: 188 BJB\nRAM: 5\n\nAusgezeichnet is the German word for \"excellent,\" but nothing is could be further from the truth in this case. The low price has created a high demand for this model, despite its notorious repair record. Out test model destroyed all of our softwarez!\n\nManufacturer: UNKNOWN\nModel: BLUE LIGHT SPECIAL\nRAM: 10\n\nThe Blue Light Special is the cheapest deck on the market today. The bugs in this system are subtle and may not appear for some time. However, as soon as the bugs do appear, the Blue Light Special should be considered armed and dangerous.",
		},
		['triff'] = {
			type = "message",
			exit = "menu",
			message = "TRIFF:\nThe TRIFF category is reserved for those few matrix simulators that exceed the high standards of the CONSUMER REVIEW staff.\n\nManufacturer: ONO-SENDAI\nModel: CYBERSPACE VII *\nRAM: 25\n\nThe Cyberspace Seven is the top of the line. The case is indestructible and the interphase is smooth. The only disadvantage of the Cyberspace Seven is its price, which is astronomical. If you're not just another joeboy, you'll sell your whole body to raise the creditw for buying one of these.\n\nManufacturer: SAMURAI\nModel: SEVEN *\nRAM: 25\n\nWhile the Samurai Seven is less expensive than the Ono-Sendai Cyberspace Seven, it shares many of the same features. However, Samurai is a new company and has not yet established the sort of reliability record which will allow it to compete with Ono-Sendai. By next year, we may be able to recommend this deck as a cheaper substitute for the Cyberspace Seven.\n\nManufacturer: NINJA\nModel: 5000 *\nRAM: 25\n\nAccording to Ninja promotional material, the 5000 is a \"cyberspace cowboy's dream,\" (although to be honest, there was some confusion in translating the Japanese word for \"dream\" into English. \"Nightmare\" was another possible translation). The 5000 seems to perform at least as well as the Samurai Seven, but at a cheaper price.",
		},
		['a'] = {
			type = "message",
			exit = "menu",
			message = "AUSGEZEICHNET:\nGood prices, but their models vary greatly in quality.\nManufacturer: AUSGEZEICHNET\nModel: 188 BJB\nRAM: 5\n\nAusgezeichnet is the German word for \"excellent,\" but nothing is could be further from the truth in this case. The low price has created a high demand for this model, despite its notorious repair record. Out test model destroyed all of our softwarez!\n\nOther AUSGEZEICHNET models:\nModel: 350 SL   RAM: 11\nModel: 440 SDI  RAM: 15\nModel: 550 GT   RAM: 20 *",
		},
		['b'] = {
			type = "message",
			exit = "menu",
			message = "BLUE LIGHT SPECIAL:\nWe've never been able to discover who manufacturers the Blue Light Special., but they've been marketing their one deck for five years now. Like a cockroach, you know they're around somewhere but they're hard to find and kill.\n\nManufacturer: UNKNOWN\nModel: BLUE LIGHT SPECIAL\nRAM: 10\n\nThe Blue Light Special is the cheapest deck on the market today. The bugs in this system are subtle and may not appear for some time. However, as soon as the bugs do appear, the Blue Light Special should be considered armed and dangerous.",
		},
		['m'] = {
			type = "message",
			exit = "menu",
			message = "MORIYAMA:\nA reliable manufacturer with a solid line of matrix simulators. They may not have all the bells and whistles of an Ono-Sendai, but they don't cost as much either. A good buy for the amateur cyberspace enthusiast.\n\nManufacturer: MORIYAMA\nModel: BUSHIDO\nRAM: 12\n\nThe Moriyama Bushido is one of the bet starter decks available. The interphase linking system is very smooth. Repairs are rarely necessary with a Moriyama and our test model met all specifications without exceeding them.\n\nOther MORIYAMA models:\nModel: Hiki-Gaeru  RAM: 5\nModel: Gaijin      RAM: 10\nModel: Edokko      RAM: 15\nModel: Katana      RAM: 18\nModel: Tofu        RAM: 20 *\nModek: Shogun      RAM: 24 *",
		},
		['n'] = {
			type = "message",
			exit = "menu",
			message = "NINJA:\nNinja has been in the biz, wth some success, for one whole month now. In that time, very few of their decks have been returned to the dealers as unacceptable.\n\nManufacturer: NINJA\nModel: 5000 *\nRAM: 25\n\nAccording to Ninja promotional material, the 5000 is a \"cyberspace cowboy's dream,\" (although to be honest, there was some confusion in translating the Japanese word for \"dream\" into English. \"Nightmare\" was another possible translation). The 5000 seems to perform at least as well as the Samurai Seven, but at a cheaper price.\n\nOther NINJA models:\nModel: 4000  RAM: 20 *\nModel: 3000  RAM: 12\nModel: 2000  RAM: 10",
		},
		['o'] = {
			type = "message",
			exit = "menu",
			message = "ONO-SENDAI:\nOno-Sendai is the most respected name in the biz.\n\nManufacturer: ONO-SENDAI\nModel: CYBERSPACE VII *\nRAM: 25\n\nThe Cyberspace Seven is the top of the line. The case is indestructible and the interphase is smooth. The only disadvantage of the Cyberspace Seven is its price, which is astronomical. If you're not just another joeboy, you'll sell your whole body to raise the creditw for buying one of these.\n\nOther ONO-SENDAI models:\nModel: Cyberspace  II  RAM: 11 *\nModel: Cyberspace III  RAM: 15 *\nModel: Cyberspace  VI  RAM: 20 *",
		},
		['s'] = {
			type = "message",
			exit = "menu",
			message = "SAMURAI:\nAn old and respected company since six months ago. The make one model of matrix simulator and this is it.\n\nManufacturer: SAMURAI\nModel: SEVEN *\nRAM: 25\n\nWhile the Samurai Seven is less expensive than the Ono-Sendai Cyberspace Seven, it shares many of the same features. However, Samurai is a new company and has not yet established the sort of reliability record which will allow it to compete with Ono-Sendai. By next year, we may be able to recommend this deck as a cheaper substitute for the Cyberspace Seven.",
		},
		['y'] = {
			type = "message",
			exit = "menu",
			message = "YAMAMITSU:\nYamamitsu has been in the bix for four years under its current name, producing middle-of-the-road matrix simulators. They have turned mediocrity into a new art form with the introduction of two new models in their XB line of decks.:\n\nManufacturer: YAMAMITSU\nModel: UXB\nRAM: 5\n\nOur experts agreethat the Yamamitsu UXB is the absolute worst of the worst. When our test was powered up, it exploded and put our expert operator in hospital downtime for two weeks.\n\nOther YAMAMITSU models:\nModel: XXB  RAM: 6\nModel: ZXB  RAM: 10",
		},
	}
	-- Coord.--0-32/64  AI--none
}
consumerev=Consumerev

function Consumerev:GoToPage(pageName)
	if (pageName == "main") then
		if (s.money >= 200) then
			self.hadMoney = true
			s.money = s.money - 200
		else
			self.hadMoney = false
		end
	end

	Site.GoToPage(self, pageName)
end


Chaos = Site:new {
	title = "* Panther Moderns *",
	comLinkLevel = 2,
	passwords = {
		"mainline",
		"<cyberspace>"
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = " "
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Software Library", target = "library" },
				{ key = '2', text = "Modern BBS", target = "bbs_view" },
				{ key = '3', text = "Send Message", target = "bbs_send" },
			}
		},
		['library'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 201 }, -- COMLINK 3.0
				{ key = '2', software = 280 }, -- MINDBENDER [fake]
				{ key = '3', software = 281 }, -- VIDEOSOFT [fake]
			}
		},
		['bbs_view'] = {
			type = "list",
			title = "Bulletin Board",
			unlockid = "chaos_bbs",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Everyone", from = "Modern Yutaka", message = "Good one. Cuwboy named Chipdancer owed me a favor. Broke into the Hosaka base with Comlink 5.0, used \"FUNGEKI\", and then added my name to their employee list. Received paychecks for six weeks before anyone noticed. Only risk was walking in to pick up check." },
				{ date = 111658, to = "All", from = "Modern Miles", message = "Julius Deane knows Cryptology. He also wanted to let people know he's got some hard to find skill chips, in case anyone's interested." },
				{ date = 111658, to = "Everyone", from = "Polychrome", message = "Screaming Fist has Easy Rider 1.0 in their base. Lets you cross zones without having to go to another cyberjack." },
				{ date = 111658, to = "Angelo", from = "Lupus", longfrom = "Lupus Yonderboy", message = "Mr. Who paid us on the SENSE/NET gog. He'll remain a Mr. Who, not  Mr. Name. He understands now. Chaos is our mode and modus. Our central kick. Stories to be told, offline in the meeting room. All you have to do is ask." },
				{ date = 111658, to = "Everyone", from = "Modern Larry", longfrom = "Larry Moe", message = "Don't worry about the meet room, no wilsons will get past me. If you're Modern, you're in. Good place for biz. I've got CopTalk now, Lupus has Evasion. See you on the other side." },
				{ date = 111658, to = "Modern Miles", from = "Polychrome", message = "Heard you were looking for a place. Cheap Hotel link code is CHEAPO." },
				{ date = 111658, to = "Everyone", from = "Modern Bob", message = "I have the link code for Hitachi and the SEA. If anyone's interested, leave me a message." },
				{ date = 111658, to = "Lupus", from = "Modern Jane", message = "Congrats on burning Gemeinschaft. Heard the fire was so small they don't even know who started it." },
				{ date = 111658, to = s.name, from = "Matt Shaw", message = "Word of warning: some dumb wilson just got fried by jacking into cyberspace from the Loser's outlet. His first (and last) try. The ICE is softer at the bases you can reach from the Cheap Hotel's jack, so brush up on your cyberspace techniques there first." },
				{ date = 0, to = s.name, from = "Modern Bob", condition = function() return s.mail_modernbob == 1 end, message = "Got your message. Hitachi link code is \"HITACHIBIO\". SEA link code is \"SOFTEN\". Regular Fellows link code is \"REGFELLOW\"." },
			}
		},
		['bbs_send'] = {
			type = "sendmessage"
		}
	}
	-- Coord.--0-224/112  AI--none
}
chaos=Chaos

function Chaos:ProcessMessage(recipient, message)
	local to = string.lower(recipient)
	if (string.find(string.lower(message), "%f[%a]" .. "link" .. "%f[%A]")) then
		if (to == "modern bob" or to == "mod bob" or to == "bob") then
			s.mail_modernbob = 1
		end
	end
end

s.psychosentmessage = false
Psycho = ComingSoon:new {
	title = "* Psychologist *",
	comLinkLevel = 2,
	passwords = {
		"new mo",
		"babylon",
		"<cyberspace>"
	},

	pages = {
		['title'] = {
			type = "title",
			message = "If you wish to initiate your own mindprobe session by entering inormation for the Psych to analyze, you must log in under your personal password. The reasonable fee for this service will vary according to the severity of your problem. If you're a new user, enter the password, \"NEW MO\".",
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "message",
			exit = "menu",
			message = function(self)
					if (self.passwordLevel == 1) then return "Welcome to PSYSCHOLOGIST. If it makes you feel more comfortable, you can think of me as \"Sigmund.\" If you decide to proceed with analysis under your personal password, I will be your analyst. At the moment, however, your options are limited to browsing through other people's mindprobe sessions.\nIn future contact with this service, your personal password will be:\nBABYLON"
					else return "Welcome to PSYCHOLOGIST. I'm Sigmund, your personal mindprobe analyst. You now have the choice of browsing through other mindprobe sessions or starting one of your own. Your fee will be based on the severity of your problem if you proceed with a personal mindprobe. After completing a mindprobe session, I'll need a few hours to review your case, so there's no need for you to wait around. I won't be offended if you leave abruptly.\n\nBy activating a mindprobe session, you accept full responsibility for your own well-being. You also agree to hold the Psych staff harmless from any loss, expense, mental damange, or liability arising out of mindprobe analysis. This is no place for a weak mind."
					end
				end,
		},
		['menu'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Read Molly Sample", target = "holly" },
				{ key = '2', text = "Read Corto Sample", target = "corto" },
				{ key = '3', text = "Read Snowman Sample", target = "snowman" },
				{ key = '4', text = "Activate mindprobe", target = "mindprobe", level = 2 },
				{ key = '5', text = "Review last session", target = "review", level = 2 },
			}
		},
		['holly'] = {
			type = "message",
			message = "MINDPROBE FILE 4918\nPROBEE:  Molly\nPSYCH:   Sigmund\nVISIT:   Fourth\nTRANSCRIPT OF LAST SESSION:\n\nOkay, Sig, I'll tell you about my past. My Johnny, see, he was smart, real flash boy. Started out as a stash on Memory Lane, chips in his head and people paid to hide data there. Had the Yak after him, night I met him, and I did for their assassin. More luck than anything else, but I did for him. And after that, it was tight and sweet. We had a set-up with a squid, so we could read the traces of everything he'd ever stored. Ran it all out on tape and started twisting selected clients, ex-clients. I was bagman, muscle, watchdog. I was real happy. You ever been happy, Sig? He was my boy. We worked together. Partners. I was maybe eight weeks out of the puppet house when I met him... Tight, sweet, just ticking along, we were. Like nobody could ever touch us. I wasn't going to let them. Yakuza, I guess, they still wanted Johnny's ass. 'Cause I'd killed their main. 'Cause Johnny'd burned them. And the Yak, they can afford to move slow, man, they'll wait years and years. Give you a whole life, just so you'll have more to lose when they come and take it away. Patient like a spider. Zen spiders.\nI think he's after me now.... What do you think, Sig?\n\nDIAGNOSIS OF FOURTH VISIT:\nSad story, Molly. It's too complex for me to analyze all in one visit, but I think we're getting somewhere. I think the strain of your illegal activities is distorting your view of reality by directing your psychic energies into unhealthy channels, such as paranoia. Visit me more often and we'll try to work it out.",
		},
		['corto'] = {
			type = "message",
			message = "MINDPROBE FILE 4948\nPROBEE:  Colonel Corto\nPSYCH:   Friedrich\nVISIT:   Tenth\nTRANSCRIPT OF LAST SESSION:\n\nFriedrich? Read you, Friedrich. I'm sorry, but it has to be this way. One of us has to get out. One of us has to testify. If we all go down here, it ends here. I'll tell them, Friedrich, I'll tell them all of it. About Girling and the others. And I'll make it, Friedrich, I know I'll make it. To Helsinki. But it's so hard, Friedrich. So darn hard. I'm blind.\nRemember the training, Friedrich. That's all we can do. We are down, repeat, Omaha Thunder is down.\n\nDIAGNOSIS OF TENTH VISIT:\nSOunds like you're on a bad trup, Corto. I think the strain of your activities in Screaming Fist is distorting your view of reality. This is clearly unhealthy. You're no longer living on this planet. I've scheduled you for a long series of daily therapy sessions. This is Omaha Control, over and out.",
		},
		['snowman'] = {
			type = "message",
			message = "MINDPROBE FILE 4911\nPROBEE:  Snowman\nPSYCH:   Alfred\nVISIT:   Third\nTRANSCRIPT OF LAST SESSION:\n\nI'm really gettin worried, Ald. I was hangin out in the matrix, just kinda buzzin the green cubes of the Mitsubishi B of A, when this... thing starts tailin me. That's never happened before, man. So I rack in another Mimic soft and the thing stays behind me, like a heat-seeker or somethin. So I turn around and Mimic into an IRS audit. It doesn't care! It speeds up! I toss a Probe at it and this eats it. I never see it again! I barely had time to hack out before the thing nailed me. It's getting so a cowboy can't crack a base anymore without settin off some kinda alarm. Thing is, I don't remember what I did to attracy it's attention. It's almost like it was controlled by some sorta intelligence. You don't think an AI could have... no, that's impossible. AI's can't wander around in the matrix. Turing would nail em before they crossed two grids. Maybe I'm just being paranoid. Do you think I'm paranoid, Alf? Give it to me straight. I can take it.\n\nDIAGNOSIS OF THIRD VISIT:\nSnowman, my friend, I'm getting worried too. I don't want to alarm you, but things like that just can't happen in cyberspace. Maybe you ran into a loose data transmission, or something. I don't know. But I really think you're overreacting to what you perceive to be a threat. Maybe it's time for you to reture from cyberspace and get a real job. I think the strain of your illegal activities is directing itself into your paranoia. Visit me more often and we'll try to work it out.",
		},
		['mindprobe'] = {
			type = "sendmessage",
			noDateTo = true,
			messagePrompt = "Enter your thoughts",
			sendPrompt = "Send this thought",
			exit = "menu",
		},
		['review'] = {
			type = "message",
			exit = "menu",
			message = "Yours was an interesting case. Whether you're aware of it or not, yoy have deep psychological problems. It's too deep for me to analyze all in one visit, but I think we're getting somewhere. Your reality-view seems to be bipolar, but further analysis will be required before I can reach a conclusion. I recommend that you stop your illegal actiities before your problems get worse. Thanks for stopping by. I hope I'll see you again... for your sake."
		},
	},
	-- Coord.--0-96/32  AI--Chrome weakness=Philosophy
}
psycho=Psycho

function Psycho:GoToPage(pageName)
	if (pageName == "review" and not s.psychosentmessage) then
		return
	end
	
	Site.GoToPage(self, pageName)
end

function Psycho:ProcessMessage(recipient, message)
	s.psychosentmessage = true
end


Fuji = Site:new {
	title = "* Fuji Electric *",
	comLinkLevel = 3,
	passwords = {
		"romcards",
		"uchikatsu",
	},
	
	pages = {
		['title'] = {
			type = "title",
			message = " ",
			entries = {
				{ x = 10, y = 10, text = "Our Romcards Never Forget"}
			}
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Company News", target = "news" },
				{ key = '2', text = "Executive Survival Kit", target = "survival" },
				{ key = '3', text = "Press Releases", target = "press" },
				{ key = '4', text = "Personnel Management", target = "personnel", level = 2 },
				{ key = '5', text = "Memo", target = "memo", level = 2 },
			}
		},
		['news'] = {
			type = "message",
			message = "\nCompany News\n\n***3rd quarter profits are up! Thanks to the effort of each and every one of you, our employees, we've increased productivity. This drives our costs down and jacks our profits ever higher. With the demand for quality products out there as insatiable as it is, we;ve going to be on top of the world. Management has increased meat puppt breaks from 10 to 11.5 minutes for all line employees just to show you they care.\n\n***R and D's Esther Radklif and Andy Raymod have finally gotten married. THey had planned a skiing honeymoon in the Alps, but Andy would have had to have sold both legs to afford it, so they decided to forego that please. They'll just remain here in Chiba City and cozy up their nest a bit. I know we all wish them well.\n\n***New Hires:\n\nMishiji, Takoda  Securty\nO'Brien, Akira   Management\nKharkov, Sven    Line production\nBord, Melissa    Employee Services\nWang, P. Ryan    Acquisitions\nBear, M. C.      Legal\nMoe, Larry       Consultant"
		},
		['survival'] = {
			type = "message",
			message = "\nExecutive Survival Kit\nWelcome.\nWe have two rules around here:\n1) Mr. Watkins is always right\n2) see rule  #1\n\nFollow the rules and we'll get along fine. Remember to cover your ass with paper, but never stray far from a paper shredder and you'll have a long career with Fuji Electric.\nWelcome aboard -- don't rock the boat.\n(signed)\nHarry Watkins"
		},
		['press'] = {
			type = "message",
			message = "\n***For Immediate Release\nNASA and FUJI ELECTRIC DO BUSINESS\n\nIn anticipation of next century's manned shot at Alpha Centuri, NASA signed a multi-trillion dollar contract with Fuji Electric to provide ROMcards and software development for the Prometheus ship. Fuji Spokesman Harry Watkins said, \"This is the smartest move NASA has made since the dawn of their program.\"\nFuji anticipates unparalleled growth over the next decare. \"We'll have new employees coming on every day. If not for our own computer system, we'd have no way to keep track of them. Technology has made the human race great, and we want to lead the pack,\" said Watkins.\n\nFor further information contact Watkins at FUJI or Bob Shepherd at VOYAGER.\n\n(Just want you to know, my fellow employees, this contract was awarded on the strength of your work. Thanks, Harry...)"
		},
		['personnel'] = {
			type = "list",
			title = "New Employees List",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\n%s", item.Name, item['BAMA ID'], item.message) end,
			items = {
				{ Name = "LYNENE ROBINSON", ['BAMA ID'] = "211149931", message = "Position -  Security" },
				{ Name = "LISA ARNOLD", ['BAMA ID'] = "230057291", message = "Position - Management" },
				{ Name = "BILL DUGAN", ['BAMA ID'] = "199455756", message = "Position - Line production" },
				{ Name = "TOM DECKER", ['BAMA ID'] = "217453565", message = "Position - Employee services" },
				{ Name = "JAY PATEL", ['BAMA ID'] = "454781171", message = "Position - Acquisitions" },
				{ Name = "BRUCE SCHLICKBERND", ['BAMA ID'] = "175385636", message = "Legal" },
				{ Name = "LARRY MOE", ['BAMA ID'] = "062788138", message = "Position - Consultant" },
			}
		},
		['memo'] = {
			type = "message",
			message = "\nTo:Management Level Employees\nFromL Harry Watkins\nRE: TOZOKU merger\n\nIt is true that TOZOKU has made us an offer we have accepted concerning the ownership of FUJI. The days of a dynastic company have ended and I gladly consider turning control over to the people of TOZOKU I know of you think of them as common criminals, but I can assure you there is nothing common about them at all. I think all of you who were concerned about my wife and child. They've been returned to me and we've found all of little Harry's parts. The doctors say he's got an excellent chance of recovery and I agree that he doesn't really look like the Frankenstein monster at all.\n\nHarry"
		}

	}
	-- Coord.--2-112/240  AI--none
}
fuji=Fuji

HitachiBio = Site:new {
	title = "* Hitachi Biotech *",
	comLinkLevel = 3,
	passwords = {
		"genesplice",
		"biotech"
	},
	pages = {
		['title'] = { type = "title", message = "<editor note: this is a totally pointless site>" },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Lung Report", target = "report" },
				{ key = '2', text = "Personnel File", target = "personnel", level = 2 },
			}
		},
		['report'] = {
			type = "message",
			message = "Imagine a long winded description of how lung experiments work..."
		},
		['personnel'] = {
			type = "list",
			title = "Personnel File",
			hasDetails = true,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\nEmployee department - %s", item.Name, item['BAMA ID'], item.dept) end,
			items = {
				{ Name = "T. YOSHINOBU", ['BAMA ID'] = "132066340", dept = "C.E.O." },
				{ Name = "...", ['BAMA ID'] = "...", dept = "..." },
			}
		},
	}
	-- Coord.--2-32/192  AI--none
}
hitachibio=HitachiBio

Keisatsu = Site:new {
	title = "* Chiba City Tactical Police *",
	comLinkLevel = 4,
	passwords = {
		"warrants",
		"supertac",
	},
	pages = {
		['title'] = { type = "title", message = " " },
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "View Warrants", target = "warrants" },
				{ key = '2', text = "Edit Warrants", target = "warrants", level = 2 },
			}
		},
		['warrants'] = {
			type = "list",
			title = "Tactical Strike Warrants",
			targetOnClick = 'warrant',
--			hasDetails = true,
--			canEditDetails = function(self) return self.comLinkLevel > 1 end,
			columns = { { field = 'Name', width = 19 }, { field = 'BAMA ID', width = 0 } },
--			formatDetails = function(item) return string.format("\n\nName: %s\nID:   %s\nWanted for %s.", item.Name, item['BAMA ID'], item.crime) end,
			items = s.arrestWarrants,
		},
		['warrant'] = {
			type = "custom",
			exit = "warrants",
		}

	}
	-- Coord.--1-288/112  AI--none
}
keisatsu=Keisatsu

function Keisatsu:GoToPage(pageName)
	if (pageName == 'warrants') then
		self.pages['warrants'].items = s.arrestWarrants
	end

	Site.GoToPage(self, pageName)
end

function Keisatsu:HandleClickedEntry(id)
	if (self.currentPage == 'main' and id > 0) then
		self.editMode = id - 2
	end

	Site.HandleClickedEntry(self, id)
end

function Keisatsu:GetCustomEntries(page)
	local entries = {}

	self:GetPageHeaderFooterEntries(page, entries)

	local title = "Tactical Strike Warrants"
	local titleX = self:CenteredX(title)
	table.append(entries, { x=titleX, y = 2, text = title})
	
	table.append(entries, { x = 0, y = 5, text = "Name:"})
	table.append(entries, { x = 0, y = 6, text = "ID:"})
	table.append(entries, { x = 0, y = 7, text = string.format("Wanted for %s.", s.arrestWarrants[self.selectedListItem].crime)})
	
	if (self.editMode == 2) then
		table.append(entries, { x = 6, y = 5, entryTag = "name"})
	else
		table.append(entries, { x = 6, y = 5, text = s.arrestWarrants[self.selectedListItem].Name})
	end
	if (self.editMode == 3) then
		table.append(entries, { x = 6, y = 6, entryTag = "id"})
	else
		table.append(entries, { x = 6, y = 6, text = s.arrestWarrants[self.selectedListItem]['BAMA ID']})
	end

	self:AddExitEditEntries(entries, self.editMode > 0)

	return entries
end

function Keisatsu:HandleClickedEdit()
	self.editMode = 2
end


function Keisatsu:OnTextEntryComplete(text, tag)

	if (tag == "name") then
		s.arrestWarrants[self.selectedListItem].Name = text
		self.editMode = 3
	elseif (tag == "id") then
		s.arrestWarrants[self.selectedListItem]['BAMA ID'] = text
		self.editMode = 1
		if (string.lower(s.arrestWarrants[self.selectedListItem].Name) == "larry moe" and text == "062788138") then
			s.larry_arrested = true
		end
	else
		Site.OnTextEntryComplete(self, text, tag)
	end
end
