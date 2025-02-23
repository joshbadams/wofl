s.gentlemanloser = 0

LoserCryptoShop = ShopBox:new {
	items = { 401 },
}

function LoserCryptoShop:OnBoughtSoldNothing()
	-- if user exits from the shop, start over
print("restarting", currentRoom.onEnterConversation)
	currentRoom:ActivateConversation(currentRoom.onEnterConversation)
end

function LoserCryptoShop:OnBoughtSoldItem(clickId)
print("bought something")
	s.losergotcrypto = true
	s.gentlemanloser = 4
	ShopBox.OnBoughtSoldItem(self, clickId)
	ShowMessage("Shiva gives you your Cryptology chip.")
print("s.loser=", s.gentlemanloser)
end


LoserHardwareRepairShop = ShopBox:new {
	items = { 402 },
}

LoserGuestPassShop = ShopBox:new {
	items = { 4 },
}

function LoserGuestPassShop:OnBoughtSoldItem(clickId)
	ShopBox.OnBoughtSoldItem(self, clickId)
	ShowMessage("Shive gives you a guest pass for the Matrix Restaurant.")
	s.losergotpass = true
end


s.losergotcrypto = false
s.losergotpass = false

chipTags = { "_chip", "_chips", "_skill", "_skills",  }

GentlemanLoser = Room:new {
	name = "gentlemanloser",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	hasPax = true,
	hasJack = true,
	
	east = "streetcenter4",
	
	longDescription = "The air smells of perfume and fast food in the Gentleman Loser. Bugs circle neon signs. This is a hangout for joeboys and cowboys who haven't yet made the big score. It's quiet right now, with only one customer, a woman named Shiva.",
	description = "You're in the Gentleman Loser.",
	
	
	conversations = {
		{
			tag = "onEnterRoom",
			lines = {
				"Hey, geek! C'mere! I got somethin' for ya!"
			},
			onEnd = function() if (s.losergotcrypto) then s.gentlemanloser = 10 else s.gentlemanloser = 1 end end,
		},
		{
			condition = function() return s.gentlemanloser == 1 end,
			options =
			{
				{
					line = "Whatever it is, I hope it's not contagious.",
					response = "Anonymous was here earlier. If you're a friend of his, you know what I've got for you.",
					onEnd = function(self) s.gentlemanloser = 2; self:ActivateConversation("") end,
				},
				{
					line = "Later. I've got biz to attend to right now.",
					response = "Suit yourself, cowboy.",
					onEnd = function(self) GoToRoom(self.east) end,
				},
			}
		},
		{
			condition = function() return s.gentlemanloser == 2 or s.gentlemanloser == 3 end,
			options =
			{
				{
					condition = function() return s.gentlemanloser == 2 end,
					line = "A social disease?",
					response = "Beat it, cyberjerk!",
					onEnd = function(self) GoToRoom(self.east) end,
				},
				{
					condition = function() return s.gentlemanloser == 2 end,
					line = "Is it smaller than a breadbox?",
					response = "It's even smaller than your head, which is pretty small....",
					onEnd = function(self) s.gentlemanloser = 3 end,
				},
				{
					line = "Animal, vegetable, or mineral?",
					response = "No, actually I was referrin' to somethin' else, so get lost, wilson!",
					onEnd = function(self) self:ActivateConversation("wronganswer") end,
				},
				{
					line = "Ah! You must be referring to the ",
					hasTextEntry = true,
				},
			}
		},
		{
			tags = { "convo3" },
			lines = { "I also have Hardware Repair for sale for $1000." },
			onEnd = function(self) OpenBox("LoserCryptoShop") end,
		},
		{
			condition = function() return s.gentlemanloser == 4 end,
			options =
			{
				{
					line = "Okay. What do you know about ",
					hasTextEntry = true,
				},
				{
					line = "Hey, Babe, I want to buy the chip.",
					onEnd = function(self) OpenBox("LoserHardwareRepairShop") end,
				},
			}
		},
		{
			condition = function() return s.gentlemanloser == 10 end,
			options =
			{
				{
					line = "Hey, Babe, I want to buy the chip.",
					onEnd = function(self) OpenBox("LoserHardwareRepairShop") end,
				},
				{
					line = "Maybe you could answer some questions for me?",
					response = "Sure. It'll be more fun than a poke in the eye with a sharp stick....",
					onEnd = function(self) s.gentlemanloser = 4 end
				},
				{
					line = "You already gave me something. I don't want anything else.",
					response = "Suit yourself, cowboy.",
					onEnd = function(self) GoToRoom(self.east) end,
				},
				{
					line = "How about coming back to my place?",
					response = "Forget it. You live at Cheap Hotel. I know all about your kind, wilson....",
					onEnd = function(self) GoToRoom(self.east) end,
				},
			}
		},

		{
			tag = "wronganswer",
			lines = { "No, actually I was referrin' to somethin' else, so get lost, wilson!" },
			onEnd = function(self) GoToRoom(self.east) end,
		},
		
		{
			tags = { "_unknownentry" },
			lines = { "Ya got me. I don't know anythin' about that." },
			onEnd = function(self) if (not s.losergotcrypto) then GoToRoom(self.east) end end
		},
		{
			tags = chipTags,
			lines = {
				function(self)
					if (s.losergotcrypto) then return "All I've got is HarwareRepair for $1000."
					else return "Yeah. You must be " .. s.name .. ". I got your chip for ya."
					end
				end
			},
			onEnd = function(self)
				if (s.losergotcrypto) then OpenBox("LoserHardwareRepairShop")
				else self:ActivateConversation("convo3")
				end
			end,
		},
		{
			tags = { "_cryptology" },
			lines = { "Julius Deane can upgrade your Cryptology skill chip." },
		},
		{
			tags = { "_loser" },
			lines = { "The Loser link code is LOSER. The password is \"WILSON\", which is a term you should be familiar with." },
		},
		{
			tags = { "_wilson" },
			lines = { "Only a wilson would ask a question like that." },
		},
		{
			tags = { "_guest pass", "_norton", "_emperor", "_emperor norton", "_matrix", "_restaurant",  },
			lines = {
				function(self)
					if (s.losergotpass) then return "I already gave it to you, cowboy."
					else return "Emperor Norton left you a Guest Pass for the Matrix Restaurant. He mumbled something about skills and upgrades."
					end
				end
			},
			onEnd = function(self) if (not s.losergotpass) then OpenBox("LoserGuestPassShop") end end
		},
	}
}
gentlemanloser = GentlemanLoser

function GentlemanLoser:DialogTextEntered(text)
print("dialog", text, chipTags[1], table.containsArrayItem(chipTags, "_" .. text))

	if (not s.losergotcrypto) then
		if (text == "cryptology" or table.containsArrayItem(chipTags, "_" .. text)) then
			self:ActivateConversation(chipTags[1])
		else
			self:ActivateConversation("wronganswer")
		end
	else
		Room.DialogTextEntered(self, text)
	end
end



Loser = ComingSoon:new {
	comLinkLevel = 4,
	passwords = {
		"wilson",
		"loser",
		"<cyberspace>"
	}
}
loser=Loser
-- Coord.--1-416/64  AICoord.--1-one
