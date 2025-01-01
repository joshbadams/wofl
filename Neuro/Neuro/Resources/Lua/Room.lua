
Dialog = LuaObj:new {
	text = "",
	speaker = 1,
	thought = false,
	onEnd = nil,
}


Room = LuaObj:new {
	longDescription = " ",
	description = " ",
	currentConversation = nil,
	currentDialog = nil,
	lineIndex = 0,
	choiceIndex = 0,
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
		dialog.text = self.currentChoice.response
	elseif (self.lineIndex > 0) then
		dialog.text = convo.lines[self.lineIndex]
	else
		dialog.text = convo.options[self.choiceIndex].line
	end

	return dialog
end

function Room:ActivateConversation(tag)

	-- reset
	self.lineIndex = 0
	self.choiceIndex = 0
	self.currentChoice = nil

	-- find tagged or calculated convo
	self.currentConversation = self:GetNextConversation(tag)

	-- init the list of lines or choices
	if (self.currentConversation.lines ~= nil and #self.currentConversation.lines > 0) then
		self.lineIndex = 1
	elseif (self.currentConversation.options ~= nil and #self.currentConversation.options > 0) then
		self.choiceIndex = 1
	end
	UpdateDialog()
end

function Room:HandleDialogClick(isOutsideBubble)
	local convo = self.currentConversation
	
	-- clicking on a response to a choice
	if (self.currentChoice ~= nil) then
		local choice = self.currentChoice
		self.currentChoice = nil
		self.currentConversation = nil

		-- run onEnd with the room as the self, not the choice
		if (choice.onEnd ~= nil) then
			choice.onEnd(self)
		end
	
	-- room character is just talking normally
	elseif (self.lineIndex > 0) then
		self.lineIndex = self.lineIndex + 1
		if (self.lineIndex > #convo.lines) then
			self.currentConversation = nil
			-- run any onEnd function when the lines are done
			if (convo.onEnd ~= nil) then
				convo.onEnd(self)
			end
			
		end

	-- player is thinking through options
	elseif (self.choiceIndex > 0) then
		if (isOutsideBubble) then
			self.choiceIndex = self.choiceIndex % #self.currentConversation.options + 1
		else
			local choice = self.currentConversation.options[self.choiceIndex]
			-- if there's no response, there should be an onEnd function; run it now
			if (choice.response ~= nil) then
				self.currentChoice = choice
			elseif (choice.onEnd ~= nil) then
				choice.onEnd(self)
			else
				self.currentConversation = nil
			end
		end
	end

	if (self.currentConversation == nil) then
		self.lineIndex = 0
		self.choiceIndex = 0
	end

	UpdateDialog()
end


function Room:GetNextConversation(tag)
	if tag ~= nil then
		for i,v in ipairs(self.conversations) do
			if v.tag ~= nil and v.tag:lower() == tag:lower() then
				return v
			end
		end
	end

	for i,v in ipairs(self.conversations) do
		if (v.tag == nil) then
			if (v.condtiion == null) or (v.condition ~= nil and v:condition()) then
				return v
			end
		end
	end

	return nil
end



function Room:OnEnterRoom()
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
print("long desc -", self.longDescription,"-")
	if (self.onEnterConversation ~= nil) then
--		ShowMessage(self.longDescription, function() Talk(self.onEnterConversation) end)
		ShowMessage(self.longDescription, function() self:ActivateConversation(self.onEnterConversation) end)
	else
		ShowMessage(self.longDescription)
	end
end

function Room:OnEnter()
print("short desk -", self.description,"-")
	ShowMessage(self.description)
	if (self.onEnterConversation ~= nil) then
		self:ActivateConversation(self.onEnterConversation)
	end
end

function Room:OnExitRoom()

end

function Room:GiveMoney(amount)
	s.money = s.money - amount
end

function Room:GiveItem(item)
end

function Room:UseItem(item)
end

function Room:GetConnectingRoom(direction)
print("getting room for ", direction, self[direction], self.name, self["name"])
	return _G[self[direction]];
end

