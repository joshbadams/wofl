
Dialog = LuaObj:new {
	text = "",
	speaker = 1,
	thought = false,
	onEnd = nil,
	hasTextEntry = false,
}


Room = LuaObj:new {
	longDescription = " ",
	description = " ",
	currentConversation = nil,
	currentDialog = nil,
	lineIndex = 0,
	choiceIndex = 0,
	isEnteringText = false,
	hasPax = false,
	hasPerson = false,
	hasJack = false,
	addedAnimations = {}
}

function Room:GetDialog()

	local dialog = Dialog:new{}
	local convo = self.currentConversation

	if (self.currentConversation == nil or
		(self.lineIndex > 0 and self.lineIndex > #self.currentConversation.lines) or
		(self.choiceIndex > 0 and self.choiceIndex > #self.currentConversation.options)) then
		return nil
	end

	if (self.currentChoice ~= nil) then
		if (type(self.currentChoice.response) == 'function') then
			dialog.text = self.currentChoice.response(self)
		else
			dialog.text = self.currentChoice.response
		end
	elseif (self.lineIndex > 0) then
		local line = convo.lines[self.lineIndex];
		if (type(line) == 'function') then
			dialog.text = line(self)
		else
			dialog.text = line
		end
	else
		local option = convo.options[self.choiceIndex]
		if (type(option.line) == 'function') then
			dialog.text = option.line(self)
		else
			dialog.text = option.line
		end
		dialog.thought = true
		dialog.hasTextEntry = option.hasTextEntry ~= nil and option.hasTextEntry
		dialog.isEditing = self.isEnteringText
	end

	return dialog
end

function Room:ActivateConversation(inTag)
	
	local tag = inTag
	if (type(tag) == 'function') then
		tag = tag(self)
	end

	-- reset
	self.lineIndex = 0
	self.choiceIndex = 0
	self.currentChoice = nil
	self.isEnteringText = false

	-- for non-tagged conversations, assume the user chose Talk option, so record we've done that
	-- this is reset in OnEnterRoom
	if (tag == nil) then
		s.hasTalkedInRoom = true
	end
	-- find tagged or calculated convo
	self.currentConversation = self:GetNextConversation(tag)

	if (self.currentConversation == nil) then
		return
	end

	-- init the list of lines or choices
	if (self.currentConversation.lines ~= nil and #self.currentConversation.lines > 0) then
		self.lineIndex = 1
	elseif (self.currentConversation.options ~= nil and #self.currentConversation.options > 0) then
		repeat
			self.choiceIndex = self.choiceIndex % #self.currentConversation.options + 1
		until (self.currentConversation.options[self.choiceIndex].condition == nil or self.currentConversation.options[self.choiceIndex].condition(self))
	end
	UpdateDialog()
end

function Room:EndConversation()
print("Room:EndConversation 1")

	local endingConversation = nil
	local endingChoice = nil

	-- after a reponse to a choice has been seen
	if (self.currentChoice ~= nil) then
print("Room:EndConversation 2")
		endingChoice = self.currentChoice
	-- after a choice with no response has been seen
	elseif (self.choiceIndex > 0) then
print("Room:EndConversation 3")
		endingChoice = self.currentConversation.options[self.choiceIndex]
	end


	-- NEED TO RESET CURENTCONVO TO NULL BEFORE CALLING ONEND

	-- for any type of conversation with an onEnd,
	endingConversation = self.currentConversation

	self.currentConversation = nil
	self.currentChoice = nil
	self.lineIndex = 0
	self.choiceIndex = 0
print("Room:EndConversation 4")

	-- run onEnd with the room as the self, not the choice/convo
	if (endingChoice ~= nil and endingChoice.onEnd ~= nil) then
print("Room:EndConversation 5", endingChoice, endingChoice.onEnd)
		endingChoice.onEnd(self)
	end
	if (endingConversation ~= nil and endingConversation.onEnd ~= nil) then
print("Room:EndConversation 6")
		endingConversation.onEnd(self)
	end

end


function Room:HandleDialogClick(isOutsideBubble)
	local convo = self.currentConversation
	
	-- clicking on a response to a choice
	if (self.currentChoice ~= nil) then
		self:EndConversation()
	
	-- room character is just talking normally
	elseif (self.lineIndex > 0) then
		self.lineIndex = self.lineIndex + 1
		if (self.lineIndex > #convo.lines) then
			self:EndConversation()
		end

	-- player is thinking through options
	elseif (self.choiceIndex > 0) then
		if (isOutsideBubble) then
			repeat
				self.choiceIndex = self.choiceIndex % #self.currentConversation.options + 1
			until (self.currentConversation.options[self.choiceIndex].condition == nil or self.currentConversation.options[self.choiceIndex].condition(self))
		else
			local choice = self.currentConversation.options[self.choiceIndex]
			-- if there's no response, there should be an onEnd function; run it now
			-- unless we have a text entry, handle that specially
			if (choice.hasTextEntry) then
				-- if (self.isEnteringText) then
				--	self:ProcessTextEntry()
				self.isEnteringText = true
				OpenBox("InlineTextEntry")
--				OpenBox("DialogTextEntry")
			elseif (choice.response ~= nil) then
				self.currentChoice = choice
			else
				self:EndConversation()
			end
		end
	end

	UpdateDialog()
end

function Room:DialogTextEntered(text)
print("Room:DialogTextEntered 1")
	-- run onEnd, close dialog, etc
	self:EndConversation()
print("Room:DialogTextEntered 2")

	self:ActivateConversation("_" .. text)
print("Room:DialogTextEntered 3")
	if (self.currentConversation == nil) then
		self:ActivateConversation("_unknownentry")
	end
print("Room:DialogTextEntered 4")
end

-- keycode 2 is Enter
-- keycode 1 is Escape
-- type 0 is KeyDown
function Room:ConversationKey(char, keyCode, type)
-- print("keycode: ", keyCode, self.currentConversation)
	if (type == 0) then
		if (keyCode == 2) then
			self:HandleDialogClick(false)
		elseif (not self.currentConversation.noCancel and keyCode == 1) then
			self.currentConversation = nil
			UpdateDialog()
		else
			self:HandleDialogClick(true)
		end
	end

	return true
end

function Room:GetNextConversation(tag)
	if tag ~= nil then
		local lowertag = tag:lower()
		for i,v in ipairs(self.conversations) do
			local tagMatches = false
			if (v.tags ~= nil) then
				for i2,v2 in ipairs(v.tags) do
					if (v2:lower() == lowertag) then
						tagMatches = true
					end
				end
			else
				if (v.tag ~= nil and v.tag:lower() == lowertag) then
					tagMatches = true
				end
			end
			if (tagMatches) then
				if (v.condition == nil or v.condition(self)) then
					return v
				end
			end
		end
		return nil
	else
		for i,v in ipairs(self.conversations) do
			if (v.tag == nil and v.tags == nil) then
				if (v.condition == nil or v.condition(self)) then
					return v
				end
			end
		end
	end

	return nil
end

function Room:GetSprites()
	return {}
end

function Room:AddAnimation(anim)
	if (type(anim) == 'string') then
		for _,v in ipairs(self.namedAnims) do
			if (v.name == anim) then
				table.append(self.addedAnimations, v)
print("---> Adding anim", v)
				AddAnimation(v)
			end
		end
	else
		table.append(self.addedAnimations, anim)
print("---> Adding premade anim", v)
		AddAnimation(anim)
	end
end

function Room:RemoveAnimation(anim)
print("---> REmoving anim?", anim)
	for i,v in ipairs(self.addedAnimations) do
		bMatches = false
print("---> comparing to", v)

		if (type(anim) == 'string' and v.name == anim) then
			bMatches = true
		elseif (type(anim) == 'table' and v == anim) then
			bMatches = true
		end

		if (bMatches) then
print("---> REmoving anim", v, i)
			table.remove(self.addedAnimations, i)
			RemoveAnimation(v)
			return
		end
	end
end

function Room:AddAnimations()
	if (self.animations ~= nil) then
		for _,v in ipairs(self.animations) do
			self:AddAnimation(v)
		end
	end
end

function Room:RemoveAnimations()
	for _,v in ipairs(self.addedAnimations) do
		RemoveAnimation(v)
	end
	self.addedAnimations = {}
end

function Room:OnEnterRoom()
	s.hasTalkedInRoom = false

	self.addedAnimations = {}
	self:AddAnimations()

print("entering room", self.name, s.hasTalkedInRoom)
	local firstTimeKey = "__" .. self.name
	if (s[firstTimeKey] ~= 1) then
		self:OnFirstEnter()
		s[firstTimeKey] = 1
	else
		self:OnEnter()
	end

	currentRoom = self
end

function Room:OnFirstEnter()
	if (self.onEnterConversation ~= nil) then
		-- true param will make it wait for the long message to finish before kicking the convo
		ShowMessage(self.longDescription, function() if (self.hasPerson) then self:ActivateConversation(self.onEnterConversation) end end, true)
	else
		ShowMessage(self.longDescription)
	end
end

function Room:OnEnter()
	ShowMessage(self.description)
	if (self.onEnterConversation ~= nil and self.hasPerson) then
		self:ActivateConversation(self.onEnterConversation)
	end
end

function Room:OnExitRoom()
	self:RemoveAnimations()
end

function Room:GiveMoney(amount)
	s.money = s.money - amount
end

function Room:GiveItem(item)
end

function Room:UseItem(item)
end

function Room:UseSkill(skill)
end

function Room:GetConnectingRoom(direction)
print("getting room for ", direction, self[direction], self.name, self["name"])
	return _G[self[direction]];
end

