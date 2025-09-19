InvPhase = {
	List = {},
	Software = {},
	Action = {},
	Amount = {},
	ConfirmDiscard = {},
	ConfirmGive = {},
	Login = {},
	LoginError = {},
	Incompatible = {},
	ShortMessage = {},
	UsedSkill = {},
	NothingHappens = {},
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

function InvBox:OpenBox()
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
	elseif (self.phase == InvPhase.ConfirmDiscard) then
		self:GetConfirmEntries(entries)
	elseif (self.phase == InvPhase.Login) then
		self:GetLoginEntries(entries)
	elseif (self.phase == InvPhase.LoginError) then
		self:GetLoginErrorEntries(entries)
	elseif (self.phase == InvPhase.Incompatible) then
		self:GetIncompatibleEntries(entries)
	elseif (self.phase == InvPhase.ShortMessage) then
		table.append(entries, { x = 0, y = 1, text = self.message })
	elseif (self.phase == InvPhase.UsedSkill) then
		table.append(entries, { x = 1, y = 2, text = "Skill chip implanted"})
	elseif (self.phase == InvPhase.NothingHappens) then
		table.append(entries, { x = 1, y = 2, text = "Nothing happens."})
	end

	return entries
end

function InvBox:GetInvEntries(entries, inv, heading)
print("inv entries", self.page, self.numInvPerPage, numItems)

	local numItems = table.count(inv)

	if (self.page > 0 and self.page * self.numInvPerPage >= numItems) then
		self.page = self.page - 1
	end

	table.append(entries, { x = 1, y = 0, text = heading })

	local itemIndex = self.page * self.numInvPerPage + 1
	for line=1, self.numInvPerPage do

		if (itemIndex > numItems) then
			break
		end
		
		local desc = GetListItemDesc(inv[itemIndex], self.sizeX - 3)
		table.append(entries, { x = 0, y = line, text = string.format("%d. %s", line, desc), clickId = itemIndex, key = tostring(line) })

		itemIndex = itemIndex + 1
	end

	-- exit / more buttons
	needsMore = numItems > self.numInvPerPage
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

function InvBox:GetConfirmEntries(entries)
	local header = "Discard"
	if (self.phase == InvPhase.ConfirmGive) then
		header = "Give"
	end
	table.append(entries, { x = self:CenteredX(header), y = 0, text = header })
	table.append(entries, { x = 2, y = 3, text = GetItemDesc(s.inventory[self.invItem]) })
	table.append(entries, { x = 0, y = 5, text = "Are you sure ( / )" })
	table.append(entries, { x = 14, y = 5, text = "Y", clickId = InvAction.Yes, key = "y" })
	table.append(entries, { x = 16, y = 5, text = "N", clickId = InvAction.No, key = "n" })
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

function InvBox:GetIncompatibleEntries(entries)
	table.append(entries, { x = 0, y = 0, text = string.format("%s %d.0", self.activeSoftware.name, self.activeSoftware.version) })
	table.append(entries, { x = 0, y = 1, text = "Incompatible link." })
end







function InvBox:HandleClickedEntry(id)
	if (self.blockInput) then
		return
	end

	print("Inv clicked", self, self.phase, id)

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
			table.removeArrayItem(s.inventory, self.invItem)
		end
		self.phase = InvPhase.List
	elseif (self.phase == InvPhase.ConfirmDiscard) then
		if (id == InvAction.Yes) then
print("size before rmeove", table.count(s.inventory))
			table.removeArrayItem(s.inventory, self.invItem)
print("size after rmeove", table.count(s.inventory))
		end
		self.phase = InvPhase.List
	end
end

function InvBox:HandleClickedExit()
	print("closing box")
	self:Close()
end

function InvBox:HandleClickedMore()
	self.page = self.page + 1
	if (self.page == self.numPages) then self.page = 0 end
end

function InvBox:OnTextEntryComplete(text, tag)
	if (self.phase == InvPhase.Login) then
		if (text == "") then
			self:Close()
			return
		end

		local siteName = string.lower(text)
		local site = _G[siteName]
		if (site == nil) then
			self.phase = InvPhase.LoginError
		elseif (site.comLinkLevel > self.activeSoftware.version) then
			self.phase = InvPhase.Incompatible
		else
			OpenBox(siteName)
			s.lastSite = siteName
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
	if (self.blockInput) then
		return
	end

	if (self.phase == InvPhase.LoginError or self.phase == InvPhase.Incompatible) then
		self.phase = InvPhase.Login
	elseif (self.phase == InvPhase.ShortMessage or self.phase == InvPhase.NothingHappens) then
		self.phase = self:Close()
	elseif (self.phase == InvPhase.UsedSkill) then
		self.phase = InvPhase.List
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
			s.currentDeckId = s.inventory[self.invItem]
		elseif (item.type == "skill") then
			self:UseSkill()
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

	if (item.scope == "jack") then
		if (currentRoom.hasJack) then
			self.activeSoftware = item
			self.phase = InvPhase.Login
		else
			self.phase = InvPhase.ShortMessage
			self.message = "No jack here."
		end
	else
		self.phase = InvPhase.NothingHappens
	end
end

function InvBox:UseSkill()
	local skillId = s.inventory[self.invItem]
	-- add to skills list if not there (fast lookup in the skillLevels map to know if we ever unlocked it)
	if (s.skillLevels[skillId] == nil) then
		table.append(s.skills, skillId)
		-- when unlocking from an item, start level at 1
		s.skillLevels[skillId] = 1
	end
	self.phase = InvPhase.UsedSkill

	table.remove(s.inventory, self.invItem)
end





InvBox_Site = InvBox:new {
	
}

function InvBox_Site:OpenBox()
	InvBox.OpenBox(self)

	self.phase = InvPhase.Software
end

function InvBox_Site:UseSoftware(softwareItem)
	software = Items[s.software[softwareItem]]
print("using software: ", currentSite, software, software.scope)

	-- todo: make a title page specific one maybe?
	if (currentSite ~= nil) then
		local error = currentSite:CanUseSoftware(software)
		if (error == "") then
			self:Close()
		elseif (error ~= nil) then
			self.phase = InvPhase.ShortMessage
			self.message = error
		else
			self:Close()
			currentSite:UseSoftware(software)
		end
	else
		self.phase = InvPhase.NothingHappens
	end
end

function InvBox_Site:HandleClickedExit()
	currentSite:UseSoftware(nil)
	self:Close()
end





SkillBox = Gridbox:new {
	x = 150,
	y = 480,
	w = 500,
	h = 280,
}

function SkillBox:OpenBox()
	self.page = 0
	self.numSkillsPerPage = self.sizeY - 2;
	self.numPages = math.ceil(#s.inventory / self.numSkillsPerPage);
end

function SkillBox:HandleClickedEntry(id)
	local skill = Items[s.skills[id]]
	local level = s.skillLevels[s.skills[id]]
print("skill", skill.scope, skill.box, level)
	if (skill.scope == "room") then
		currentRoom:UseSkill(skill, level)
	elseif (skill.scope == "anytime") then
		if (skill.box ~= nil) then
			OpenBox(skill.box)
		end
	end

	self:Close()
end


function SkillBox:GetEntries()
	local entries = {}

	local centeredTitle = self:CenteredX("SKILLS")
	table.append(entries, { x=centeredTitle, y=0, text="SKILLS" })
	

	local itemIndex = self.page * self.numSkillsPerPage + 1
	for line=1, self.numSkillsPerPage do

		if (itemIndex > #s.skills) then
			break
		end
		
		local skillId = s.skills[itemIndex];
		local desc = string.format("%d. ", line)

		desc = string.appendPadded(desc, Items[skillId].name, self.sizeX - 5) .. s.skillLevels[skillId]
		table.append(entries, { x = 0, y = line, text = desc, clickId = itemIndex, key = tostring(line) })

		itemIndex = itemIndex + 1
	end

	-- exit / more buttons
	needsMore = #s.skills > self.numSkillsPerPage
	self:AddExitMoreEntries(entries, needsMore)

	return entries
end

function SkillBox:HandleClickedExit()
	self:Close()
end

function SkillBox:HandleClickedMore()
	self.page = (self.page + 1) % self.numPages
end
