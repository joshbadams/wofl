s.gentlemanloser = 0

LoserCryptoShop = ShopBox:new {
	items = { 401 },
	
	closeOnBuySell = true,
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
	ShowMessage("Shiva gives you a guest pass for the Matrix Restaurant.")
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
	locX = 416,
	locY = 48,
	
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
			condition = function() return s.usingCopTalk > 0 end,
			lines = { "You're no cop! You're using a CopTalk skill chip! Get out of here!" },
			onEnd = function(self) GoToRoom(self.east) end,
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
			tags = { "_pass", "_guest pass", "_norton", "_emperor", "_emperor norton", "_matrix", "_restaurant",  },
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



Loser = Site:new {
	title = "* Gentleman Loser *",
	comLinkLevel = 4,
	passwords = {
		"wilson",
		"loser",
		"<cyberspace>" -- done
	},
	
	baseX = 416,
	baseY = 64,
	baseName = "Gentleman Loser",
	baseLevel = 1,
	iceStrength = 150,

	pages = {
		['title'] = {
			type = "title",
			message = "The faces of the neon forst welcome you to the Gentleman Loser base. Enter and know the feeling of black fire racing through your nerves."
		},
		['password'] = { type = "password" },
		['main'] = {
			type = "menu",
			items = {
				{ key = 'x', text = "Exit System", target = "exit" },
				{ key = '1', text = "Loser BBS", target = "bbs" },
				{ key = '2', text = "Sorceror BBS", target = "bbs2", level = 2 },
				{ key = '3', text = "Software Library", target = "software", level = 2 },
			}
		},
		['bbs'] = {
			type = "list",
--			unlockid = "loser_bbs",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 20 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Pol Oconner", from = "Osric", message = "They've been asking for you at the Body Shop in Chiba. Some buyer named Random wants a complete set of body parts from you. He's offering to replace all the parts you sell him with sturdy plastic replacements. He says it'll make a New Human out of you." },
				{ date = 111658, to = "Ulm Kris", from = "Lord B4", message = "Hey, remember me? You still owe me 4000 credits for the Bushido I sold you. Seems like an eternity's gone by since then. If I don't hear from you soon, I'll send the Ripper out after you." },
				{ date = 111658, to = "Bleys", from = "Keefer", message = "Nobody's seen Amber for two weeks now. Maybe she's gone over to the other side. Try Chaos. Maybe he knows something?" },
				{ date = 111658, to = "Keefer", from = "Bleys", message = "Any idea what happened to Amber? I hear rumors she's off in a secret game somewhere in cyberspace. I was supposed to meet her at the Loser yesterday, but she never showed." },
				{ date = 111658, to = "Everyone", from = "Red Jack", message = "Bank Gemeinschaft's been ripping my account again. I'm not going to take this lying down, so I'm asking everyone to dial into their base and tie up their link lines. The link code is \"BANKGEMEIN\" if you want to help me out. Poke around while you're in there --- maybe you'll find something useful." },
				{ date = 111658, to = "Red Jack", from = "Someone", message = "The word is that Lupus and his modern friends are the ones burning the banks, So ask him about your dough." },
			}
		},
		['bbs2'] = {
			type = "list",
--			unlockid = "loser_bbs2",
			hasDetails = true,
			columns = { { field = 'date', width = 8 }, { field = 'to', width = 20 }, { field = 'from', width = 0 } },
			formatDetails = function(item) return string.format("TO: %s\nFROM: %s\n%s", item.longfrom or item.from, item.longto or item.to, item.message) end,
			items = {
				{ date = 111658, to = "Ernie", from = "Bert", message = "Thanks for turning me on to that great software in the Loser library! I downloaded the PikUpGirls soft and it change my whole life! It told me all about What WoMen Really Want! Now I've got so many women after me, I barely have time t jack in!" },
				{ date = 111658, to = s.name, from = "Matt Shaw", message = "Watch out for BLAMMO software. It'll put your eye out." },
				{ date = 111658, to = "Chipdancer", from = "Count Floyd", message = "Want to hear something scary? Quixote disappeared on his way out to Bank G. last night. Sancho stayed with him for half the trip, but he had to bail out when Quixote sent him back for more icebreakers. When Sancho got back, Q was gone." },
				{ date = 111658, to = "Don Quixote", from = "Chipdancer", message = "After those windmills again, eh? If you're serious about hitting Bank Gem. again, EINHOVEN should make it easier." },
				{ date = 111658, to = "Count Floyd", from = "Matt Shaw", message = "Chill out Count. Quixote blipped into Gridpoint early this morning. He said he had to leave town because of a death in the family. No worries." },
				{ date = 111658, to = "Dr. Asano", from = "Matsumoto", message = "Gorota's missing and it's all your fault, you crazy old man! You activated that COMSAT for him at Mission Control! Now's he's way off in cyberspace somewhere! You'd better get out and start looking for him, or I'll tell the Turing people all about your pet project!" },
				{ date = 111658, to = "Matsumoto", from = "Turing", message = "We just happened to glance over your message to Dr. Asano. We'd like to hear about this pet project you were referring to." },
			}
		},
		['software'] = {
			type = "download",
			items = {
				{ key = 'x', text = "Exit to Main", target = "main" },
				{ key = '1', software = 282 }, -- PikUpGurls 1.0
				{ key = '2', software = 215 }, -- BlowTorch 1.0
				{ key = '3', software = 233 }, -- Hammer 1.0
				{ key = '4', software = 254 }, -- Probe 3.0
				{ key = '5', software = 263, condition = function(self) return self.level >= 3 end }, -- Slow 1.0
				{ key = '6', software = 239, condition = function(self) return self.level >= 3 end  }, -- Injector 1.0
				{ key = '7', software = 229, condition = function(self) return self.level >= 3 end  }, -- Drill 1.0
			}
		}
	}
}
loser=Loser
-- Coord.--1-416/64  AICoord.--1-one
