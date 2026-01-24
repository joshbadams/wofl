
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
print("checking all pages for unlocks")
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
	if (self.openTag == "cyberspace") then
		OpenBox("cyberspace", "exitsite")
	end
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
print("checking for unlocks in page", page.unlockid)
	local unlockedInfo = s.unlockedMessagesInfo[page.unlockid]

	if (unlockedInfo == nil) then
		unlockedInfo = {}
		s.unlockedMessagesInfo[page.unlockid] = unlockedInfo
	end

	for i,v in ipairs(page.items) do
print("checking for item i to be unlocked", unlockedInfo, #unlockedInfo, s.date, v.date)
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
print("going to ", pageName)
	-- process leaving a page
	if (self.currentPage == "title") then
		ReorderBox(self, 0)
	end

	-- let the page run custom logic
	if (self:GetCurrentPage() ~= nil and self:GetCurrentPage().onExitPage ~= nil) then
		self:GetCurrentPage().onExitPage(self)
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


	-- let the page run custom logic
	if (page.onEnterPage ~= nil) then
		page.onEnterPage(self)
	end

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
		local displayPassword = self.passwords[self.passwordLevel]
		if (displayPassword == "<sequencer>") then displayPassword = "no password" end

		table.append(entries, {x = X, y = 4, text = displayPassword })
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
		if (v.level ~= nil and self.passwordLevel < v.level) then
			-- skip

		elseif (v.software == nil) then
			table.append(entries, {
				x = 10, y = 3 + i,
				text = string.format("%s. %s", v.key:upper(), v.text),
				clickId = i,
				key = v.key,
			})
		else
			local name = Items[v.software].name
			local version = Items[v.software].version
			table.append(entries, {
				x = 10, y = 3 + i,
				text = string.format("%s. %s %d.0", v.key, name, version),
				clickId = i,
				key = v.key,
			})
		end
	end

	if (self.downloadPhase == 1) then
		table.append(entries, { x = 0, y = self.sizeY - 1, text = "Transmitting . . ."})
	elseif (self.downloadPhase == 2) then
		table.append(entries, { x = 0, y = self.sizeY - 1, text = "Transmitting . . . download complate"})
	elseif (self.downloadPhase == 3) then
		table.append(entries, { x = 0, y = self.sizeY - 1, text = "Transmitting . . . deck is full"})
	elseif (self.downloadPhase == 4) then
		table.append(entries, { x = 0, y = self.sizeY - 1, text = "Transmitting . . . incompatible deck"})
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
		if (self.openTag == "cyberspace") then
			self.passwordLevel = #self.passwords
			self:GoToPage("main")
		else
			self:GoToPage("password")
		end
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
		if (self.openTag == "debug") then
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
		end
		for i,v in ipairs(self.passwords) do
			if (v:sub(1,1) ~= "<" and v == string.lower(text)) then
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

	local time = 7
	local time2 = 3
	StartTimer(time, self, function()
		self.sequencing = false
		self.blockInput = false
		self.passwordLevel = 1
	end)

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

