InvPhase = {
	List = {},
	Software = {},
	Action = {},
	Amount = {},
	ConfirmDiscaard = {},
	ConfirmGive = {},
	Login = {},
	LoginError = {},
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

function InvBox:OpenBox(width, height)
	print("opening invbox", s.inventory, s.money)
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
	elseif (self.phase == InvPhase.UsedSkill) then
		table.append(entries, { x = 1, y = 2, text = "Skill chip implanted"})
	elseif (self.phase == InvPhase.NothingHappens) then
		table.append(entries, { x = 1, y = 2, text = "Nothing happens."})
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
			table:removeKey(s.inventory, self.invItem)
		elseif (id == InvAction.No) then
			self.phase = InvPhase.List
		end
	elseif (self.phase == InvPhase.ConfirmDiscard) then
		if (id == InvAction.Yes) then
			table:removeKey(s.inventory, self.invItem)
		elseif (id == InvAction.No) then
			self.phase = InvPhase.List
		end
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
print("text enyry", text, tag)
	if (self.phase == InvPhase.Login) then
		if (text == "") then
			self:Close()
			return
		end

		local siteName = string.lower(text)
		local site = _G[siteName]
		if (site == nil or site.comLinkLevel == nil) then
			self.phase = InvPhase.LoginError
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
	if (self.phase == InvPhase.LoginError) then
		self.phase = InvPhase.Login
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
		self.activeSoftware = item
		self.phase = InvPhase.Login
--		OpenBox("Login")
--		self:Close()
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






SkillBox = Gridbox:new {
	x = 150,
	y = 480,
	w = 500,
	h = 280,
}

function SkillBox:OpenBox(width, height)
	Gridbox.OpenBox(self, width, height)

	self.page = 0
	self.numSkillsPerPage = self.sizeY - 2;
	self.numPages = math.ceil(#s.inventory / self.numSkillsPerPage);
end

function SkillBox:HandleClickedEntry(id)
	local skill = Items[s.skills[id]]
	local lvel = s.skillLevels[s.skills[id]]
	if (skill.scope == "room") then
		currentRoom:UseSkill(skill, level)
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
print("skill", desc, line, skillId)
print(Items[skillId].name)
print(s.skillLevels[skillId])
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
