-- Globals, these will all be saved

money = 6
inventory = {
	0, -- cash
	1, -- pawn ticket
	2, -- UXB
}
date = 111658
bankaccount = 1941
name = "Badams"
bamaid = "056306118"



function table:removekey(key)
	local element = self[key]
	self[key] = nil
	return element
end

function table:append(item)
	self[#self+1] = item
end

function string:appendPadded(str, width)
	spaces = width - str:len()
	local res = self .. str
	for i=1,spaces do
		res = res .. ' '
	end

	return res
end

function string.fromDate(date)
	month = math.floor((date % 1000000) / 10000)
	day = math.floor((date % 10000) / 100)
	year = math.floor((date % 100) / 1)

	return string.format("%02d/%02d/%02d", month, day, year)
end

LuaObj = { }
function LuaObj:new (obj)
  obk = obk or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

Room = LuaObj



function Room:GetNextConversation(tag)
	if tag ~= nil then
		for i,c in ipairs(self.conversations) do
			if c.tag ~= nil and c.tag:lower() == tag:lower() then
				return c
			end
		end
	end

	for i,c in ipairs(self.conversations) do
		if c.condition ~= nil and c:condition() then
			return c
		end
	end

	return nil
end

function Room:OnFirstEnter()
	print("Room:OnFirstEnter")
	ShowMessage(self.longDescription)
end

function Room:OnEnter()
	print("Room:OnEnter")
	ShowMessage(self.description)
end

function Room:OnExit()

end

function Room:GiveMoney(amount)
	money = money - amount
end

function Room:GiveItem(item)
end

function Room:UseItem(item)
end

function Room:GiveMoney(amount)
	money = money - amount
end




Gridbox = LuaObj:new {
	detailsIndex = 0,
	hasPassword = false,
}

function Gridbox:OpenBox(width, height)
	detailsIndex = 0

	self.sizeX = width
	self.sizeY = height

	self.numMessagesPerPage = self.sizeY - 6
	if self.numMessagesPerPage > 9 then
		self.numMessagesPerPage = 9
	end
end

function Gridbox:GetEntries()
print("--0--")
	return {}
end

function Gridbox:GetDetailsString()
	return "Unimplemented"
end

function Gridbox:OnMessageComplete()
	self.detailsIndex = 0
end

function Gridbox:OnTextEntryComplete(tag)

end



Site = Gridbox:new {
	currentPage = "main",
	firstVisibleIndex = 1,
}

function Site:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)
	self:GoToPage("main")
end

function Site:GoToPage(pageName)
	self.currentPage = pageName
	
	page = self:GetCurrentPage()
--	if page.type == "messages" or page.type == "list" then

	self.firstVisibleIndex = 1
	self.lastShownItem = -1
	self.bShowingItemDetails = false
end

function Site:GetCurrentPage()
	return self.pages[self.currentPage]
end

function Site:GetEntries()
	page = self:GetCurrentPage()
	if page.type == "menu" then
		return self:GetMenuEntries(page)
	elseif page.type == "list" then
		return self:GetListEntries(page)
	end

	return {}
end

function Site:GetDetailsString()
	page = self:GetCurrentPage()
	item = page.items[self.detailsIndex]

	if page.formatDetails ~= nil then
		return page.formatDetails(item)
	elseif item.message ~= nil then
		return item.message
	end
	
	return "~~unhandled details~~"
end

function Site:CenteredX(str)
	return math.floor((self.sizeX - str:len()) / 2)
end

function Site:GetPageHeaderFooterEntries(page, entries)
	table.append(entries, {x = self:CenteredX(self.title), y = 0, text = self.title} )
end

function Site:GetMenuEntries(page)
	entries = {}
	for i,v in ipairs(page.items) do
		table.append(entries, {
			x = 10, y = 4 + i,
			text = string.format("%s. %s", v.key:upper(), v.text),
			clickId = i,
			key = v.key,
		})
	end

	return entries
end

function Site:IsItemVisible(item)
	if item.condition ~= nil then
		local succeeded, cond = pcall(item.condition)
		if not (succeeded and cond) then
			-- function asserted, or returned false, skip
			return false
		end
	end

	return true
end

function Site:GetListEntries(page)
	entries = {}

	-- page headers
	self:GetPageHeaderFooterEntries(page, entries)

	if self.detailsIndex > 0 then
		
	else
		curY = 2
		-- column headers
		headers = ""
		for i,v in ipairs(page.columns) do
			-- add 1 for space between columns
			headers = headers:appendPadded(v.field, v.width + 1)
		end
		table.append(entries, {x = 3, y = curY, text = headers})

		-- items
		curY = curY + 2

		-- init loop counters
		localIndex = 1
		listIndex = self.firstVisibleIndex
		
		-- go until we are end of page or end of list
		while listIndex <= #page.items and localIndex <= self.numMessagesPerPage do

			local item = page.items[listIndex]

			if (not self:IsItemVisible(item)) then
				goto loopend
			end

			label = string.format("%d. ", localIndex)
			for i,v in ipairs(page.columns) do
				if v.field == 'date' then
					field = string.fromDate(item[v.field])
				else
					field = item[v.field]
				end

				-- add 1 for space between columns
				label = label:appendPadded(field, v.width + 1)
			end

			-- add the item with a clickId with list index, and '0'+listIndex as a key to press
			if (page.hasDetails) then
				keyPress = string.format(string.format("%c", 48 + localIndex))
				table.append(entries, {x = 0, y = curY, text = label, clickId = listIndex, key = keyPress})
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

		-- look to see if we need "more" when on the first page
		local needsMore = false
		if (self.firstVisibleIndex == 1) then
			local testItem = self.lastShownItem + 1
			while (testItem <= #page.items) do
				if (self:IsItemVisible(page.items[testItem])) then
					needsMore = true
					break
				end
				testItem = testItem + 1
			end
		else
			needsMore = true
		end

		-- exit / more buttons
		exitmoreCenter = self:CenteredX("exit more")
		table.append(entries, {x = exitmoreCenter, y = self.sizeY - 1, text = "exit", clickId = -1, key = "x" } )
		if needsMore then
			table.append(entries, {x = exitmoreCenter + 5, y = self.sizeY - 1, text = "more", clickId = -2, key = "m" } )
		end
	end

	return entries
end

function Site:HandleClickedEntry(id)
	page = self:GetCurrentPage()

print("Handle cliecked entry", self, page.type, id)

	-- handle non-zero ids
	if (id > 0) then
		if page.type == "menu" then
			-- menu click id is index
			self:OnItemSelected(page, page.items[id])
		elseif page.type == "list" then
			self.detailsIndex = id
		end

	-- -1 is always the "exit" option
	elseif id == -1 then
		self:HandleClickedExit()
	-- -2 is always the "more" option
	elseif id == -2 then
		self:HandleClickedMore()
	end
end


function Site:OnItemSelected(page, item)
	if page.type == "menu" then

		print(item.target)

		if item.target == "exit" then
			CloseBox()
			return
		end

		self:GoToPage(item.target)
	end
end

function Site:HandleClickedExit()
	page = self:GetCurrentPage()
	self:GoToPage(page.exit)
end

function Site:HandleClickedMore()
	assert(self.lastShownItem > 0)

	page = self:GetCurrentPage()
	self.firstVisibleIndex = self.lastShownItem + 1
	if self.firstVisibleIndex > #page.items then
		self.firstVisibleIndex = 1
	end
end

function Site:HandleInput(char)
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



Cheapo = Site:new {
	title = "* The Cheapo Hotel *",
	comLinkLevel = 1,
	
	pages = {
		['title'] = {
			message = "Hey, it's better than sleeping  in the streets!\nJust enter the password \"GUEST\" to enter our system."
		},
		
		['password'] = {
			type = "password",
		},
		
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Room Service", target = "roomservice" },
				{ key = '2', text = "Local Things to do", target = "thingstodo" },
				{ key = '3', text = "Review Bill", target = "reviewbill"  },
				{ key = '4', text = "Edit Bill [level 2?]", target = "editbill", level = 2 }
			}
		},
		
		['roomservice'] = {
			type = "menu",
		},
		
		['thingstodo'] = {
			type = "list",
			exit = "main",
			items = {
				{
					date = 111658,
					subject = "Donut World",
					message = "aalskdjaklsjdalksjdklajsdla"
				},
				{
					date = 111658,
					subject = "Manyusha Wana Massage",
					message = "aalskdjaklsjdalksjdklajsdla"
				},
				{
					date = 111658,
					subject = "Psychologist",
					message = "aalskdjaklsjdalksjdklajsdla"
				},
				{
					date = 111658,
					subject = "Crazy Edo's",
					message = "aalskdjaklsjdalksjdklajsdla"
				},
			}
		}
	}
}
-- lowercase
cheapo = Cheapo

IRS = Site:new {
	
	title = "** Internal Revenue Service **",
	comLinkLevel = 1,

	pages = {
		['password'] = {
			type = "password",
		},
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "TaxInfo Board", target = "irsboard" },
				{ key = '2', text = "Supervisor's Notice", target = "notice", level = 2 },
				{ key = '3', text = "Special Audit Report", target = "auditreport", level = 2 },
				{ key = '4', text = "View Audit List", target = "auditlist", level = 2 }
			}
		},
		
		['irsboard'] = {
			type = "list",
			exit = "main",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 15 }, { field = 'from', width = 0 } },
			items = {
				{
					date = 111658,
					tp = "IRS",
					longto = "--",
					from = "L. Zone",
					headers = "BAMA ID: 1404726431",
					message = "I had twenty million credits worth of incoming this year in my black market pituitary extract operation. This is my first year in business. Which forms should I use to report this income? Can my business startup expenses be deducted?"
				},
				{
					date = 111658,
					to = "L. Zone",
					from = "IRS",
					longfrom = "--",
					message = "Your business is an illegal operation. We have identified you to the proper law encorcement agencies. Pending further investigation, your total incoming for theyear has been turned over to us."
				},
				{
					date = 111658,
					to = "IRS",
					longto = "--",
					from = "R. Hammer",
					longfrom = "Rafaella Hammer",
					headers = "BAMA ID: 2776081129",
					message = "Due to an oversight on the part of my accountant, I failed to report all of my income for the last year. What form should I file to correct this oversight and how much of a penalty will I have to pay?"

				},
				{
					date = 111658,
					to = "R. Hammer",
					longto = "Rafaella Hammer",
					from = "IRS",
					longfrom = "--",
					message = "We have given your case careful consideration and have decided that there will be no penalty incurred on the income you failed to report last year. However, you and your tax accountant are you going to jail."
				},
			}
		},
		
		['auditlist'] = {
			type = "list",
			exit = "main",
			header = "Field Audit List",
			hasDetails = true,
			columns = { { field = "Name", width = 15 } , { field = "BAMA ID", width = 0 } },
			items = {
				{
					Name = "%name%",
					['BAMA ID'] = "%bamaid%",
					message = "Reason: Tax evasion."
				},
				{
					Name = "FINDLEY MATTHEW",
					['BAMA ID'] = "001131968",
					message = "Reason: Tax evasion."
				},
				{
					Name = "CHUNG LO DUC",
					['BAMA ID'] = "471294819",
					message = "Reason: Tax evasion."
				},
				{
					Name = "NAKASONE SANDRA",
					['BAMA ID'] = "255885697",
					message = "Reason: Tax evasion."
				},
				{
					Name = "MARTINEZ RAUL",
					['BAMA ID'] = "549887110",
					message = "Reason: Tax evasion."
				},
			}
		}
		
	}
}
-- lowercase
irs = IRS
