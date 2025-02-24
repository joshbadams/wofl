
StreetWest1 = Room:new {
	name = "streetwest1",
	
	east = "streetwest2",
}

function StreetWest1:GetConnectingRoom(direction)
	if (direction == "north") then
		ShowMessage("Chatsubo is closed for good.")
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end
streetwest1 = StreetWest1


StreetWest2 = Room:new {
	name = "streetwest2",
	
	west = "streetwest1",
	east = "streetcenter1",
	north = "bodyshop",
	south = "donutworld",
}
streetwest2 = StreetWest2

StreetCenter1 = Room:new {
	name = "streetcenter1",
	
	east = "massageparlor",
	west = "streetwest2",
	north = "larrys",
	south = "streetcenter2",
}
streetcenter1 = StreetCenter1

StreetCenter2 = Room:new {
	name = "streetcenter2",
	
	east = "shins",
	north = "streetcenter1",
	south = "streetcenter3",
}
streetcenter2 = StreetCenter2

function StreetCenter2:GetConnectingRoom(direction)
	if (direction == "east" and s.shins > 0) then
		return nil
	end

	return Room.GetConnectingRoom(self, direction)
end

StreetCenter3 = Room:new {
	name = "streetcenter3",
	
	-- east = "streetmain1",
	west = "cheaphotel",
	north = "streetcenter2",
	south = "streetcenter4",
}
streetcenter3 = StreetCenter3

StreetCenter4 = Room:new {
	name = "streetcenter4",
	
	west = "gentlemanloser",
	north = "streetcenter3",
	south = "streetcenter5",
	
	longDescription = ""
}
streetcenter4 = StreetCenter4

StreetCenter5 = Room:new {
	name = "streetcenter5",
	
	-- west = "maas",
	east = "deane",
	north = "streetcenter4",
	-- south = "streetcenter6",
	
	longDescription = ""
}
streetcenter5 = StreetCenter5

----------------------------------------------------------------------------------

-- state:
-- 0: walking in first time, or after using coptalk
-- 1: has chosen "I came in for a donut. Is there some law against that?", which activates some options without kicking out
-- 2: has left room and come back, angering cop
-- 3: used CopTalk in state 0
-- 4: used CopTalk in state 2
-- 5: has used CopTalk and is talking cop stuff
s.donutworld = 0
DonutWorld = Room:new {
	
	name = "donutworld",
	onEnterConversation = "onEnter",
	hasPerson = true,
	
	north = "streetwest2",
	
	longDescription = "This is a Donut World. A SEA cop who looks like a sumo wrestler is eating donuts and caffeine at a table by the door. He gives you an ugly look when you walk in.",
	description = "This is Donut World.",
	
	conversations = {
		{
			tag = "onEnter",
			lines = { function() if (s.donutworld < 2) then return "Hey! We don't allow your kind in Donut World, hamsterhead." else
				return "Back again? I warned you once. Looking for trouble, citizen?" end end }
		},
				
		{
			condition = function() return s.donutworld < 2 or s.donutworld == 3 end,
			options = {
				{
					condition = function() return s.donutworld == 3 or s.donutworkd == 4 end,
					line = function() if (s.donutworld == 3) then return "Sure and begorrah, O'Riley. If you don't recognize me, you'll get my Irish up." else
						return "Well, now! My Irish eyes are smiling, O'Riley! Corned beef and cabbage! Got any news?" end end,
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 5; end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I came in for a donut. Is there some law against that?",
					response = "This is a donut shop, citizen. Only cops are allowed in donut shops.",
					onEnd = function() s.donutworld = 1; print("setting to 1") end
				},
				{
					condition = function() return s.donutworld == 0 end,
					line = "I'm looking for pirated software.",
					response = "That's it your under arrest.",
					onEnd = function() GoToRoom("streetwest2"); ShowMessage("<You were arrested>") end
				},
				{
					line = "Drop dead, flatfoot.",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "You'll never take me alive, copper!",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Forgive me, sir. I thoroughly despise myself for making such a blunder.",
					response = "Just don't let me caatch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
				{
					condition = function() return s.donutworld == 1 end,
					line = "Am I ever going to catch a break in this game?",
					response = "Just don't let me caatch you in here again. How get out of here.",
					onEnd = function() GoToRoom("streetwest2") end
				},
			}
		},
		{
			condition = function() return s.donutworld == 2 or s.donutworld == 4 end,
			options = {
				{
					condition = function() return s.donutworld == 4 end,
					line = "Well, now! My Irish eyes are smiling, O'Riley! Corned beef and cabbage! Got any news?",
					response = "Finnegan, old pal! Top of the mornin' to you! I didn't recognize you!",
					onEnd = function() s.donutworld = 5; end
				},
				{
					line = "Can't a man get a donut in this town without getting arrested?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Yeah, I'm looking for trouble. Have you seen any?",
					response = "That's it your under arrest.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "Sorry, my mistake. I left my brain in my other pants.",
					response = "I've warned you about this before! You're under arrest!",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
			}
		},
		
		{
			condition = function() return s.donutworld == 5 end,
			options = {
				{
					line = "Begorrah! I forgot the comlink number for the Chiba Tactical Police!",
					response = "Don't worry. It's KEISATSU. Better write it down this time.",
				},
				{
					line = "What's the password for the Software Enforcement Agency? Is it \"Wild Irish Rose?\"",
					response = "Wild Irish Rose is a hooker on Memory Lane! The coded SEA password is SMEEGLDIPO, remember?",
				},
				{
					line = "O'Riley! I heard the changed the Fuji Electric passwi=ord to \"Uisquebaugh.\" Is that right?",
					response = "The coded Fuji password is ABURAKKOI. They haven't changed it in years.",
				},
			}
		},
	}
}

function DonutWorld:UseSkill(skill)
	-- if using CopTalk before we've opened our mouth, active cop mode
	if (skill.name == "CopTalk" and not s.hasTalkedInRom) then
		if (s.donutworld < 2) then
			s.donutworld = 3
		else
			s.donutworld = 4
		end

		-- immediately talk
		self:ActivateConversation()
	end

end

function DonutWorld:OnEnterRoom()
	s.dw_usingCopTalk = false
	Room.OnEnterRoom(self)
end

function DonutWorld:OnExitRoom()
	if (s.donutworld < 2) then
		s.donutworld = 2
	elseif (s.donutworld >= 3) then
		s.donutworld = 0
	end
end

donutworld = DonutWorld

-------------------------------------------------------------------------------------

LarryCopTalkShop = ShopBox:new {
	items = { 400 },
}

s.larrys = 0
Larrys = Room:new {
	name = "larrys",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	
	south = "streetcenter1",
	
	longDescription = "LARRY'S is one of Chiba's dubious software stores. The walls are lined with slivers of microsoft, spikes of colored silicon mounted on cardboard for display. The shaved head of Larry Moe, with dozens of Microsofts protruding from the carbon socket behind is left ear, is visible beside the counter.",
	description = "LARRY'S is one of Chiba's dubious software stores.",

	conversations = {
		{
			tag = "onEnterRoom",
			lines = { "You looking to buy some softs?" },
		},
		
		{
			condition = function() return s.larrys == 0 end,
			options = {
				{
					line = "Got anything good?",
					response = "All my softs are top quality. Too bad I don't have any right now!"
				},
				{
					line = "I'm looking for the Panther Moderns.",
					response = "The Moderns don't like networking with strangers",
					onEnd = function() s.larrys = 1 end
				},
				{
					line = "I'm a cop. You're under arrest unless you answer some questions.",
					response = "You're not a cop. You're a meatball. I'm calling the Lawbot.",
					onEnd = function() ShowMessage("<You were arrested>"); GoToRoom("streetwest2") end
				},
				{
					line = "It's cold outside. I just wanted to come in here and warm up.",
					response = "I'll warm you up with a flamethrower if you don't get out of here, pal.",
					onEnd = function() GoToRoom("streetcenter1") end
				},
				{
					line = "Do you know anything about",
					hasTextEntry=true,
					onEnd = function() s.larrys = 3; print("larrry", s.larrys) end
				}
			}
		},
		
		{
			condition = function() return s.larrys == 1 end,
			options = {
				{
					line = "Does that include wealthy strangers? I can pay for a meeting.",
					response = "How much would you pay for a meeting with the Moderns?",
					onEnd = function(self) s.larrys = 2; self:ActivateConversation() end
				},
				{
					line = "You I have a sudden urge to buy something.",
					response = "All my softs are top quality. Too bad I don't have any right now!"
				},
				{
					line = "You're calling ME strange? Have you looked at yourself lately?",
					response = "How much would you pay for a meeting with the Moderns?",
					onEnd = function(self) s.larrys = 2; self:ActivateConversation() end
				},
				{
					line = "Do you know anything about",
					hasTextEntry=true,
					onEnd = function() s.larrys = 3 end
				}
			}
		},

		{
			condition = function() return s.larrys == 2 end,
			options = {
				{
					line = "100 credits.",
					onEnd = function(self) self:HandlePay(100) end
				},
				{
					line = "200 credits.",
					onEnd = function(self) self:HandlePay(200) end
				},
				{
					line = "300 credits",
					onEnd = function(self) self:HandlePay(300) end
				},
				{
					line = "Whoops! I don't have any money!",
					onEnd = function(self) self:HandlePay(99999999) end
				}
			}
		},
		
		{
			condition = function() return s.larrys == 3 end,
			options = {
				{
					line = "Do you know anything about",
					hasTextEntry=true,
				}
			}
		},

		{
			tag = "getOut",
			lines = { "No money, no meeting. Jack out, clown.", },
			onEnd = function() GoToRoom("streetcenter1") end
		},
		
		{
			tag = "paid",
			lines = {
				"All right. Payment in advance. Let's have at it...",
				"What a rube! You really think I'm going to let you just walk right in there? But thanks for the donation!",
			},
		},
		
		{
			tag = "_unknownentry",
			lines = { "You'd know more I would about that." }
		},
		
		{
			tags = { "_skills", "_skill", "_coptalk", "_chip" },
			lines = { "I can seel you a CopTalk skill chip. $100." },
			onEnd = function() OpenBox("LarryCopTalkShop") end,
		},
	},
}

function Larrys:HandlePay(amount)
	if (s.money >= amount) then
		s.money = s.money - amount
		self:ActivateConversation("paid")
	else
		self:ActivateConversation("getOut")
	end
end

function Larrys:OnEnterRoom()
	s.larrys = 0
	Room.OnEnterRoom(self)
end

larrys = Larrys

-------------------------------------------------------------------------------------

s.massageparlor = 1
MassageParlor = Room:new {
	name = "massageparlor",
	onEnterConversation = "onEnterRoom",
	hasPerson = true,
	
	west = "streetcenter1",
	
	longDescription = "A beautiful woman names Akiko is waiting for you here beside a massage table. This is a clean shop with a stainless steel floor.",
	
	description = "The massage parlor.",
		
	conversations = {
		{
			tag = "onEnterRoom",
			lines = { "Greetings, cowboy. What service may I perform for you today?" },
		},
		
		{
			tag = "lawbot",
			lines = {
				"Look out! It's the lawbot!",
			},
			onEnd = function() ShowMessage("<You were arrested>", function() GoToRoom("streetcenter1") end, true) end
		},

		{
			tag = "moreinfo",
			lines = { "I have more info, if you have more money," },
			onEnd = function(self) print("switchibnv to lawbot"); self:ActivateConversation("lawbot") end
		},

		{
			options =
			{
				{
					line = "I'm sure I'll think of something.",
					onEnd = function(self) print("self", self); self:ActivateConversation("lawbot") end
				},
				{
					line = "Uhh, excuse me, I'm just passing through...",
					response = "You don't know what your missing, cowboy.",
					onEnd = function(self) self.stoptalking = true end
				},
				{
					line = "I wanna buy some info, babe.",
					response = function(self) return self:BuyInfo() end,
					onEnd = function(self) self:ActivateConversation(self.nextConvo) end
				},
			}
		},
	},
	
	info = {
		[1] = { cost = 20, message = "Here's a hot tip. The Panther Modern link code is \"CHAOS\". The password is \"MAINLINE\". They can help you." },
		[2] = { cost = 50, message = "The banking center is on the Freeside orbital colony, but the link number for the Bank of Zurich is \"BOZOBANK\"." },
		[3] = { cost = 75, message = "Be careful when dealing with the Moderns. Not all of them will be your friends." },
		[4] = { cost = 100, message = "Some cowboy said he avoids court fees when he gets arrested by setting up multiple bank accounts." },
		[5] = { cost = 150, message = "Just heard that Mass Biolabs finished work on a cyberspace superdeck they call \"CyberEyes\". Apparently, with CyberEyes, you don't need a regular cyberdeck to get around in cyberspace. It stores programs in your head!" },
	},

	
	stoptalking = false
}


function MassageParlor:BuyInfo()
print("buy info", self);
	
	if (s.money < self.info[s.massageparlor].cost) then
		self.nextConvo = "lawbot"
		return "Take a hike, meatball! You can't afford it!"
	elseif (s.massageparlor <= #self.info) then
		self.nextConvo = "moreinfo"
		s.money = s.money - self.info[s.massageparlor].cost
		s.massageparlor = s.massageparlor + 1
		return self.info[s.massageparlor - 1].message
	else
		self.nextConvo = "lawbot"
		return "You know more than me now."
	end
end

massageparlor = MassageParlor

function MassageParlor:OnEnterRoom()
	print("massage salf", self)
	Room.OnEnter(self)
end

function MassageParlor:GetNextConversation(tag)
	if (self.stoptalking) then
		return nil
	end

	return Room.GetNextConversation(self, tag)
end

---------------------------------------------------------------------------

s.shins = 0

Shins = Room:new {
	name = "shins",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetcenter2",
	
	longdescription = "Shin's Pawn Shop is filled with odd looking junk that nobody wants, glued to thei respective display shelves by time and dirt. The smell of raw fish wafts in from a nearby sushi stall. Shin eyes you with a mixture of hope, greed and suspicion.",
	
	hasAskedAboutRush = false,
	boughtDeck = false,
	
	conversations = {
		{
			tag = "onEnter",
			lines = { "Ah. You back. I have your deck. " },
			onEnd = function(self) self:ActivateConversation("firstChoice") end,
		},
		
		{
			tag = "firstChoice",
			options =
			{
				{
					condition = function(self) print("self",self); return not self.hasAskedAboutRush end,
					line = "Why are you in such a rush to give me my deck back?",
					response = "Your deck scare away good customer. No more favor.",
					onEnd = function(self) self.hasAskedAboutRush = true; self:ActivateConversation("firstChoice") end
				},
				{
					line = "Okay. Give me the deck. I can't operate without one.",
					response = function(self) if table.containsArrayItem(s.inventory, 1) then return "Give ticket and money. Shin busy. Many customer." else
						return "No have ticket? Shin give deck anyways." end end,
					onEnd = function(self)
							table.removeArrayItem(s.inventory, 1)
							local shop = OpenBox("ShinShop")
						end
				},
				{
					line = "I don't have the cash right now, I'll come back later.",
					response = "What? I no want deck! Here! Take deck now! No charge! Go away!",
					onEnd = function(self) ShowMessage("Shin gives you your deck."); table.append(s.inventory, 100); self:ActivateConversation("secondChoice") end
				},
			}
		},

		{
			tag = "secondChoice",
			options =
			{
				{
					condition = function(self) return self.boughtDeck end,
					line = "Thanks for my deck, Shin. I really appreciate you looking after it.",
					onEnd = function(self) self:KickedOut() end,
				},
				{
					line = "Okay, pal! I'll go away! And I'll tell all my friends about this place!",
					onEnd = function(self) self:KickedOut() end,
				},
				{
					condition = function(self) return not self.boughtDeck end,
					line = "Thanks, Shin. I knew you'd see it my way.",
					onEnd = function(self) self:KickedOut() end,
				},
			}
		},
		
		{
			tag = "boughtChoice",
			options =
			{
				{
					line = "Thanks, Shin. I knew you'd see it my way.",
					onEnd = function(self) ShowMessage("Shin slams the door <smething>") GoToRoom("streetcenter2") end,
				},
			}
		}

	}
}
shins = Shins

function Shins:KickedOut()
	ShowMessage("Shin slams and bolts the door behind you.", function() GoToRoom("streetcenter2") end, true)
end

function Shins:OnExitRoom()
	s.shins = 1
end

ShinShop = ShopBox:new {
	items = { 100 },
}

function ShinShop:OnBoughtSoldItem(clickId)
	ShopBox.OnBoughtSoldItem(self, clickId)

	Shins.boughtDeck = true
	Shins:ActivateConversation("secondChoice")
end

function ShinShop:CannotAfford(itemIndex)
	ShopBox.CannotAfford(self, itemIndex)
	Shins:ActivateConversation("firstChoice")
end

function ShinShop:HandleClickedExit()
	Shins:ActivateConversation("firstChoice")
	self:Close()
end


--------------------------------------------------------------------------

s.deane = 1
Deane = Room:new {
	name = "deane",
	hasPerson = true,
	onEnterConversation = "onEnter",
	
	west = "streetcenter5",
	
	longdescription = "You find Julius Deane's office in a warehouse behind Ninsei. You get the impression Julius has a gun pointed at you under the desk.",
	description = "In Julius Deane's office.",
	
	conversation = {
		{
			tag = "onEnter",
			lines = { "What brings you around, boyo? I deal in exotic hardware and information." },
		},
			
		{
			condition = function() return s.deane == 1; end,
			options = {
				{
					line = "I'm just looking around right now.",
					response = "Go hand around someone else's office. I'm a busy man.",
					onEnd = function() GoToRoom("streetcenter5"); end
				},
				{
					line = "My friends tell me that someone is trying to kill me. Heard anything?",
					response = "Not always easy to know who your friends are, is it? I haven't heard anything about it.",
					onEnd = function() s.deane = 2; end
				},
				{
					line = "What do you know about",
					hasTextEntry=true,
					onEnd = function() s.deane = 3; end
				}

			}
		},
		
		{
			condition = function() return s.deane == 2; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
					onEnd = function() s.deane = 3; end
				},
				{
					line = "Maybe the people from Cheap Hotel are after me? I ran up a big bill there.",
					response = "Of course, if I did hear something, I might not be able to tell you. Biz being what it is, you understand.",
					onEnd = function() s.deane = 1; end
				},
			}
		},
		
		{
			condition = function() return s.deane == 3; end,
			options = {
				{
					line = "What do you know about",
					hasTextEntry=true,
				},
			}
		},
		
		{
			tags = { "_cryptology", "_upgrade" },
			lines = { "I can upgrade you in Cryptology for $2500 per level if you already have the skill chip." },
			onEnd = function() OpenBox("DeaneCryptoShop") end
		},
		{
			tags = { "_chip" },
			lines = { "I've got Bargaining, Psychoanalysis, Philosophy, and Phenomenology at $1000 each. Or I can upgrade certin skills." },
			onEnd = function() OpenBox("DeaneSkillShop") end
		},
		{
			tags = { "_neuromancer" },
			lines = { "It's an old novel by Willam Gibson." },
		},
		{
			tags = { "_fuji" },
			lines = { "I've heard the password is \"DUMBO\", but that's probably in code." },
		},
		{
			tags = { "_hitachi" },
			lines = { "Just one word you need to remember: \"GENESPLICE\"." },
		},
		{
			tags = { "_hosaka" },
			lines = { "I've heard the password is \"VULCAN\" but that's probably in code." },
		},
		{
			tags = { "_musabori" },
			lines = { "I've heard the password is \"PLEIADES\", but that's probavly in code." },
		},
		{
			tags = { "_hardware" },
			lines = { "Only have one thing right now. Maybe you're interested in it." },
			onEnd = function() OpenBox("DeaneGasMaskShop") end
		},
		{
			tags = { "_software" },
			lines = { "Try the Finn at Metro Holografix for that sort of thing." },
		},
	}
}

deane = Deane
